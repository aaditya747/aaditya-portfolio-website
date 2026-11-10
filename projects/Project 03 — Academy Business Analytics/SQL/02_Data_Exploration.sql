
/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File    : 02_Data_Exploration.sql
   Database: education_360_db (MySQL 8.0)

   Objectives:
     - Total records in each table.
     - Distinct student counts.
     - Distinct courses and branches.
     - Minimum and maximum dates.
     - Numeric summaries.
     - Category distributions.

   Note:
     DateTable is excluded because it is maintained exclusively in Power BI.
     Fees has no payment date; admission dates are used only for cohort analysis.
   ============================================================================ */

USE education_360_db;

-- ============================================================================
-- 1. TOTAL RECORDS PER TABLE
-- Business question: How much data is available across academy operations?
-- Definition: Total number of rows in each table.
-- ============================================================================

SELECT 'Students' AS table_name, COUNT(*) AS total_records FROM students
UNION ALL
SELECT 'Admissions', COUNT(*) FROM admissions
UNION ALL
SELECT 'Fees', COUNT(*) FROM fees
UNION ALL
SELECT 'Placements', COUNT(*) FROM placements
UNION ALL
SELECT 'Calls', COUNT(*) FROM calls
UNION ALL
SELECT 'Leads', COUNT(*) FROM leads
UNION ALL
SELECT 'Marketing', COUNT(*) FROM marketing
UNION ALL
SELECT 'Employees', COUNT(*) FROM employees
UNION ALL
SELECT 'Branches', COUNT(*) FROM branches
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses;


-- ============================================================================
-- 2. DISTINCT STUDENTS, BRANCHES AND COURSES
-- Business question: How many unique students, branches and courses exist?
-- Definition: DISTINCT counts based on their respective primary identifiers.
-- ============================================================================

SELECT
    COUNT(*) AS total_student_records,
    COUNT(DISTINCT student_id) AS unique_students
FROM students;

SELECT
    COUNT(*) AS total_branches,
    COUNT(DISTINCT branch_id) AS unique_branch_ids
FROM branches;

SELECT
    COUNT(*) AS total_courses,
    COUNT(DISTINCT course_id) AS unique_course_ids
FROM courses;

-- Student distribution by branch

SELECT
    b.branch_name,
    COUNT(s.student_id) AS total_students
FROM branches b
LEFT JOIN students s
    ON b.branch_id = s.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_students DESC;

-- Student distribution by course

SELECT
    c.course_name,
    COUNT(s.student_id) AS total_students
FROM courses c
LEFT JOIN students s
    ON c.course_id = s.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_students DESC;


-- ============================================================================
-- 3. DATE RANGES
-- Business question: What is the available date coverage?
-- Definition: Earliest and latest dates in each operational date column.
-- ============================================================================

SELECT
    'Students Admission Date' AS source_table,
    MIN(admission_date) AS first_date,
    MAX(admission_date) AS last_date
FROM students

UNION ALL

SELECT
    'Admissions',
    MIN(admission_date),
    MAX(admission_date)
FROM admissions

UNION ALL

SELECT
    'Leads',
    MIN(generated_date),
    MAX(generated_date)
FROM leads

UNION ALL

SELECT
    'Calls',
    MIN(call_date),
    MAX(call_date)
FROM calls;

-- Fees does not contain a payment date.
-- This query analyses fee records by student admission cohort.

SELECT
    MIN(s.admission_date) AS earliest_admission_date,
    MAX(s.admission_date) AS latest_admission_date,
    COUNT(f.payment_id) AS fee_records
FROM fees f
JOIN students s
    ON f.student_id = s.student_id;


-- ============================================================================
-- 4. NUMERIC SUMMARIES
-- Business question: What are the academy's financial and operational ranges?
-- Definition: SUM, AVG, MIN and MAX over available numeric columns.
-- ============================================================================

-- Fee summary

SELECT
    SUM(total_fee) AS total_billed_fees,
    SUM(paid_fee) AS total_collected_fees,
    SUM(remaining_fee) AS total_outstanding_fees,
    ROUND(AVG(total_fee), 2) AS average_total_fee,
    ROUND(AVG(paid_fee), 2) AS average_paid_fee,
    ROUND(AVG(remaining_fee), 2) AS average_remaining_fee
FROM fees;

-- Placement salary summary

SELECT
    COUNT(*) AS placed_students,
    ROUND(MIN(salary_package_lpa), 2) AS minimum_salary_lpa,
    ROUND(MAX(salary_package_lpa), 2) AS maximum_salary_lpa,
    ROUND(AVG(salary_package_lpa), 2) AS average_salary_lpa
FROM placements
WHERE placement_status = 'Placed';

-- Call duration summary

SELECT
    COUNT(*) AS total_calls,
    ROUND(AVG(call_duration_min), 2) AS average_call_duration,
    MIN(call_duration_min) AS minimum_call_duration,
    MAX(call_duration_min) AS maximum_call_duration,
    SUM(call_duration_min) AS total_call_duration
FROM calls;

-- Marketing campaign summary

SELECT
    SUM(ad_spend) AS total_ad_spend,
    SUM(leads_generated) AS total_campaign_leads,
    SUM(admission_converted) AS total_campaign_admissions,
    ROUND(AVG(cost_per_lead), 2) AS average_campaign_cpl,
    ROUND(AVG(conversion_rate), 2) AS average_stored_conversion_rate
FROM marketing;

-- Employee salary summary

SELECT
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 2) AS average_employee_salary,
    MIN(salary) AS minimum_employee_salary,
    MAX(salary) AS maximum_employee_salary
FROM employees;


-- ============================================================================
-- 5. CATEGORY DISTRIBUTIONS
-- Business question: How are students, leads and payments distributed?
-- Definition: Record counts grouped by categorical fields.
-- ============================================================================

-- Lead source distribution

SELECT
    lead_source,
    COUNT(*) AS total_leads
FROM leads
GROUP BY lead_source
ORDER BY total_leads DESC;

-- Lead status distribution

SELECT
    lead_status,
    COUNT(*) AS total_records
FROM leads
GROUP BY lead_status
ORDER BY total_records DESC;

-- Payment status distribution

SELECT
    payment_status,
    COUNT(*) AS payment_records,
    SUM(paid_fee) AS collected_amount,
    SUM(remaining_fee) AS outstanding_amount
FROM fees
GROUP BY payment_status
ORDER BY payment_records DESC;

-- Payment mode distribution

SELECT
    payment_mode,
    COUNT(*) AS payment_records,
    SUM(paid_fee) AS total_collected
FROM fees
GROUP BY payment_mode
ORDER BY total_collected DESC;

-- Student city distribution

SELECT
    city,
    COUNT(*) AS total_students
FROM students
GROUP BY city
ORDER BY total_students DESC;

-- Student gender distribution

SELECT
    gender,
    COUNT(*) AS total_students
FROM students
GROUP BY gender
ORDER BY total_students DESC;

-- Placement status distribution

SELECT
    placement_status,
    COUNT(*) AS total_students
FROM placements
GROUP BY placement_status
ORDER BY total_students DESC;

-- Call category distribution

SELECT
    call_category,
    COUNT(*) AS total_calls
FROM calls
GROUP BY call_category
ORDER BY total_calls DESC;

-- ============================================================================
-- END OF DATA EXPLORATION
-- ============================================================================
