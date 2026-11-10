# Methodology

## 1. Project approach

The project follows a standard analytics lifecycle: understand the business → collect data → validate → analyse (Python, SQL) → model and visualise (Power BI) → interpret. The order in which your Python, SQL and Power BI work was carried out is ⏳ to confirm.

## 2. Data extraction ⏳

The raw source and extraction method are not recorded in the supplied files. Working inputs are 11 CSV files.

## 3. Data validation ✅ (performed in this documentation project)

| Method | Purpose |
|---|---|
| Null and duplicate-row counts | Completeness and uniqueness |
| Key uniqueness | Confirm identifiers |
| Orphan-key test | Confirm parent/child integrity |
| Arithmetic checks (fees, collection %, course fee) | Internal consistency |

Results: `Data_Cleaning_and_Preparation.md`.

## 4. Python workflow ⏳ · 5. SQL workflow ⏳

See `Python_Analysis.md` and `SQL_Analysis.md` (pending source files).

## 6. Power BI workflow

| Stage | What is verified |
|---|---|
| Data load | 11 tables in the model; connection type ⏳ |
| Modelling | Relationships ⏳; date table present with Date, Year, Month, MonthNo, Quarter, YearMonth |
| Measures | 20 measures in 5 measure tables (formulas ⏳) |
| Visualisation | 4 pages, 48 visuals, 3 slicers, no filters at page/report/visual level |
| Theme | CY26SU05 base theme with custom green palette |

## 7. KPI calculation methodology

KPI names, locations and reference values are in `PowerBI/05_KPI_and_Measures_Guide.md`. Typical definitions, to be confirmed against the DAX:

| KPI | Formula (expected) |
|---|---|
| Collection ratio | Paid fee ÷ Total fee |
| Lead conversion % | Converted leads ÷ Total leads |
| Effective call % | Effective calls ÷ Total calls |
| Placement rate | Placed students ÷ Total students |

## 8. Validation methods for outputs ⏳

Plan: reconcile Power BI cards, Python outputs and SQL results against the CSV reference values; record differences in `PowerBI/08_PowerBI_Validation_and_Limitations.md`.

## 9. Assumptions and limitations

- Table roles and relationships are inferred until Model view is supplied.
- Currency (INR) and units (LPA = lakhs per annum) are assumed.
- Marketing data does not reconcile with leads/admissions; leads cannot be linked to students.
- Data period is about 17 months; 2025 is partial.
- Personal data in source files must be removed before publishing.
