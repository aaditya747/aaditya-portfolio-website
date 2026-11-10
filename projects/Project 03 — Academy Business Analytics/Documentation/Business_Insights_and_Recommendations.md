# Business Insights and Recommendations

> **Status.** Python and SQL results were not supplied, and the PBIX measure formulas are unreadable, so no insight below comes from your notebooks, queries or dashboard cards. Section 2 is a **descriptive profile computed directly from the CSV files** during this documentation project. Joins use the student id / branch id / course id keys that match without orphans. Treat the figures as expected values to reconcile with your own analysis (⏳), and replace the pending sections with notebook/SQL results.

## 1. Executive summary ⏳

To be written once analysis results are available. Verified from the CSVs: 2,000 students/admissions, 66,065,000 billed in fees of which 79.45% is paid; 31.90% of leads are Converted; 34.85% of students are Placed.

## 2. CSV-derived KPI profile

| KPI | Value | Calculation |
|---|---|---|
| Students / admissions | 2,000 | row count |
| Total billed | 66,065,000 | sum(fees[total fee]) |
| Collected | 52,491,750 | sum(paid fee) |
| Outstanding | 13,573,250 | sum(remaining fee) |
| Collection ratio | 79.45% | paid ÷ total |
| Fee records Completed / Pending | 535 / 1,465 | payment status |
| Leads / Converted / Follow-Up / Lost | 2,000 / 638 / 706 / 656 | lead status |
| Lead conversion | 31.90% | converted ÷ leads |
| Calls | 18,226 (Effective 7,170 = 39.34%) | Call Category |
| Placed / Searching / Interview Running | 697 / 665 / 638 | placement status |
| Placement rate | 34.85% | placed ÷ students |
| Average package of placed students | 5.24 LPA (range 2.5–8.0) | mean over 697 Placed rows |
| Students with 5 placement calls | 414 | placement calls given = 5 |

## 3. Student and admissions insights

- Admissions per year: 1,479 in 2024 and 521 in 2025 (to 15 May 2025). 2025 is a partial year, so the two are not comparable.
- Students are split 1,037 Female / 963 Male across 6 cities.
- Course list fees: 25,000 (Software Testing), 30,000 (Java and Python Full Stack), 40,000 (Data Science, Data Analytics).

## 4. Marketing and lead insights

Lead conversion by source (leads.csv):

| lead source | total | converted | conv % |
|---|---|---|---|
| LinkedIn | 340 | 123 | 36.18 |
| Walk-In | 325 | 105 | 32.31 |
| Referral | 324 | 104 | 32.1 |
| YouTube | 341 | 105 | 30.79 |
| Instagram | 338 | 103 | 30.47 |
| Website | 332 | 98 | 29.52 |

Lead conversion by branch:

| branch name | total | converted | conv % |
|---|---|---|---|
| Chinchwad | 378 | 138 | 36.51 |
| Karve Nagar | 430 | 146 | 33.95 |
| Nagpur | 420 | 138 | 32.86 |
| Pimpri | 381 | 110 | 28.87 |
| Hadapsar | 391 | 106 | 27.11 |

Marketing campaigns by platform (marketing.csv):

| platform | campaigns | ad_spend | leads | admissions | cost per lead | leads→admission % |
|---|---|---|---|---|---|---|
| Facebook | 41 | 2289813 | 9725 | 2460 | 235.46 | 25.3 |
| Instagram | 33 | 2192917 | 10389 | 2336 | 211.08 | 22.49 |
| LinkedIn | 32 | 1843887 | 8456 | 1949 | 218.06 | 23.05 |
| YouTube | 44 | 2922408 | 11364 | 2805 | 257.16 | 24.68 |

**Data observation:** marketing.csv reports 39,934 leads and 9,550 conversions, versus 2,000 leads and 2,000 admissions in the other tables. The marketing table therefore cannot be reconciled with leads/admissions and should be treated as a separate view (⏳ confirm its origin).

Call outcomes:

| call status | calls |
|---|---|
| Not Connected | 6195 |
| Follow-Up | 6085 |
| Connected | 5946 |

## 5. Placement insights

Placement by course (placement status Placed ÷ students):

| course_name | students | placed | placed % |
|---|---|---|---|
| Software Testing | 387 | 144 | 37.21 |
| Data Analytics | 405 | 141 | 34.81 |
| Java Full Stack | 403 | 139 | 34.49 |
| Data Science | 395 | 136 | 34.43 |
| Python Full Stack | 410 | 137 | 33.41 |

Hiring companies: 7 distinct companies appear in placements.

## 6. Financial insights

Fee collection by student branch:

| branch name | total fee | paid fee | remaining fee | collected % |
|---|---|---|---|---|
| Chinchwad | 12420000 | 9980750 | 2439250 | 80.36 |
| Hadapsar | 13085000 | 10469000 | 2616000 | 80.01 |
| Nagpur | 13725000 | 10924250 | 2800750 | 79.59 |
| Karve Nagar | 14235000 | 11251750 | 2983250 | 79.04 |
| Pimpri | 12600000 | 9866000 | 2734000 | 78.3 |

Payment mode (record counts): Cash 530, Card 497, Net Banking 489, UPI 484.

## 7. Branch and course performance

See the branch and course tables above. Differences between groups are small and no statistical test has been performed (⏳ — add from Python), so rankings should not be over-interpreted.

## 8. Business recommendations ⏳

Recommendations must follow from your confirmed analysis. Candidate themes, to validate before adopting:

1. Chase the large Pending balance (13.57 M outstanding; 1,465 pending fee records).
2. Investigate the 65% of students who are not yet placed, and the stage distribution (Searching vs. Interview Running).
3. Review the effectiveness of calls (about 61% of calls are classed Short).
4. Compare platforms by cost per lead after reconciling the marketing table.

## 9. Limitations

- No notebook or SQL results supplied; DAX not readable.
- Data are one academy over about 17 months; 2025 is partial.
- Marketing table does not reconcile to leads/admissions; leads cannot be linked to students.
- No statistical testing, no cost data other than ad spend.
