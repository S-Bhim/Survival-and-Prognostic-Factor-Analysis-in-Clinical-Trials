# Survival and Prognostic Factor Analysis in Clinical Trials

A complete educational R project using the randomized historical `survival::colon` trial dataset.

## Run

Requirements: R >= 4.4 and `survival`. Run from the project folder:

```sh
Rscript run.R
```

This writes analysis-ready datasets, full-precision CSV tables, vector PDF and 300-dpi PNG figures, models, a dependency-free HTML report, checksums, validation results and session information. The core analysis uses only base/recommended R packages and does not install packages or download data. The source of truth is the installed survival dataset; see `results/sessionInfo.txt` for the validated version.

To render the formatted, self-contained R Markdown report, install reporting dependencies in your R environment:

```r
install.packages(c("rmarkdown", "knitr"), repos="https://cloud.r-project.org")
```

Pandoc is also required (included with RStudio). Then:

```sh
Rscript render_report.R
```

If Pandoc is not detected, set `RSTUDIO_PANDOC` to its containing directory. Scripts locate the project from their own path. Individual modules execute within `run.R` and share its analysis objects; to run a module interactively, first source configuration and all preceding modules. Do not execute later modules against stale objects.

## Design

- Primary endpoint: overall survival, only death records (`etype=2`), one record per patient.
- Exploratory endpoint: earliest observed recurrence or death, conservatively censored at the shorter paired follow-up window. Not claimed to reproduce a protocol-defined DFS endpoint.
- All-patient unadjusted KM/log-rank; complete-case prespecified Cox/AFT analysis.
- Global and Holm-adjusted pairwise log-rank tests; KM landmarks and reverse KM follow-up.
- Adjusted/unadjusted Cox HRs, Schoenfeld tests/plots, martingale diagnostics, influence flags, spline sensitivity, treatment-stratified and fixed two-year interaction sensitivities.
- Exponential, Weibull, log-normal and log-logistic AFT models, comparable AIC/BIC, time ratios, standardized survival and censored Cox-Snell diagnostics.
- Baseline tables show missingness and include all arm patients in percentage denominators. No baseline p-values or stepwise model selection.

The package documents an inconsistency between `nodes` and `node4`; this project exports affected records and uses `log1p(nodes)` without repairing or simultaneously fitting the redundant field. Characteristic effects are prognostic associations, not causal effects. Treatment assignment supports randomized comparisons, subject to model/censoring assumptions and complete-case selection. This is not a clinical recommendation or validated prediction model.

## Structure

`R/00_config.R` defines settings/helpers; `01_data` audits paired records and creates endpoints; `02_descriptive` creates baseline summaries; `03_km` fits KM/log-rank; `04_cox` fits Cox/diagnostics/sensitivity; `05_parametric` fits AFT models; `06_report` creates portable HTML. `tests/validate.R` checks patient structure, endpoint logic (including synthetic edge cases), cohorts, numerical outputs and generated figures. `report/report.Rmd` is the narrative R Markdown source.

`data/` and `results/` are generated and may be overwritten on rerun. PNG/PDF figures are shareable publication-style artifacts; clinical manuscript submission would still require journal-specific labeling and statistical review. The report uses model-generated results rather than hardcoded estimates.

## Reproducibility boundaries

The delivered session information records the actual R/survival versions. Reproduce with those versions for strongest equivalence. There is no fabricated `renv.lock`: reporting dependencies are optional and not pinned. Tests do not prove that statistical assumptions hold. See `VALIDATION.md` for actual execution and limitations.

## Sources

- https://stat.ethz.ch/R-manual/R-devel/library/survival/html/colon.html
- https://stat.ethz.ch/R-manual/R-devel/library/survival/html/coxph.html
- https://stat.ethz.ch/R-manual/R-devel/library/survival/html/cox.zph.html
- https://stat.ethz.ch/R-manual/R-devel/library/survival/html/survreg.html

Use the package documentation for original trial references: its bibliography contains apparent year/volume inconsistencies, so verify the original publications before citing them in a manuscript.
