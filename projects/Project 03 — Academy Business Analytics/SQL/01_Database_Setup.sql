/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File    : 01_Database_Setup.sql
   Database: education_360_db   (MySQL 8.0, run in MySQL Workbench)

   Objectives:
     - Create the database and one table per CSV (11 tables).
     - Choose data types from the ACTUAL CSV contents (max lengths / ranges inspected).
     - Import all 11 CSVs without modifying them.
     - Add foreign keys ONLY after orphan checks prove they are valid (Part 4).

   Design decisions (documented, not silent):
     - Column names converted to snake_case (e.g. 'admission id' -> admission_id,
       'collection%' -> collection_pct, 'Placment success ' -> placement_success).
     - CSV dates look like '2024-02-04 00:00:00.000' (time part is always midnight
       in the files inspected), so they are stored as DATE via LEFT(value,10).
     - Source values are kept AS-IS. Example: placement_success contains the
       spelling 'Sucess' in the file. It is NOT corrected here; it is a data
       quality finding for 03_Data_Quality_Checks.sql.
     - Table 'branches' is loaded from the file actually named braches_dim.csv.
     - students holds personal data (name, email, phone). Never publish outputs
       showing these columns, and keep Dataset/ out of GitHub.
   ============================================================================ */

-- ============================================================================
-- PART 1: CREATE DATABASE
-- ============================================================================
CREATE DATABASE IF NOT EXISTS education_360_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE education_360_db;

-- ============================================================================
-- PART 2: CREATE TABLES  (dimensions first, then facts)
-- Foreign keys are intentionally NOT declared yet (see Part 4).
-- ============================================================================

DROP TABLE IF EXISTS calls, placements, fees, leads, admissions, students,
                     employees, marketing, courses, branches, date_table;

-- 2.1 branches  <- braches_dim.csv (5 rows)
CREATE TABLE branches (
    branch_id    CHAR(5)     NOT NULL,
    branch_name  VARCHAR(50) NOT NULL,
    PRIMARY KEY (branch_id)
);

-- 2.2 courses  <- courses_dim.csv (5 rows)
CREATE TABLE courses (
    course_id    CHAR(4)     NOT NULL,
    course_name  VARCHAR(50) NOT NULL,
    course_fee   INT         NOT NULL,
    PRIMARY KEY (course_id)
);

-- 2.3 employees  <- employees.csv (30 rows)
CREATE TABLE employees (
    emp_id       CHAR(4)     NOT NULL,
    emp_name     VARCHAR(50) NOT NULL,   -- 29 distinct names for 30 rows: names are NOT unique
    department   VARCHAR(30) NOT NULL,
    branch_id    CHAR(5)     NOT NULL,
    salary       INT         NOT NULL,
    PRIMARY KEY (emp_id)
);

-- 2.4 students  <- students_dim.csv (2,000 rows)  ** contains personal data **
CREATE TABLE students (
    student_id      CHAR(6)      NOT NULL,
    student_name    VARCHAR(60)  NOT NULL,   -- 733 distinct names: NOT unique
    gender          VARCHAR(10),
    city            VARCHAR(30),
    branch_id       CHAR(5)      NOT NULL,
    course_id       CHAR(4)      NOT NULL,
    admission_date  DATE,
    email           VARCHAR(100),
    phone           BIGINT,                  -- 10-digit numbers exceed INT range
    PRIMARY KEY (student_id)
);

-- 2.5 admissions  <- admissions.csv (2,000 rows)
CREATE TABLE admissions (
    admission_id     CHAR(6)     NOT NULL,
    student_id       CHAR(6)     NOT NULL,
    branch_id        CHAR(5)     NOT NULL,
    course_id        CHAR(4)     NOT NULL,
    lead_source      VARCHAR(30),
    counselor_id     CHAR(4),
    admission_date   DATE,
    course_fee       INT,
    admission_month  VARCHAR(15),
    admission_year   SMALLINT,
    PRIMARY KEY (admission_id)
);

