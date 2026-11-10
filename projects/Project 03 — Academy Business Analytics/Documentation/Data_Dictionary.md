# Data Dictionary

Schemas are read from the actual CSV files. **Data types** are those detected from the CSV (Power BI/MySQL types are ⏳ pending). Dates are stored as text such as `2024-02-04 00:00:00.000`. Column descriptions are plain-language explanations; keys marked *observed* were checked for uniqueness and orphan values in the data, not from a database constraint.

> **Privacy:** `students dim` (student name, email, phone) and `leads` (student name) contain personal data. No values from these columns appear in this documentation, and they should be removed or anonymised before the data is published to GitHub.

## Summary

| # | Table | Source file | Type | Rows | Columns | Primary key (observed) |
|---|---|---|---|---|---|---|
| 1 | admissions | admissions.csv | Fact | 2,000 | 10 | admission id |
| 2 | branches dim | braches_dim.csv | Dimension | 5 | 2 | branch id |
| 3 | calls | calls.csv | Fact | 18,226 | 7 | call id |
| 4 | courses dim | courses_dim.csv | Dimension | 5 | 3 | course_id |
| 5 | employees | employees.csv | Dimension | 30 | 5 | emp id |
| 6 | fees | fees.csv | Fact | 2,000 | 8 | payment id |
| 7 | leads | leads.csv | Fact | 2,000 | 6 | lead id |
| 8 | marketing | marketing.csv | Fact | 150 | 8 | campaign id |
| 9 | placements | placements.csv | Fact | 2,000 | 7 | placement id |
| 10 | students dim | students_dim.csv | Dimension | 2,000 | 9 | student id |
| 11 | DateTable | date_table.csv | Date dimension | 1,096 | 6 | Date |

## admissions

**Source:** `admissions.csv` · **Type:** Fact · **Rows:** 2,000  
**Business purpose:** One row per admission; links a student to a branch, course and counselor and records the fee.  
**Primary key:** admission id  
**Foreign keys / relationships:** student id → students dim; branch id → branches dim; course id → courses dim; counselor id → employees (emp id)

| Column | CSV data type | Description |
|---|---|---|
| `admission id` | Text | Unique admission identifier |
| `student id` | Text | Admitted student |
| `branch id` | Text | Branch where admitted |
| `course id` | Text | Course enrolled |
| `lead source` | Text | Channel that brought the student (YouTube, LinkedIn, Instagram, Website, Walk-In, Referral) |
| `counselor id` | Text | Counselor who handled the admission |
| `admission date` | Text | Date of admission |
| `course fee` | Integer | Fee charged for the course (INR assumed) |
| `Admission Month` | Text | Month name of admission date |
| `Admission Year` | Integer | Year of admission date |

## branches dim

**Source:** `braches_dim.csv` · **Type:** Dimension · **Rows:** 5  
**Business purpose:** List of the 5 academy branches.  
**Primary key:** branch id  
**Foreign keys / relationships:** none

| Column | CSV data type | Description |
|---|---|---|
| `branch id` | Text | Unique branch code |
| `branch name` | Text | Branch name |

## calls

**Source:** `calls.csv` · **Type:** Fact · **Rows:** 18,226  
**Business purpose:** One row per counselor call to a student.  
**Primary key:** call id  
**Foreign keys / relationships:** student id → students dim; counselor id → employees (emp id)

| Column | CSV data type | Description |
|---|---|---|
| `call id` | Text | Unique call identifier |
| `student id` | Text | Student called |
| `call date` | Text | Date of call |
| `call status` | Text | Outcome (Connected, Not Connected, Follow-Up) |
| `call duration min` | Integer | Duration in minutes (0 on every Not Connected call; 1–25 otherwise) |
| `Call Category` | Text | Effective call or Short call |
| `counselor id` | Text | Counselor who made the call |

## courses dim

**Source:** `courses_dim.csv` · **Type:** Dimension · **Rows:** 5  
**Business purpose:** List of the 5 courses with list fee.  
**Primary key:** course_id  
**Foreign keys / relationships:** none

| Column | CSV data type | Description |
|---|---|---|
| `course_id` | Text | Unique course code |
| `course_name` | Text | Course name |
| `course_fee` | Integer | List fee for the course |

## employees

**Source:** `employees.csv` · **Type:** Dimension · **Rows:** 30  
**Business purpose:** 30 staff members (Sales and Placement departments).  
**Primary key:** emp id  
**Foreign keys / relationships:** branch id → branches dim

| Column | CSV data type | Description |
|---|---|---|
| `emp id` | Text | Unique employee code |
| `emp name` | Text | Employee name |
| `department` | Text | Sales or Placement |
| `branch id` | Text | Branch of employee |
| `salary` | Integer | Employee salary |

## fees

