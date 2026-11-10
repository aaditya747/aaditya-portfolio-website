# 01 — Power BI Project Overview

**Project:** Education 360° — Education Business Analytics
**Source file:** `Education_360____Education_Business_Analytics.pbix`

> **Verification legend** — ✅ Verified from the PBIX report layout or the CSV files · 🟡 Inferred from names/structure (confirm) · ⏳ PENDING (could not be read from the files provided)

## 1. Report overview

| Item | Detail | Status |
|---|---|---|
| Report title (banner on page 1) | "360 EDUCATION BUSINESS ANALYTICS PLATFORM — Executive Overview Dashboard" | ✅ |
| Number of pages | 4 | ✅ |
| Pages | Executive Dashboard · Sales analysis · Placement Analytics · Financial Analytics | ✅ |
| Canvas size | 1500 × 1600 px (custom) on every page | ✅ |
| Base theme | `CY26SU05` (Power BI built-in base theme) | ✅ |
| Model tables | 11 data tables + 5 measure tables (see file 02) | ✅ |
| Number of visuals | 48 content visuals (14 + 11 + 11 + 12, see file 04) plus a background shape and a banner text box on each page | ✅ |

## 2. Dashboard objectives 🟡

Derived from the page titles and the KPIs displayed. Please confirm against your original academy brief.

| Page | Objective implied by the report |
|---|---|
| Executive Dashboard | Give management a one-screen summary of revenue, admissions, students, outstanding fees, placement rate and lead conversion. |
| Sales analysis | Track lead generation, lead conversion, call effectiveness and admissions by source, branch and counselor. |
| Placement Analytics | Monitor placement outcomes, salary, placement-call effort and company distribution. |
| Financial Analytics | Monitor fee collection, outstanding fees, payment status/mode and revenue by month, branch and course. |

## 3. Business requirements ⏳

The original requirement document is not part of the files provided. The table below lists the information needs the report *satisfies*, not requirements that were formally stated.

| Information need | Where answered |
|---|---|
| How much revenue and how many admissions have we generated? | Executive, Sales, Financial |
| How well do leads convert, and which sources/branches convert best? | Sales |
| How many students are placed and at what salary? | Placement |
| How much fee has been collected vs. is outstanding? | Financial, Executive |

## 4. Intended audience 🟡

The page structure suggests: academy leadership (Executive), sales/admissions and counselors (Sales), placement team (Placement), finance/accounts (Financial). ⏳ Confirm the real audience.

## 5. Technology used

| Component | Detail | Status |
|---|---|---|
| Power BI Desktop | Report authored in Power BI (file metadata shows creation from release 2026.07) | ✅ |
| DAX | Measures stored in five dedicated measure tables | ✅ (formulas ⏳) |
| Power Query | Query settings show type detection and relationship import enabled; query steps not readable | ⏳ |

## 6. Data sources

| # | Table in model | Source file | Rows | Status |
|---|---|---|---|---|
| 1 | admissions | admissions.csv | 2,000 | ✅ |
| 2 | branches dim | braches_dim.csv (file name spelling as supplied) | 5 | ✅ |
| 3 | calls | calls.csv | 18,226 | ✅ |
| 4 | courses dim | courses_dim.csv | 5 | ✅ |
| 5 | employees | employees.csv | 30 | ✅ |
| 6 | fees | fees.csv | 2,000 | ✅ |
| 7 | leads | leads.csv | 2,000 | ✅ |
| 8 | marketing | marketing.csv | 150 | ✅ |
| 9 | placements | placements.csv | 2,000 | ✅ |
| 10 | students dim | students_dim.csv | 2,000 | ✅ |
| 11 | DateTable | date_table.csv | 1,096 | ✅ |

⏳ Whether the PBIX connects to these CSVs directly or to the MySQL database is not readable from the files provided.

**Privacy note:** `students_dim.csv` contains student name, email and phone, and `leads.csv` contains student name. These values are deliberately not reproduced anywhere in this documentation.
