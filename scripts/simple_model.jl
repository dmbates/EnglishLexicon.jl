using AlgebraOfGraphics
using Arrow
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
            !ismissing(:acc) && :acc && (200 < :rt < 4000) # bounds may need adjustment
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

m1 = let formula = @formula(1000/rt ~ 1 + sex + vocabAge + isword+wrdlen+(1|item)+(1|subj))
    fit(MixedModel, formula, dat; contrasts, thin)
end

qqcaterpillar(m1, :subj)

m2 = let formula = @formula(
    1000/rt ~ 1 + sex + vocabAge + isword + wrdlen +
    (1 + sex + vocabAge | item) +
    (1 + isword + wrdlen | subj))
    restoreoptsum!(
        LinearMixedModel(formula, dat; contrasts),
        "./optsums/additive_fe_additive_re.json",
        )
end

m3 = let formula = @formula(
    1000/rt ~ 1 + sex * vocabAge * isword * wrdlen +
    (1 + sex + vocabAge | item) +
    (1 + isword + wrdlen | subj))
    restoreoptsum!(
        LinearMixedModel(formula, dat; contrasts),
        "./optsums/multiplicative_fe_additive_re.json",
        )
end

m4 = let formula = @formula(
    1000/rt ~ 1 + sex * vocabAge * isword * wrdlen +
    (1 + sex * vocabAge | item) +
    (1 + isword * wrdlen | subj))
    restoreoptsum!(
        LinearMixedModel(formula, dat; contrasts),
        "./optsums/multiplicative_fe_multiplicative_re.json",
        )
end
