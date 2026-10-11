# Endpoint and variable dictionary

Source: the installed survival package; the raw snapshot is exported by `run.R`.

| Field | Meaning and handling |
|---|---|
| id | Patient identifier; pair recurrence/death records on this field |
| study | Study indicator; 1 in this dataset |
| etype | 1 recurrence; 2 death; never pooled as independent OS observations |
| time | Days to endpoint event/censoring, positive numeric |
| status | 1 event, 0 right censored |
| rx | Randomized Obs, Lev, Lev+5FU; Obs reference |
| age / age10 | Age in years / age divided by 10 |
| sex | 0 female, 1 male; female reference |
| nodes / lognodes | Positive node count / log(1 + count) |
| node4 | Indicator >4 positive nodes; discrepancy audited, excluded from primary model |
| obstruct | Colon obstruction by tumour, 0/1 |
| perfor | Colon perforation, 0/1 |
| adhere | Adherence to nearby organs, 0/1 |
| differ | 1 well, 2 moderate, 3 poor; unordered factor |
| extent | 1 submucosa, 2 muscle, 3 serosa, 4 contiguous structures; unordered factor |
| surg | Surgery-to-registration interval, 0 short, 1 long; exact category cutpoint unavailable |

OS uses death-record `time` and `status`. The exploratory composite uses `min(recurrence_time, death_time)` and sets event=1 if either record has an event at that minimum time, including tied events. When an endpoint is censored before the other event, censor the composite at the earlier time. This avoids assuming unobserved recurrence-free follow-up. It does not recover a protocol DFS endpoint with certainty.

Source documentation: https://stat.ethz.ch/R-manual/R-devel/library/survival/html/colon.html
