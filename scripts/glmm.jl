using AlgebraOfGraphics
using Arrow
using BenchmarkTools
using CairoMakie
using DataFrameMacros
using DataFrames
using MixedModels
using MixedModelsMakie
using MKL
using StandardizedPredictors

items = DataFrame(Arrow.Table("./arrow/ldt_item.arrow"));
subj = DataFrame(Arrow.Table("./arrow/ldt_subj.arrow"));
trials = DataFrame(Arrow.Table("./arrow/ldt_trial.arrow"));

dat = leftjoin(
    leftjoin(
        @subset(
            trials,
            !ismissing(:acc) && (200 < :rt < 4000) # bounds may need adjustment
        ),
        select(items, :item, :isword, :wrdlen),
        on=:item,
    ),
    select(subj, :subj, :sex, :vocabAge),
    on=:subj,
)

nobs_subj = combine(groupby(dat, :subj), nrow => :n);

extrema(nobs_subj.n)

data(nobs_subj) * mapping(:n => "Number of observations per subject") * AlgebraOfGraphics.density() |> draw

contrasts = Dict(
    :subj => Grouping(),
    :item => Grouping(),
    :isword => HelmertCoding(),
    :sex => HelmertCoding(),
    :wrdlen => Center(8),
    :vocabAge => Center(17),
);

thin = 1;   # preserve all evaluations in optsum.fitlog

formula = @formula(acc ~ 1 + wrdlen + vocabAge + (1 | item) + (1 | subj))

@time fit(MixedModel, formula, dat, Bernoulli(); fast=true, contrasts, thin)

@time fit(MixedModel, formula, dat, Bernoulli(); fast=true, contrasts, thin, lmminit=[:β, :θ])
@time fit(MixedModel, formula, dat, Bernoulli(); fast=true, contrasts, thin, lmminit=[:θ])
@time fit(MixedModel, formula, dat, Bernoulli(); fast=true, contrasts, thin, lmminit=[:β])


@time m = fit(MixedModel, formula, dat, Bernoulli(); fast=false, contrasts, thin);
@time mβθ = fit(MixedModel, formula, dat, Bernoulli(); fast=false, contrasts, thin, lmminit=[:β, :θ]);
@time mθ = fit(MixedModel, formula, dat, Bernoulli(); fast=false, contrasts, thin, lmminit=[:θ]);
@time mβ = fit(MixedModel, formula, dat, Bernoulli(); fast=false, contrasts, thin, lmminit=[:β]);


df = DataFrame(; parameter=first.(m.optsum.fitlog), objective=last.(m.optsum.fitlog))
df[!, :init] .= "glm"
df[!, :iter] = 1:nrow(df)

for (init, model) in ["lmm-βθ" => mβθ, "lmm-θ" => mθ, "lmm-β" => mβ]
    df2 = DataFrame(; parameter=first.(model.optsum.fitlog), objective=last.(model.optsum.fitlog))
    df2[!, :init] .= init
    df2[!, :iter] = 1:nrow(df2)
    append!(df, df2)
end

Arrow.write("glmm_fitlog_by_init.arrow", df; compress=:zstd)

data(filter(:iter => <(50), df)) * mapping(:iter, :objective; color=:init) * visual(Lines) |> draw

data(filter(:iter => >(50), df)) * mapping(:iter, :objective; color=:init) * visual(Lines) |> draw
