# Education 360° --- Business Analytics (Project 03)

A multi-tool education business analytics project using Python, MySQL
8.0 and Power BI. The project examines student admissions, marketing
campaigns, lead activity, placements, fee collection and branch/course
performance.

## Project status

  --------------------------------------------------------------------------------------
  Component               File / folder                          Status
  ----------------------- -------------------------------------- -----------------------
  Python analysis         `Python/` --- 8 notebooks              Completed by user;
                                                                 outputs not
                                                                 independently audited

  SQL setup               `01_Database_Setup.sql`                Prepared; verify
                                                                 against the existing
                                                                 database before running

  SQL exploration         `02_Data_Exploration.sql`              Script prepared;
                                                                 execution validation
                                                                 pending

  SQL data quality        `03_Data_Quality_Checks.sql`           Script prepared;
                                                                 execution validation
                                                                 pending

  Admissions analysis     `04_Student_Admissions_Analysis.sql`   Script prepared;
                                                                 execution validation
                                                                 pending

  Marketing and leads     `05_Marketing_Lead_Analysis.sql`       Script prepared;
                                                                 execution validation
                                                                 pending

  Placement analytics     `06_Placement_Analytics.sql`           Script prepared;
                                                                 execution validation
                                                                 pending

  Financial analytics     `07_Financial_Analytics.sql`           Script prepared;
                                                                 execution validation
                                                                 pending

  Advanced SQL            `08_Advanced_Business_Analysis.sql`    Script prepared;
                                                                 execution validation
                                                                 pending

  KPI summary             `09_KPI_Summary.sql`                   Script prepared;
                                                                 execution validation
                                                                 pending

  Power BI                `PowerBI/`                             Four report pages
                                                                 created; final
                                                                 model/report review is
                                                                 separate

  Documentation           `Documentation/`                       Update with final
                                                                 validated findings

  Screenshots             `Screenshots/`                         Add final dashboard and
                                                                 SQL evidence
  --------------------------------------------------------------------------------------

**Status convention:** "Prepared" means the query/script has been
written. It does not mean every query has been executed and
independently validated. Update a script to "Validated" only after
checking its MySQL output.

## Project structure

``` text
Project_03_Education_360_Analysis/
├── Dataset/                 # Source CSVs — do not publish personal data
├── Python/                  # Data inspection, validation and analysis notebooks
├── SQL/                     # Nine MySQL analysis scripts
├── PowerBI/                 # Power BI report (.pbix)
├── Documentation/           # Project methodology and findings
├── Screenshots/             # Dashboard and query evidence
└── README.md
```

## Database

**Database:** `education_360_db`\
**Platform:** MySQL 8.0

The ten tables loaded into MySQL are:

  MySQL table    Source CSV filename     Source row count
  -------------- --------------------- ------------------
  `students`     `students dim.csv`                 2,000
  `admissions`   `admissions.csv`                   2,000
  `fees`         `fees.csv`                         2,000
  `placements`   `placements.csv`                   2,000
  `calls`        `calls.csv`                       18,226
  `leads`        `leads.csv`                        2,000
  `marketing`    `marketing.csv`                      150
  `employees`    `employees.csv`                       30
  `branches`     `braches dim.csv`                      5
  `courses`      `courses dim.csv`                      5

The source filenames above preserve the spelling and spacing shown in
the dataset. The MySQL table names are normalized.

**Date table:** `date_table.csv` is used in Power BI only. It is not one
of the ten MySQL tables.

## SQL scripts

  --------------------------------------------------------------------------
  Script                                 Purpose
  -------------------------------------- -----------------------------------
  `01_Database_Setup.sql`                Database/table setup and safe
                                         verification

  `02_Data_Exploration.sql`              Table counts, distinct counts, date
                                         ranges, numeric summaries and
                                         category distributions

  `03_Data_Quality_Checks.sql`           NULLs, duplicate keys, orphan
                                         checks, invalid values and
                                         reconciliation checks

  `04_Student_Admissions_Analysis.sql`   Admissions by month, branch,
                                         course, source and counselor

  `05_Marketing_Lead_Analysis.sql`       Lead status/source analysis and
                                         campaign-level marketing
                                         performance

  `06_Placement_Analytics.sql`           Placement status/rate, branch and
                                         cohort analysis, calls, companies
                                         and salary

  `07_Financial_Analytics.sql`           Billed fees, collections,
                                         outstanding balances,
                                         course/branch/payment analysis

  `08_Advanced_Business_Analysis.sql`    Joins, CASE, HAVING, subqueries,
                                         CTEs, ranking, LAG/LEAD and running
                                         totals

  `09_KPI_Summary.sql`                   Consolidated business KPI queries
  --------------------------------------------------------------------------

