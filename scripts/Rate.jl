using Arrow
using BenchmarkTools
using Chain
using DataFrameMacros
using DataFrames
using LinearAlgebra
using MixedModels
using MKL
using StandardizedPredictors

println("nthreads = ", Threads.nthreads())

const dat = @chain "./arrow/ldt_trial.arrow" begin
    Arrow.Table()
    DataFrame()
    leftjoin(DataFrame(Arrow.Table("./arrow/ldt_item.arrow")); on=:item)
    leftjoin(DataFrame(Arrow.Table("./arrow/ldt_subj.arrow")); on=:subj)
    disallowmissing!(; error=false)
    @subset(!ismissing(:acc) && :acc && 250 ≤ :rt ≤ 4000)
    @transform(:S2 = :seq > 2000, :rate = 1000 / :rt, :lg1pOrth = log1p(:Ortho_N))
end

println("size(dat) = ", size(dat))

println(describe(dat))

const contrasts = Dict(
    :subj => Grouping(),
    :item => Grouping(),
    :sex => HelmertCoding(),
    :univ => EffectsCoding(base="Wash. Univ"),
    :vocabAge => Center(17),
    :isword => HelmertCoding(),
    :S2 => HelmertCoding(),
    :wrdlen => Center(7),
    :lg1pOrth => Center(1),
    :BG_Mean => Center(2000),
)

m4 = let
    form = @formula(
        rate ~ 1 + S2 +                         # trial-level covariate
        isword * wrdlen + lg1pOrth + BG_Mean +  # item-level covariates
        vocabAge + univ +                       # subject-level covariates
        (1 + vocabAge|item) + (1 + wrdlen|subj))# random effects
    LinearMixedModel(form, dat; contrasts)
end;

restoreoptsum!(m4, "optsums/m4.json")
println(m4)

@benchmark objective(updateL!(setθ!($m4, $(m4.optsum.final))))

l22 = m4.L[3];
l21 = m4.L[2];
@benchmark MixedModels.rankUpdate!($(Symmetric(l22, :L)), $l21, 1.0, 0.0)
@benchmark MixedModels.rankUpdate!($(Symmetric(l22, :L)), $l21, 1.0, 0.0)
