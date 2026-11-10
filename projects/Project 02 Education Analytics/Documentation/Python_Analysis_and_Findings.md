# Python Analysis and Findings

[← Back to README](../README.md) · Notebook: [`Python/01_Education_Data_Inspection.ipynb`](../Python/01_Education_Data_Inspection.ipynb)

---

## 1. Python Environment and Libraries

| Library | Role in this project |
|---|---|
| Python 3 / Jupyter Notebook | Interactive analysis environment |
| Pandas | Loading, cleaning, merging, grouping and exporting data |
| NumPy | Conditional logic and numeric operations |
| Matplotlib | Base charting |
| Seaborn | Statistical visualisation (distributions, comparisons, correlation views) |
| SciPy | Welch's t-test |
| Scikit-learn | Supporting analytical and statistical utilities |

## 2. Data Loading

Both UCI subject files were loaded with Pandas:

| File | Subject | Records |
|---|---|---:|
| `student-mat.csv` | Mathematics | 395 |
| `student-por.csv` | Portuguese | 649 |

## 3. Data Inspection

Inspection covered the shape of each file, column names, data types, sample rows and summary statistics, to confirm that both files share the same structure before combining them.

## 4. Data Cleaning and Validation

Cleaning and validation checked data types, completeness and value ranges, and reconciled all group totals back to the full dataset. Records were **not** removed because of outlier flags (see Section 13).

## 5. Combining the Subject Datasets

A `subject` label was added to each file, and the two tables were concatenated.

| Stage | Rows | Columns |
|---|---:|---:|
| Mathematics | 395 | 33 |
| Portuguese | 649 | 33 |
| Combined + `subject`, `result`, `attendance_group` | **1,044** | **36** |

> The combined table holds **subject records**. It does not hold 1,044 unique students, and no unique student identifier is available.

## 6. Descriptive Statistics

| Measure | Value |
|---|---:|
| Total subject records | 1,044 |
| Passing records (G3 ≥ 10) | 814 |
| Failing records (G3 < 10) | 230 |
| Overall pass rate | 77.97% |
| Overall fail rate | 22.03% |
| Average G1 | 11.21 |
| Average G2 | 11.25 |
| Average final grade (G3) | 11.34 |
| Median final grade (G3) | 11.00 |
| Average absences | 4.43 |

*The overall average G3 is reported as 11.34, the value computed in Power BI. It may appear as approximately 11.35 if rounded from intermediate subject averages.*

## 7. Grade Analysis

- Grades are on a 0–20 scale and the pass mark is 10.
- The final-grade distribution (shown on Dashboard Page 1) shows a concentration of records between G3 values of about 8 and 15, with a peak around 10–11.
- 53 records have a G3 of 0 (38 Mathematics, 15 Portuguese). The data cannot show whether these reflect a true score of zero or a missing evaluation, so they are retained and flagged as a limitation.

## 8. Subject Comparison

| Subject | Records | Avg G1 | Avg G2 | Avg G3 | Pass | Fail | Pass rate | Avg absences |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Mathematics | 395 | 10.91 | 10.71 | 10.42 | 265 | 130 | 67.09% | 5.71 |
| Portuguese | 649 | 11.40 | 11.57 | 11.91 | 549 | 100 | 84.59% | 3.66 |

**Observations**

- Portuguese records average **1.49 grade points** higher in G3 and have a pass rate **17.50 percentage points** higher.
- Mathematics averages decline across the three periods (10.91 → 10.71 → 10.42), while Portuguese averages rise (11.40 → 11.57 → 11.91).
- Mathematics records average more absences (5.71) than Portuguese records (3.66).

## 9. Attendance Analysis

Records are split at 15 absences (see the methodology document).

| Attendance group | Records | Avg absences | Avg G3 | Pass rate |
|---|---:|---:|---:|---:|
| 15 or fewer absences | 990 | 3.43 | 11.40 | 78.79% |
| More than 15 absences | 54 | 22.89 | 10.31 | 62.96% |

**Observations**

- The high-absence group is 5.17% of records (54 of 1,044).
- Its average grade is **1.09 points** lower and its pass rate **15.83 percentage points** lower than the other group.
- The overall linear correlation between absences and G3 is only about −0.05, so absence count alone does not strongly predict grade across the whole dataset. The group difference should be read together with the small group size.

## 10. Study-Time Analysis

Study time is an ordinal category (1–4), not hours.

| Study-time category | Records | Avg G3 | Pass rate |
|---:|---:|---:|---:|
| 1 | 317 | 10.58 | 72.56% |
| 2 | 503 | 11.34 | 77.93% |
| 3 | 162 | 12.49 | 85.80% |
| 4 | 62 | 12.27 | 85.48% |

**Observations**

- Average G3 rises from category 1 to category 3 (+1.91 points) and is slightly lower in category 4 than in category 3.
- Category 4 has only 62 records, so the small dip between categories 3 and 4 should not be over-interpreted.
- The correlation between `studytime` and G3 is +0.162 – a weak positive association.

## 11. Previous-Failures Analysis

| Previous failures | Records | Avg G3 | Pass rate |
|---:|---:|---:|---:|
| 0 | 861 | 12.05 | 85.02% |
| 1 | 120 | 8.43 | 51.67% |
| 2 | 33 | 7.48 | 33.33% |
| 3 | 30 | 6.80 | 30.00% |

