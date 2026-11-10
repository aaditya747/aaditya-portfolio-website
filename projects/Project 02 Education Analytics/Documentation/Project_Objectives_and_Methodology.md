# Project Objectives and Methodology

[← Back to README](../README.md)

**Project:** Education Analytics – Student Performance Analysis (Project 02)

---

## 1. Business Problem

Schools and education authorities want to understand which factors are associated with academic success so that support can be directed where it is most useful. This project asks:

1. How do Mathematics and Portuguese performance compare?
2. Is a high number of absences associated with lower final grades and pass rates?
3. How do study-time category and previous failures relate to final grades?
4. Which variables show the strongest statistical association with the final grade (G3)?
5. Is the difference between Mathematics and Portuguese grades statistically significant, and how large is it?

## 2. Project Objectives

| # | Objective |
|---|---|
| 1 | Load, inspect, clean and validate the Mathematics and Portuguese datasets |
| 2 | Combine both datasets and engineer `subject`, `result` and `attendance_group` fields |
| 3 | Produce descriptive statistics and compare subject performance |
| 4 | Analyse attendance, study-time and previous-failure patterns |
| 5 | Measure relationships with correlation analysis and detect outliers with the IQR method |
| 6 | Test the subject difference with Welch's t-test and quantify it with Cohen's d |
| 7 | Export analysis tables and build a three-page interactive Power BI dashboard |
| 8 | Document the work as a reproducible case study |

## 3. Dataset Description

| Item | Detail |
|---|---|
| Source | UCI Machine Learning Repository – Student Performance dataset |
| URL | https://archive.ics.uci.edu/dataset/320/student+performance |
| Files | `student-mat.csv` (Mathematics), `student-por.csv` (Portuguese) |
| Mathematics records | 395 |
| Portuguese records | 649 |
| Combined records | 1,044 |
| Original columns | 33 |
| Columns after feature engineering | 36 |
| Reference | Cortez, P. & Silva, A. (2008), *Using Data Mining to Predict Secondary School Student Performance*, FUBUTEC 2008 |

### Unit of analysis – important

Each row is a **subject record** (one student in one subject). The dataset has **no reliable unique student identifier**, and the same student may appear in both subject files. Therefore:

- 1,044 is the number of **subject records**, not unique students.
- Counts, rates and averages in this project are calculated per subject record.
- No analysis here attempts to match students across subjects.

## 4. Data Dictionary Overview

Original attributes follow the UCI documentation. Data types are those used in the Power BI model.

### Demographic and family attributes

| Column | Type | Description |
|---|---|---|
| `school` | Text | School attended (binary code) |
| `sex` | Text | Student sex |
| `age` | Whole number | Student age |
| `address` | Text | Home address type (urban/rural) |
| `famsize` | Text | Family size category |
| `Pstatus` | Text | Parents' cohabitation status |
| `Medu` | Whole number | Mother's education level (ordinal scale) |
| `Fedu` | Whole number | Father's education level (ordinal scale) |
| `Mjob` | Text | Mother's job category |
| `Fjob` | Text | Father's job category |
| `reason` | Text | Reason for choosing the school |
| `guardian` | Text | Student's guardian |

### Study, support and lifestyle attributes

| Column | Type | Description |
|---|---|---|
| `traveltime` | Whole number | Home-to-school travel time (ordinal category) |
| `studytime` | Whole number | Weekly study time (ordinal category 1–4) |
| `failures` | Whole number | Number of previous class failures (0–3 in this data) |
| `schoolsup` | Text | Extra educational support from school (yes/no) |
| `famsup` | Text | Family educational support (yes/no) |
| `paid` | Text | Extra paid classes in the subject (yes/no) |
| `activities` | Text | Extra-curricular activities (yes/no) |
| `nursery` | Text | Attended nursery school (yes/no) |
| `higher` | Text | Wants to take higher education (yes/no) |
| `internet` | Text | Internet access at home (yes/no) |
| `romantic` | Text | In a romantic relationship (yes/no) |
| `famrel` | Whole number | Quality of family relationships (ordinal scale) |
| `freetime` | Whole number | Free time after school (ordinal scale) |
| `goout` | Whole number | Going out with friends (ordinal scale) |
| `Dalc` | Whole number | Workday alcohol consumption (ordinal scale) |
| `Walc` | Whole number | Weekend alcohol consumption (ordinal scale) |
| `health` | Whole number | Current health status (ordinal scale) |

### Academic and attendance attributes

| Column | Type | Description |
|---|---|---|
| `absences` | Whole number | Number of school absences |
| `G1` | Whole number | First-period grade (0–20 scale) |
| `G2` | Whole number | Second-period grade (0–20 scale) |
| `G3` | Whole number | Final grade (0–20 scale) – the target variable |

### Engineered attributes (added in this project)

| Column | Type | Description |
|---|---|---|
| `subject` | Text | `Mathematics` or `Portuguese` |
| `result` | Text | `Pass` if G3 ≥ 10, otherwise `Fail` |
| `attendance_group` | Text | `15 or Fewer Absences` or `High Absences` |

### Study-time categories

`studytime` is an **ordinal category code**, not a count of hours. Per the UCI documentation, the codes represent weekly study-time bands (1 = shortest band, 4 = longest band). In this project the values are always labelled as "study-time category 1–4" and are never read as literal hours.