-- 2.6 fees  <- fees.csv (2,000 rows)
CREATE TABLE fees (
    payment_id      CHAR(6)      NOT NULL,
    student_id      CHAR(6)      NOT NULL,
    total_fee       INT,
    paid_fee        INT,
    remaining_fee   INT,
    payment_status  VARCHAR(20),
    payment_mode    VARCHAR(30),
    collection_pct  DECIMAL(5,4),            -- source column 'collection%' (0.5 - 1.0 = fraction, not 0-100)
    PRIMARY KEY (payment_id)
);

-- 2.7 leads  <- leads.csv (2,000 rows)
CREATE TABLE leads (
    lead_id         CHAR(6)      NOT NULL,
    student_name    VARCHAR(60),
    lead_source     VARCHAR(30),
    branch_id       CHAR(5),
    lead_status     VARCHAR(20),
    generated_date  DATE,
    PRIMARY KEY (lead_id)
);

-- 2.8 marketing  <- marketing.csv (150 rows)
CREATE TABLE marketing (
    campaign_id          CHAR(4)       NOT NULL,
    platform             VARCHAR(30),
    ad_spend             INT,
    leads_generated      INT,
    admission_converted  INT,
    campaign_month       CHAR(3),              -- 'Jan'..'Dec'; no year column in source
    cost_per_lead        DECIMAL(10,4),
    conversion_rate      DECIMAL(6,4),         -- stored value; max in file is > 1 (see quality checks)
    PRIMARY KEY (campaign_id)
);

-- 2.9 placements  <- placements.csv (2,000 rows)
CREATE TABLE placements (
    placement_id           VARCHAR(10) NOT NULL,
    student_id             CHAR(6)     NOT NULL,
    placement_status       VARCHAR(30),
    placement_calls_given  TINYINT,
    company_name           VARCHAR(30),
    salary_package_lpa     DECIMAL(5,2),
    placement_success      VARCHAR(20),         -- source column 'Placment success ' (values kept as-is)
    PRIMARY KEY (placement_id)
);

-- 2.10 calls  <- calls.csv (18,226 rows)
CREATE TABLE calls (
    call_id            VARCHAR(15) NOT NULL,
    student_id         CHAR(6)     NOT NULL,
    call_date          DATE,
    call_status        VARCHAR(30),
    call_duration_min  SMALLINT,
    call_category      VARCHAR(30),
    counselor_id       CHAR(4),
    PRIMARY KEY (call_id)
);

-- 2.11 date_table  <- date_table.csv (1,096 rows)
CREATE TABLE date_table (
    date_key          DATE        NOT NULL,
    year              SMALLINT,
    month_name        VARCHAR(15),
    month_no          TINYINT,
    quarter           CHAR(2),
    year_month_label  VARCHAR(10),               -- e.g. '2024-Jan' (YEAR_MONTH is a MySQL keyword)
    PRIMARY KEY (date_key)
);

-- ============================================================================
-- PART 3: IMPORT THE CSV FILES
-- ============================================================================
-- Method A (recommended, scripted): LOAD DATA LOCAL INFILE
--   1. Replace <PATH> below with the FULL path to your Dataset folder, using forward
--      slashes, e.g. C:/Users/you/Project_03_Education_360_Analysis/Dataset
--   2. Allow local files (run once):   SET GLOBAL local_infile = 1;
--   3. In Workbench: Database > Manage Connections > your connection >
--      Advanced tab > Others, add:  OPT_LOCAL_INFILE=1   then reconnect.
--   If it still fails, use Method B.
--
-- Method B (no config needed): right-click each table in the Schemas panel >
--   'Table Data Import Wizard' > choose the CSV > 'Use existing table' and map the
--   columns in order. Slower, but works for all 11 files.
--
-- Dates: the CSV text '2024-02-04 00:00:00.000' is read into a variable (@d) and
-- trimmed with LEFT(@d,10) so only the date part is stored.
-- ============================================================================

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '<PATH>/braches_dim.csv'
INTO TABLE branches
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(branch_id, branch_name);

LOAD DATA LOCAL INFILE '<PATH>/courses_dim.csv'
INTO TABLE courses
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(course_id, course_name, course_fee);

LOAD DATA LOCAL INFILE '<PATH>/employees.csv'
INTO TABLE employees
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(emp_id, emp_name, department, branch_id, salary);