**Observations**

- 183 records (17.53%) have at least one previous failure.
- Average G3 drops by **3.62 points** between zero and one previous failure, and keeps falling with each additional failure.
- Pass rate drops from 85.02% to 51.67% between zero and one previous failure.
- Groups with two or three failures are small (33 and 30 records).

## 12. Correlation Analysis

Pearson correlations with the final grade (G3):

| Variable | Correlation with G3 | Strength / direction |
|---|---:|---|
| G2 | +0.911 | Very strong positive |
| G1 | +0.809 | Very strong positive |
| Medu | +0.201 | Weak positive |
| Studytime | +0.162 | Weak positive |
| Fedu | +0.160 | Weak positive |
| Failures | −0.383 | Moderate negative |
| Dalc | −0.130 | Weak negative |
| Age | −0.125 | Weak negative |
| Walc | −0.116 | Weak negative |
| Traveltime | −0.103 | Weak negative |
| Absences | ≈ −0.05 | Negligible |

**Interpretation**

- G1 and G2 are earlier measurements of the same academic performance, so their strong correlation with G3 reflects consistency of grades over time rather than independent explanatory factors.
- Among background variables, **previous failures** has the strongest association with G3 (−0.383).
- Correlation measures linear association only and does not establish causation.

## 13. IQR Outlier Detection

| Column | Outliers flagged |
|---|---:|
| Age | 2 |
| Absences | 54 |
| Studytime | 62 |
| Failures | 183 |
| G1 | 1 |
| G2 | 20 |
| G3 | 54 |

**Interpretation**

- `studytime` and `failures` are ordinal/discrete categories. Their IQR flags do **not** indicate data errors.
- For example, 861 of 1,044 records have zero previous failures, so any non-zero value falls outside the IQR fences. The 183 flagged records are exactly the records with at least one previous failure. Similarly, the 62 study-time flags equal the number of category-4 records.
- Flagged `absences`, `G2` and `G3` values represent real, if unusual, observations.
- **No records were removed** on the basis of IQR results alone.

## 14. Welch's t-test – Mathematics vs Portuguese Final Grades

| Statistic | Value |
|---|---:|
| t-statistic | −5.6664 |
| p-value | < 0.001 (≈ 0.000000 at six decimal places) |
| Significance level | 0.05 |
| Decision | Reject H₀ |

**Conclusion:** there is a statistically significant difference between the mean final grades of Mathematics and Portuguese records. The negative t-statistic reflects that the Mathematics mean is lower.

*Welch's version was used because it does not assume equal variances between the two groups.*

## 15. Cohen's d

| Statistic | Value | Interpretation |
|---|---:|---|
| Cohen's d | −0.3925 | Small effect (|d| between 0.2 and 0.5) |

The negative sign shows that the Mathematics mean is lower than the Portuguese mean.

**Significance versus effect size:** the t-test shows the difference is unlikely to be chance (statistical significance). Cohen's d shows the difference is **small to modest in size** (practical importance). Both are needed for a complete interpretation.

## 16. Visual Analysis and Chart Explanations

Matplotlib and Seaborn were used for exploratory visualisation. The same relationships are communicated to business users in the Power BI dashboards. The table below explains how each type of view is read; refer to the notebook for the exact figures produced.

| Chart type | What it shows | How to read it |
|---|---|---|
| Histogram / distribution chart | How often each grade or absence value occurs | Look for peaks, spread and unusual values (e.g. the cluster at G3 = 0) |
| Grouped comparison chart | Mean grade or pass rate by subject, attendance group, study-time category or failures | Compare bar heights across groups |
| Correlation view | Strength of relationships between numeric fields and G3 | Values near ±1 are strong; values near 0 are negligible |
| Box-style / IQR view | Spread and outliers within a column | Points beyond the fences are flagged, not necessarily errors |

## 17. Export for Power BI

Analysis outputs were exported as CSV files in the `PowerBI/` folder:

| File | Content |
|---|---|
| `Education_Cleaned_Data.csv` | Combined record-level dataset (1,044 rows, 36 columns) – the table loaded into Power BI |
| `Subject_Performance.csv` | Subject-level summary |
| `Attendance_Analysis.csv` | Attendance-group summary |
| `Study_Time_Analysis.csv` | Study-time summary |
| `Previous_Failures_Analysis.csv` | Previous-failures summary |
| `Correlation_Matrix.csv` | Correlation results |

## 18. Important Findings

1. **Overall:** 814 of 1,044 subject records pass (77.97%); average G3 is 11.34.
2. **Subject:** Portuguese records show higher grades and pass rates than Mathematics records, and the difference is statistically significant with a small effect size (d = −0.3925).
3. **Attendance:** records with more than 15 absences have lower average grades (10.31 vs 11.40) and pass rates (62.96% vs 78.79%), although the overall absence–grade correlation is weak.
4. **Study time:** average grades rise from category 1 to category 3 and are similar in category 4.
5. **Previous failures:** the clearest gradient in the data – average G3 falls from 12.05 to 6.80 as failures rise from 0 to 3.
6. **Prior grades:** G1 and G2 are the strongest correlates of G3.
7. **Caution:** all findings are associations in subject-level records, not causal effects and not unique-student counts.
