# 08 — Power BI Validation and Limitations

## 1. Validation completed in this documentation project (CSV level)

These checks were run directly on the 11 CSV files. They validate the **source data**, not the Power BI measures.

| Check | Result |
|---|---|
| Row counts | admissions 2,000 · branches 5 · calls 18,226 · courses 5 · employees 30 · fees 2,000 · leads 2,000 · marketing 150 · placements 2,000 · students 2,000 · date table 1,096 |
| Missing values | 0 nulls in every table |
| Fully duplicated rows | 0 in every table |
| Primary-key uniqueness | All candidate keys unique (see file 02) |
| Orphan foreign keys | 0 for all 12 candidate relationships tested |
| Fee arithmetic | total fee = paid fee + remaining fee on every fees row (0 differences) |
| Admission fee vs. course fee | admissions[course fee] equals the course fee in courses dim for all rows (0 differences) |
| Total billed | Sum of fees[total fee] = 66,065,000 = sum of admissions[course fee] |
| Date table | 1,096 daily rows, 2024-01-01 → 2026-12-31 |

## 2. Validation still required ⏳

| Area | What to do | Status |
|---|---|---|
| KPI reconciliation | Compare each card (no slicers) with the reference values in file 05 and record differences | ⏳ |
| Filter testing | Select each course/branch/platform and confirm which visuals respond | ⏳ |
| Relationship testing | Confirm cardinality, direction and active paths in Model view; test the placement-by-month and marketing-platform behaviour | ⏳ |
| Date-table validation | Confirm it is marked as a date table, which date columns relate to it, and YearMonth sort order | ⏳ |
| Performance | Run Performance Analyzer on each page | ⏳ |

## 3. Performance considerations

Model size is small (largest table: calls, 18,226 rows; PBIX ≈ 0.6 MB), so performance risk is low. Each page holds 11–14 visuals on a 1600 px canvas. Actual load times are ⏳ not measured.

## 4. Known limitations

| # | Limitation | Type |
|---|---|---|
| 1 | DAX formulas, relationships and Power Query steps could not be read from the PBIX | Documentation |
| 2 | Measures not placed on any visual are not detectable | Documentation |
| 3 | Visual titles that do not match content (file 07 §6) | Report design |
| 4 | Slicers exist only on page 1 | Report design |
| 5 | marketing has no relationship key; placements and leads have no date or student key respectively | Data model |
| 6 | Source column spelling: `Placment success ` (trailing space), value "Sucess", file `braches_dim.csv` | Data quality (cosmetic) |
| 7 | Data covers late 2023 – May 2025 while the date table extends to 2026 | Data coverage |
| 8 | Contact details (email, phone) and student names are present in the source files | Privacy |

## 5. Assumptions

- Table roles (fact/dimension) are inferred from structure.
- Relationship candidates are inferred from key matching.
- Reference KPI values assume simple, unfiltered aggregates.
- Business objectives are inferred from page content.