**Source:** `fees.csv` · **Type:** Fact · **Rows:** 2,000  
**Business purpose:** One row per student fee/payment record.  
**Primary key:** payment id  
**Foreign keys / relationships:** student id → students dim

| Column | CSV data type | Description |
|---|---|---|
| `payment id` | Text | Unique payment record |
| `student id` | Text | Student who owes/pays |
| `total fee` | Integer | Total fee payable |
| `paid fee` | Integer | Amount paid |
| `remaining fee` | Integer | Amount outstanding |
| `payment status` | Text | Completed or Pending |
| `payment mode` | Text | Cash, Card, Net Banking or UPI |
| `collection%` | Decimal | Paid fee ÷ total fee as a fraction (verified; 1.0 for Completed, 0.5–0.9 for Pending) |

## leads

**Source:** `leads.csv` · **Type:** Fact · **Rows:** 2,000  
**Business purpose:** One row per lead generated; no student id.  
**Primary key:** lead id  
**Foreign keys / relationships:** branch id → branches dim

| Column | CSV data type | Description |
|---|---|---|
| `lead id` | Text | Unique lead identifier |
| `student name` | Text | Lead's name (personal data) |
| `lead source` | Text | Channel of the lead |
| `branch id` | Text | Branch handling the lead |
| `lead status` | Text | Converted, Follow-Up or Lost |
| `generated date` | Text | Date the lead was created |

## marketing

**Source:** `marketing.csv` · **Type:** Fact · **Rows:** 150  
**Business purpose:** One row per marketing campaign with spend and results.  
**Primary key:** campaign id  
**Foreign keys / relationships:** none (platform and campaign month are text)

| Column | CSV data type | Description |
|---|---|---|
| `campaign id` | Text | Unique campaign identifier |
| `platform` | Text | YouTube, Facebook, Instagram or LinkedIn |
| `ad spend` | Integer | Amount spent |
| `leads generated` | Integer | Leads produced by the campaign |
| `admission converted` | Integer | Admissions attributed to the campaign |
| `campaign month` | Text | Month abbreviation (e.g. Jan) |
| `Cost Per Lead` | Decimal | Ad spend ÷ leads generated (verified, rounded to 4 decimals) |
| `Conversion Rate` | Decimal | Admission converted ÷ leads generated, stored as a fraction (verified) |

## placements

**Source:** `placements.csv` · **Type:** Fact · **Rows:** 2,000  
**Business purpose:** One row per student placement record.  
**Primary key:** placement id  
**Foreign keys / relationships:** student id → students dim

| Column | CSV data type | Description |
|---|---|---|
| `placement id` | Text | Unique placement record |
| `student id` | Text | Student |
| `placement status` | Text | Placed, Searching or Interview Running |
| `placement calls given` | Integer | Number of placement calls/interviews given (1–5) |
| `company name` | Text | Hiring company (7 distinct values) |
| `salary package lpa` | Decimal | Package in lakhs per annum (0 when not placed) |
| `Placment success ` | Text | Sucess or Not Placed (note spelling and trailing space in column name) |

## students dim

**Source:** `students_dim.csv` · **Type:** Dimension · **Rows:** 2,000  
**Business purpose:** One row per student.  
**Primary key:** student id  
**Foreign keys / relationships:** branch id → branches dim; course id → courses dim

| Column | CSV data type | Description |
|---|---|---|
| `student id` | Text | Unique student code |
| `student name` | Text | Name (personal data) |
| `gender` | Text | Female or Male |
| `city` | Text | City (6 distinct values) |
| `branch id` | Text | Branch |
| `course id` | Text | Course |
| `admission_date` | Text | Admission date |
| `email` | Text | Email (personal data) |
| `phone` | Integer | Phone number (personal data) |

## DateTable

**Source:** `date_table.csv` · **Type:** Date dimension · **Rows:** 1,096  
**Business purpose:** Daily calendar 2024-01-01 to 2026-12-31.  
**Primary key:** Date  
**Foreign keys / relationships:** none

| Column | CSV data type | Description |
|---|---|---|
| `Date` | Text | Calendar date |
| `Year` | Integer | Calendar year |
| `Month` | Text | Month name |
| `MonthNo` | Integer | Month number 1–12 |
| `Quarter` | Text | Q1–Q4 |
| `YearMonth` | Text | Text label such as 2024-Jan |

## Notes on source naming

- `braches_dim.csv` is spelled as supplied (branches).
- placements column `Placment success ` has a trailing space and the value `Sucess` is spelled as in the source; these are left unchanged to match the Power BI report.
- Currency and units are not stated in the files; INR is assumed from the context (LPA salary packages) and is ⏳ to confirm.
- Derived columns (`Admission Month`, `Admission Year`, `Cost Per Lead`, `Conversion Rate`, `collection%`) exist in the source files; whether they were created in Python, SQL or Excel is ⏳ pending.