LOAD DATA LOCAL INFILE '<PATH>/students_dim.csv'
INTO TABLE students
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(student_id, student_name, gender, city, branch_id, course_id, @d, email, phone)
SET admission_date = LEFT(@d, 10);

LOAD DATA LOCAL INFILE '<PATH>/admissions.csv'
INTO TABLE admissions
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(admission_id, student_id, branch_id, course_id, lead_source, counselor_id,
 @d, course_fee, admission_month, admission_year)
SET admission_date = LEFT(@d, 10);

LOAD DATA LOCAL INFILE '<PATH>/fees.csv'
INTO TABLE fees
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(payment_id, student_id, total_fee, paid_fee, remaining_fee,
 payment_status, payment_mode, collection_pct);

LOAD DATA LOCAL INFILE '<PATH>/leads.csv'
INTO TABLE leads
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(lead_id, student_name, lead_source, branch_id, lead_status, @d)
SET generated_date = LEFT(@d, 10);

LOAD DATA LOCAL INFILE '<PATH>/marketing.csv'
INTO TABLE marketing
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(campaign_id, platform, ad_spend, leads_generated, admission_converted,
 campaign_month, cost_per_lead, conversion_rate);

LOAD DATA LOCAL INFILE '<PATH>/placements.csv'
INTO TABLE placements
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(placement_id, student_id, placement_status, placement_calls_given,
 company_name, salary_package_lpa, placement_success);

LOAD DATA LOCAL INFILE '<PATH>/calls.csv'
INTO TABLE calls
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(call_id, student_id, @d, call_status, call_duration_min, call_category, counselor_id)
SET call_date = LEFT(@d, 10);

LOAD DATA LOCAL INFILE '<PATH>/date_table.csv'
INTO TABLE date_table
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@d, year, month_name, month_no, quarter, year_month_label)
SET date_key = LEFT(@d, 10);

-- ============================================================================
-- PART 3b: VERIFY THE IMPORT
-- Expected row counts come from the CSV files (line count minus header).
-- ============================================================================
SELECT 'admissions' AS table_name, COUNT(*) AS loaded_rows, 2000  AS expected_rows FROM admissions
UNION ALL SELECT 'branches',   COUNT(*), 5     FROM branches
UNION ALL SELECT 'calls',      COUNT(*), 18226 FROM calls
UNION ALL SELECT 'courses',    COUNT(*), 5     FROM courses
UNION ALL SELECT 'date_table', COUNT(*), 1096  FROM date_table
UNION ALL SELECT 'employees',  COUNT(*), 30    FROM employees
UNION ALL SELECT 'fees',       COUNT(*), 2000  FROM fees
UNION ALL SELECT 'leads',      COUNT(*), 2000  FROM leads
UNION ALL SELECT 'marketing',  COUNT(*), 150   FROM marketing
UNION ALL SELECT 'placements', COUNT(*), 2000  FROM placements
UNION ALL SELECT 'students',   COUNT(*), 2000  FROM students;

-- Check that no date came in as NULL or 0000-00-00 because of a format problem
SELECT
    SUM(admission_date IS NULL) AS students_null_dates
FROM students;

-- ============================================================================
-- PART 4: FOREIGN KEYS  (added AFTER orphan checks - not run yet)
-- Candidate relationships observed in the data (to be proven with SQL first):
--   students.branch_id     -> branches.branch_id
--   students.course_id     -> courses.course_id
--   admissions.student_id  -> students.student_id
--   admissions.branch_id   -> branches.branch_id
--   admissions.course_id   -> courses.course_id
--   admissions.counselor_id-> employees.emp_id
--   fees.student_id        -> students.student_id
--   placements.student_id  -> students.student_id
--   calls.student_id       -> students.student_id
--   calls.counselor_id     -> employees.emp_id
--   employees.branch_id    -> branches.branch_id
--   leads.branch_id        -> branches.branch_id
-- NOT a proven relationship: leads <-> students/admissions (no shared key column;
--   lead_id numbers match student_id numbers, but that must be validated first).
--   marketing has no key to any other table.
-- ============================================================================
-- TODO (Stage 1B): run orphan-check queries, then add ALTER TABLE ... ADD CONSTRAINT.
