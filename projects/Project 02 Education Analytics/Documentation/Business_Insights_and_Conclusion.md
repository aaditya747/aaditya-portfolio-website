# Business Insights and Conclusion

[← Back to README](../README.md)

> **How to read this document:** sections 2–6 report **measured findings** from the data. Sections 7 and 8 contain **interpretation and recommendations**, which are judgements based on those findings and are not proven by them. All results are descriptive associations on subject records (not unique students) and do not establish causation.

---

## 1. Executive Summary

The project analysed 1,044 subject records (395 Mathematics and 649 Portuguese) from the UCI Student Performance dataset. Overall, 814 records pass (G3 ≥ 10) and 230 fail, a **77.97% pass rate**, with an average final grade of **11.34** on a 0–20 scale.

| Headline | Finding |
|---|---|
| Subject gap | Portuguese records average 11.91 vs 10.42 in Mathematics; pass rates are 84.59% vs 67.09% |
| Attendance | Records with more than 15 absences (54 records, 5.17%) average 10.31 vs 11.40, with a 62.96% vs 78.79% pass rate |
| Study time | Average grade rises from 10.58 (category 1) to 12.49 (category 3) and is 12.27 in category 4 |
| Previous failures | Average grade falls from 12.05 (no failures) to 6.80 (three failures); pass rate falls from 85.02% to 30.00% |
| Prior grades | G2 (+0.911) and G1 (+0.809) are the strongest correlates of the final grade |
| Statistical test | Subject difference is statistically significant (p < 0.001) with a small effect size (Cohen's d = −0.3925) |

## 2. Subject Performance Insights

| Subject | Records | Avg G1 → G2 → G3 | Pass rate | Fail rate | Avg absences |
|---|---:|---|---:|---:|---:|
| Mathematics | 395 | 10.91 → 10.71 → 10.42 | 67.09% | 32.91% | 5.71 |
| Portuguese | 649 | 11.40 → 11.57 → 11.91 | 84.59% | 15.41% | 3.66 |

- Portuguese records outperform Mathematics records by **1.49 grade points** on average and by **17.50 percentage points** in pass rate.
- The trends move in opposite directions: Mathematics averages decline across the three grading periods, while Portuguese averages rise.
- Roughly one in three Mathematics records fails, compared with about one in six Portuguese records.
- Mathematics records also have higher average absences (5.71 vs 3.66).

## 3. Attendance Insights

| Group | Records | Avg absences | Avg G3 | Pass rate |
|---|---:|---:|---:|---:|
| 15 or fewer absences | 990 | 3.43 | 11.40 | 78.79% |
| More than 15 absences | 54 | 22.89 | 10.31 | 62.96% |

- High-absence records average **1.09 points lower** in G3 and have a pass rate **15.83 percentage points lower**.
- They make up only **5.17%** of records, and 20 of the 54 fail (37.04%).
- The overall linear correlation between absences and G3 is about −0.05. High absence is associated with lower results, but absences alone explain little of the variation in final grades across the whole dataset.
- The scatter chart shows wide variation in grades at every absence level, including some high-absence records with relatively high average grades.

## 4. Study-Time Insights

| Study-time category | Records | Avg G3 | Pass rate |
|---:|---:|---:|---:|
| 1 | 317 | 10.58 | 72.56% |
| 2 | 503 | 11.34 | 77.93% |
| 3 | 162 | 12.49 | 85.80% |
| 4 | 62 | 12.27 | 85.48% |

- Higher study-time categories are associated with higher average grades and pass rates, up to category 3.
- Category 4 is slightly below category 3 in average grade and nearly equal in pass rate; with only 62 records, this difference is within what small groups can produce by chance.
- Category 2 is the largest group (503 records, 48.18%).
- The correlation between study time and G3 is weak (+0.162), so study-time category differentiates groups only modestly.
- Study time is an **ordinal category, not hours**.

## 5. Previous-Failures Insights

| Previous failures | Records | Avg G3 | Pass rate |
|---:|---:|---:|---:|
| 0 | 861 | 12.05 | 85.02% |
| 1 | 120 | 8.43 | 51.67% |
| 2 | 33 | 7.48 | 33.33% |
| 3 | 30 | 6.80 | 30.00% |

- This is the **steepest gradient** in the analysis: moving from zero to one previous failure is associated with a **3.62-point** lower average grade and a **33.35-point** lower pass rate.
- Previous failures have the strongest negative correlation with G3 (−0.383) among background variables.
- **183 records (17.53%)** have at least one previous failure, yet they account for about 44% of all failing records (101 of 230). Among them roughly 55% fail, versus about 15% of records with no previous failures. *(Fail counts are derived from the reported pass rates and record counts.)*
- Groups with two or three failures are small (33 and 30 records).

## 6. Statistical Test Interpretation

### Welch's t-test (Mathematics vs Portuguese G3)

- t = −5.6664, p < 0.001 at α = 0.05.
- **Conclusion:** the observed difference between the two subjects' mean final grades is very unlikely to be due to chance alone.

### Cohen's d

- d = −0.3925, a **small** effect by conventional thresholds (0.2 small, 0.5 medium, 0.8 large).
- The negative sign shows that the Mathematics mean is lower.

### Significance versus effect size

Statistical significance answers *"is there a difference?"*. Effect size answers *"how big is it?"*. Here the difference is real in a statistical sense but modest in magnitude: about 1.5 points on a 20-point scale. With 1,044 records, even moderate differences become statistically significant, so the effect size is the better guide to practical importance.

### Correlation

The very strong correlations of G1 and G2 with G3 reflect consistency of grades over time. They are not independent explanatory factors, and correlation does not imply that one variable causes another.

## 7. Business and Educational Implications

*Interpretation – not proven by the data.*

1. **Early grades are an early-warning signal.** Because G1 and G2 track G3 very closely, grades in the first two periods are likely to help identify students at risk of struggling by the final period.
2. **Previous failures mark the highest-risk group.** Records with prior failures have much lower grades and pass rates, so this group may benefit most from targeted support.
3. **Mathematics may need closer attention.** Its lower pass rate and declining period-to-period grades suggest a subject-specific issue worth investigating.
4. **Attendance matters most at the extremes.** Only a small group has high absence, and the overall absence–grade link is weak, so attendance monitoring may be most useful for the small number of students with persistently high absence rather than as a general predictor.
5. **Study-time effects look modest.** Differences between categories exist but the correlation is weak, which suggests the quality of study and prior preparation may matter alongside the amount of study; the data cannot test this.

## 8. Recommendations

*Recommendations are suggestions for further action and are not findings of this analysis.*

| # | Recommendation | Based on |
|---|---|---|
| 1 | Use G1 and G2 results to flag at-risk students early and offer support before the final period | G1/G2 correlation with G3 (+0.809 / +0.911) |
| 2 | Prioritise academic support for students with one or more previous failures | Pass rate 51.67% or lower versus 85.02% |
| 3 | Review Mathematics teaching, assessment and support, and investigate why grades decline across periods | Pass rate 67.09% and declining G1→G3 |
| 4 | Monitor students approaching or exceeding 15 absences and combine attendance data with grades | 62.96% pass rate in the high-absence group |
| 5 | Treat study-time self-reports as one input among several, not as a standalone predictor | Weak correlation (+0.162) |
| 6 | Collect a unique student identifier and further context (teacher, class, term) in future data | Dataset limitations below |
| 7 | Build predictive models only with clear validation and caution about fairness, using prior grades with care | Strong G1/G2 correlation |

## 9. Project Limitations

| Limitation | Effect on conclusions |
|---|---|
| Subject records, not unique students | The same student may be counted in both subjects; student-level conclusions cannot be drawn |
| Observational, descriptive data | No causal conclusions are possible |
| Ordinal and discrete fields | Averages by category are descriptive; category 4 study time is not "four hours" |
| Small groups | High absence (54), study-time category 4 (62), and two or three failures (33 and 30) have less stable estimates |
| Uncontrolled confounding | Differences between groups may partly reflect subject, school or student background |
| Grades of 0 | 53 records have G3 = 0 and the data cannot show whether these are true scores or missing evaluations |
| Single dataset | Findings should not be generalised beyond this source without further evidence |

## 10. Final Conclusion

This project shows that in the UCI Student Performance data, **prior grades and previous failures are the most closely associated with final performance**, **Portuguese records outperform Mathematics records** by a statistically significant but small margin, and **high absence and low study-time categories are associated with lower average outcomes**, although these associations are weaker. The analysis is descriptive: it identifies where performance differs and where support could be targeted, but it does not prove why. Combining Python for statistical rigour with Power BI for interactive communication, the work demonstrates a complete analyst workflow from raw data to decision-ready insight.

## 11. Skills Demonstrated

| Area | Skills |
|---|---|
| Python | Pandas data preparation, merging and feature engineering; NumPy; Matplotlib and Seaborn visualisation |
| Statistics | Descriptive statistics, Pearson correlation, IQR outlier detection, Welch's t-test, Cohen's d, significance versus effect size |
| Power BI | Data import, DAX measures, KPI design, multi-page interactive dashboards, slicers, matrices, consistent theming |
| Data integrity | Reconciliation of totals, validation of Power BI against Python, awareness of unit-of-analysis limits |
| Communication | Separating findings from recommendations, avoiding causal claims, structured technical documentation |
