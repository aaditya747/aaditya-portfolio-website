# Data Cleaning and Preparation

This file separates **(A) work already performed before this documentation** from **(B) checks performed during this documentation project**.

## A. Work already performed ⏳ PENDING

Nothing in the supplied files records how the CSVs were produced or cleaned. Please provide the notebooks or a short note covering:

| Topic | Information needed |
|---|---|
| Original data sources | Where the raw data came from (academy files, exports, generated) |
| Extraction method | Manual export, script, database query |
| Cleaning operations | Renaming, type conversion, text standardisation, derived columns |
| Missing values / duplicates handling | What was found and what was done |

Observations that suggest earlier preparation (not proof): derived columns exist in the CSVs (`Admission Month`, `Admission Year`, `Cost Per Lead`, `Conversion Rate`, `collection%`, `Call Category`, `Placment success `), and the date table is a separate file.

## B. Checks performed in this project (on the supplied CSVs)

| Check | Method | Result |
|---|---|---|
| Missing values | Null count per column | 0 in all 11 tables |
| Duplicate rows | Full-row duplicate test | 0 in all tables |
| Duplicate keys | Uniqueness of candidate IDs | All unique |
| Orphan keys | Foreign key values absent from parent table | 0 across 12 relationships |
| Data types | Detected from CSV | IDs and labels are text; amounts and counts are integers; ratios are decimals |
| Date handling | Dates stored as text `YYYY-MM-DD 00:00:00.000` in admissions, calls, leads, students dim and DateTable; marketing uses month abbreviations | Not converted here; type conversion in Python/Power BI ⏳ |
| Consistency | total fee = paid fee + remaining fee | Holds for every row |
| Consistency | admissions[course fee] = course fee in courses dim | Holds for every row |
| Consistency | fees[collection%] = paid fee ÷ total fee | Holds for every row |
| Consistency | call duration = 0 only for Not Connected calls | Holds |
| Consistency | salary package = 0 for non-placed students | Holds |

## C. Data quality issues noted (not changed)

| Issue | Detail |
|---|---|
| Column name spelling | `Placment success ` has a trailing space; value "Sucess"; file `braches_dim.csv` |
| Personal data | Names, email and phone in students dim; names in leads |
| Table linkage | leads has no student id; marketing has no key to other tables |
| Time coverage | Facts end May 2025; DateTable runs to Dec 2026 |