### SQL concepts demonstrated

-   `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`
-   `GROUP BY`, `HAVING`, aggregate functions
-   `CASE WHEN`
-   Scalar subqueries and derived tables
-   Common Table Expressions (`WITH`)
-   Window functions: `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`
-   `LAG()` and `LEAD()`
-   Running totals with `SUM() OVER (...)`
-   NULL-safe division with `NULLIF()`
-   Data-quality checks and financial reconciliation

## Dataset findings and KPI reference values

The following are reference values established during the project's CSV
analysis. They should be compared with the executed SQL outputs before
being described as final SQL-validated results.

  Metric                                          Reference value
  ------------------------------------ --------------------------
  Students                                                  2,000
  Admissions                                                2,000
  Individual lead records                                   2,000
  Placed students                                             697
  Overall recorded placement rate                          34.85%
  Total billed fees                                  ₹6,60,65,000
  Fees collected                                     ₹5,24,91,750
  Outstanding fees                                   ₹1,35,73,250
  Collection efficiency                                    79.45%
  Pending fee records                                       1,465
  Average salary of placed students                     ₹5.24 LPA
  Placement calls                                           6,075
  Students with five placement calls                          414
  Total marketing spend                                ₹92,49,025
  Campaign leads generated                                 39,934
  Campaign admissions converted                             9,550
  Effective calls                        7,170 of 18,226 (39.34%)

## Important analytical definitions and limitations

### Leads and admissions are not person-level reconciled

The `leads` table contains 2,000 individual lead records and
`admissions` contains 2,000 admission records. A validated shared
person-level key has not been established. Names are not a safe join
key, and coincident ID values do not prove that records represent the
same person.

Therefore: - Do not report an individual lead-to-admission conversion
rate from these two tables. - Lead status and lead-source distributions
are descriptive analyses. - Admission-source contribution measures the
share of admissions by recorded source; it is not lead conversion.

### Marketing is campaign-level aggregate data

The `marketing` table contains campaign-level records and totals of
39,934 leads generated and 9,550 admissions converted. Analyze its
campaign conversion and cost-per-lead metrics within that table. Do not
equate these aggregate counts with the individual `leads` table.

### Placement denominator

The 34.85% placement rate uses 697 placed students divided by 2,000
total students. The dataset does not identify a separate
eligible-student population. Label this KPI **overall recorded placement
rate**, not official eligible-student placement rate.

### Financial date limitation

The `fees` table has no payment date. Any monthly fee analysis uses
`students.admission_date` and must be labelled an **admission-cohort
collection analysis**, not a payment-month or cash-receipt trend.

### Placement date limitation

The `placements` table has no dedicated placement date. If admission
date is used to group placement outcomes, label the result as an
**admission-cohort placement analysis**, not a placement trend by actual
placement date.

### Employee/recruiter attribution

The `calls` table supports counselor call-activity analysis through
`counselor_id`. The `placements` table does not provide a validated
recruiter/employee ID, so employee call counts must not be presented as
employee-attributed successful placements.

### Data privacy

The `students` table contains names, email addresses and phone numbers.
Keep the `Dataset/` folder and any files containing personal information
out of the public GitHub repository. Publish only appropriately
anonymized or aggregated outputs and screenshots.

## Recommended execution and validation order

1.  Confirm the existing database and ten imported tables.
2.  Run `02_Data_Exploration.sql` and compare row counts with the source
    data.
3.  Run `03_Data_Quality_Checks.sql`; resolve or document any failed
    checks.
4.  Run scripts `04` through `08` and inspect the result sets.
5.  Run `09_KPI_Summary.sql` and compare its results with the reference
    KPI table above.
6.  Mark each script as **Validated** only after its outputs have been
    checked.
7.  Save final SQL result screenshots and Power BI report screenshots in
    `Screenshots/`.
8.  Update the major findings below using only validated outputs.

## Major findings

*To be completed after the SQL scripts have been executed and their
outputs checked. Do not treat reference KPI values as SQL validation.*

## Tools used

-   Python --- data inspection, cleaning checks and exploratory analysis
-   MySQL 8.0 --- relational querying and business analysis
-   Power BI --- interactive business intelligence dashboards
-   DAX --- measures and KPI calculations
-   DAX Studio --- measure validation
-   Git and GitHub --- version control and portfolio publishing