## 5. Data Preparation Process

1. **Load** `student-mat.csv` and `student-por.csv` with Pandas.
2. **Inspect** shape, column names, data types, summary statistics and sample rows.
3. **Clean and validate** the data (see Section 6).
4. **Add a `subject` column** to each file (`Mathematics`, `Portuguese`).
5. **Concatenate** both files into a single combined table of 1,044 rows.
6. **Create `result` and `attendance_group`** (Sections 7 and 8), bringing the table to 36 columns.
7. **Export** the combined table and analysis summaries as CSV files for Power BI (`Education_Cleaned_Data.csv` and the summary files in the `PowerBI/` folder).

## 6. Data Quality Checks

The following checks were part of the data cleaning and validation stage:

| Check | Purpose |
|---|---|
| Row and column counts per file | Confirm 395 and 649 records and the expected column structure |
| Combined row and column counts | Confirm 1,044 rows and 36 columns after feature engineering |
| Data type review | Confirm numeric, ordinal and text fields are typed correctly |
| Missing-value and consistency checks | Confirm fields are complete and values are in valid ranges |
| Reconciliation of totals | Confirm subject, result and attendance totals each add up to 1,044 |

Reconciliation checks that were re-verified when documenting this project:

- 395 + 649 = 1,044 (subjects)
- 814 pass + 230 fail = 1,044 (result)
- 990 + 54 = 1,044 (attendance groups)
- 861 + 120 + 33 + 30 = 1,044 (previous failures)
- 317 + 503 + 162 + 62 = 1,044 (study-time categories)

## 7. Pass/Fail Classification

```text
Pass : G3 >= 10
Fail : G3 <  10
```

Equivalent logic in Pandas:

```python
df["result"] = np.where(df["G3"] >= 10, "Pass", "Fail")
```

**Pass rate** = Pass records ÷ Total records × 100.
Overall: 814 ÷ 1,044 × 100 = **77.97%**.

## 8. Attendance Group Classification

```text
15 or Fewer Absences : absences <= 15
High Absences        : absences >  15
```

Equivalent logic in Pandas:

```python
df["attendance_group"] = np.where(df["absences"] > 15, "High Absences", "15 or Fewer Absences")
```

| Group | Records | Share |
|---|---:|---:|
| 15 or Fewer Absences | 990 | 94.83% |
| High Absences | 54 | 5.17% |

## 9. Feature Engineering Summary

| New field | Source | Rule | Used for |
|---|---|---|---|
| `subject` | File of origin | Label added before merging | Subject comparison, slicer, chart legends |
| `result` | `G3` | Pass if G3 ≥ 10 | Pass/fail counts and pass rates |
| `attendance_group` | `absences` | High if absences > 15 | Attendance analysis |

## 10. Analytical Methodology

| Analysis | Approach |
|---|---|
| Descriptive statistics | Counts, means, medians and distributions of grades and absences |
| Subject comparison | Mean G1, G2, G3, pass rate and mean absences by subject |
| Attendance analysis | Mean G3 and pass rate by attendance group |
| Study-time analysis | Mean G3, record count and pass rate by study-time category |
| Previous-failures analysis | Mean G3, record count and pass rate by number of previous failures |
| Correlation analysis | Pearson correlation of numeric fields with G3 |
| Outlier detection | IQR rule on numeric columns |

## 11. Statistical Methodology

### Pearson correlation
Measures the strength and direction of a linear relationship between two numeric variables, from −1 to +1.

### IQR outlier detection
```text
IQR         = Q3 − Q1
Lower fence = Q1 − 1.5 × IQR
Upper fence = Q3 + 1.5 × IQR
```
Values outside the fences are flagged. Flagged values are **not automatically errors**, and records are not removed on this basis alone. This matters especially for `studytime` and `failures`, which are ordinal/discrete categories.

### Welch's independent-samples t-test
Compares the mean G3 of Mathematics and Portuguese records without assuming equal variances.

- **H₀:** the two subjects have the same mean final grade.
- **H₁:** the mean final grades differ.
- **Significance level:** α = 0.05.

### Cohen's d (effect size)
```text
d = (mean₁ − mean₂) ÷ pooled standard deviation
```
Conventional thresholds: 0.2 = small, 0.5 = medium, 0.8 = large.

### Significance versus effect size
A p-value tells us whether a difference is unlikely to be due to chance. Cohen's d tells us how large the difference is. A difference can be statistically significant yet small in practical terms – which is the case for the subject comparison in this project.

## 12. Project Limitations

| Limitation | Implication |
|---|---|
| Subject records, not unique students | The same student may be counted in both subjects; unique-student counts cannot be produced |
| Observational data | Results show associations, not causes |
| Ordinal/discrete fields | `studytime`, `failures` and survey scales are categories; averages across them are descriptive summaries |
| Small high-absence group (54 records) | Group statistics are less stable than for the 990-record group |
| Subject mix not controlled | Differences between groups may partly reflect differences in subject, school or student background |
| Grades of 0 | The data cannot show whether a G3 of 0 reflects a true score or a missing evaluation |
| Single source and period | Findings apply to this dataset and should not be generalised without further evidence |
