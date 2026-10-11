# Executed validation

Validated on Windows 11, R 4.4.0, survival 3.5-8. Exact analysis and reporting package sessions are included in `results/sessionInfo.txt` and `results/report_sessionInfo.txt`.

- Entire modular analysis executed successfully with `Rscript --vanilla run.R`.
- Asserted 1,858 raw records, 929 distinct patients, unique patient/event pairs and matching baseline covariates across paired records.
- Checked valid event indicators, positive times and one OS row per patient.
- Checked recurrence-or-death endpoint logic against recurrence-first, death-first, censoring-first and tied-event synthetic cases.
- Confirmed complete-case cohort: 888 participants, 430 deaths, 41 exclusions; audited 12 nodes/node4 inconsistencies.
- Checked identical Cox/AFT cohorts, finite Cox coefficients and AICs, standardized curve probabilities within [0,1], and all expected figure files.
- Rendered the R Markdown source to self-contained HTML using knitr/rmarkdown and RStudio's bundled Pandoc.
- Visually inspected KM/risk table, Cox forest, Schoenfeld and parametric curve figures; corrected risk-table spacing and diagnostic labels.
- Compared regenerated numerical CSV tables against the preceding run after final formatting changes (see `results/reproducibility_check.txt`).

The analysis identified global evidence against proportional hazards (p approximately 0.000216), particularly obstruction and differentiation. This is reported explicitly and addressed with exploratory diagnostic-driven stratification as well as predefined treatment sensitivities. It is not presented as proof of constant prognostic hazard ratios. Log-normal had the smallest candidate AFT AIC; this does not validate extrapolation.

Environment startup emitted locale warnings and fell back to the C locale. The analysis and report completed successfully. Reporting packages were installed into an intermediate workspace library; that platform-specific library is not shipped. Install the reporting dependencies described in README to re-render on another machine. Analysis requires only base/recommended R and survival; data and generated results are shipped.

The figures were inspected, but full browser visual inspection of the final HTML layout was not performed. Statistical assumptions, independent censoring, external validity and the original trial protocol cannot be validated by these software checks. No PDF manuscript or renv lockfile is claimed.
