
/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File: 04_Student_Admissions_Analysis.sql
   Database: education_360_db (MySQL 8.0)

   Objectives:
     1. Total admissions
     2. Monthly admissions
     3. Admissions by branch
     4. Admissions by course
     5. Student distribution
     6. Counselor performance
     7. Admission source analysis

   ============================================================================ */

USE education_360_db;


-- ============================================================================
-- 1. TOTAL ADMISSIONS
-- Business question:
-- How many admissions has the academy recorded?
--
-- Definition:
-- Total admissions = COUNT of unique admission IDs.
-- Unique admitted students = DISTINCT student IDs.
-- ============================================================================

SELECT
    COUNT(admission_id) AS total_admissions,
    COUNT(DISTINCT student_id) AS unique_admitted_students
FROM admissions;


-- ============================================================================
-- 2. MONTHLY ADMISSIONS
-- Business question:
-- How does admission volume change month by month?
--
-- Definition:
-- Count of admission records grouped by calendar year and month.
-- ============================================================================

SELECT
    YEAR(admission_date) AS admission_year,
    MONTH(admission_date) AS month_number,
    MONTHNAME(admission_date) AS month_name,
    COUNT(admission_id) AS total_admissions
FROM admissions
GROUP BY
    YEAR(admission_date),
    MONTH(admission_date),
    MONTHNAME(admission_date)
ORDER BY
    admission_year,
    month_number;


-- Monthly admission percentage contribution

SELECT
    DATE_FORMAT(admission_date, '%Y-%m') AS admission_month,
    COUNT(*) AS total_admissions,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM admissions),
        2
    ) AS admission_contribution_pct
FROM admissions
GROUP BY DATE_FORMAT(admission_date, '%Y-%m')
ORDER BY admission_month;


-- ============================================================================
-- 3. ADMISSIONS BY BRANCH
-- Business question:
-- Which branches generate the highest admission volume?
--
-- Definition:
-- Admissions counted by branch using branch_id.
-- Percentage denominator = all admission records.
-- ============================================================================

SELECT
    b.branch_id,
    b.branch_name,
    COUNT(a.admission_id) AS total_admissions,
    COALESCE(SUM(a.course_fee), 0) AS total_billed_fees,
    ROUND(
        COUNT(a.admission_id) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM admissions), 0),
        2
    ) AS admission_contribution_pct
FROM branches b
LEFT JOIN admissions a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name
ORDER BY
    total_admissions DESC;


-- ============================================================================
-- 4. ADMISSIONS BY COURSE
-- Business question:
-- Which courses attract the highest number of admissions?
--
-- Definition:
-- Admissions grouped by course identifier and course name.
-- ============================================================================

SELECT
    c.course_id,
    c.course_name,
    COUNT(a.admission_id) AS total_admissions,
    COALESCE(SUM(a.course_fee), 0) AS total_billed_fees,
    ROUND(AVG(a.course_fee), 2) AS average_admission_fee
FROM courses c
LEFT JOIN admissions a
    ON c.course_id = a.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY
    total_admissions DESC;


-- Course contribution percentage

SELECT
    c.course_name,
    COUNT(a.admission_id) AS total_admissions,
    ROUND(
        COUNT(a.admission_id) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM admissions), 0),
        2
    ) AS admission_contribution_pct
FROM courses c
LEFT JOIN admissions a
    ON c.course_id = a.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY
    admission_contribution_pct DESC;


-- ============================================================================
-- 5. STUDENT DISTRIBUTION
-- Business question:
-- How are students distributed by gender, city, branch and course?
--
-- Definition:
-- Student counts use unique student IDs.
-- ============================================================================

-- Gender distribution

SELECT
    gender,
    COUNT(DISTINCT student_id) AS total_students,
    ROUND(
        COUNT(DISTINCT student_id) * 100.0 /
        NULLIF((SELECT COUNT(DISTINCT student_id) FROM students), 0),
        2
    ) AS student_percentage
FROM students
GROUP BY gender
ORDER BY total_students DESC;


-- City distribution

SELECT
    city,
    COUNT(DISTINCT student_id) AS total_students
FROM students
GROUP BY city
ORDER BY total_students DESC;


-- Branch distribution

SELECT
    b.branch_name,
    COUNT(DISTINCT s.student_id) AS total_students
FROM branches b
LEFT JOIN students s
    ON b.branch_id = s.branch_id
GROUP BY
    b.branch_id,
    b.branch_name
ORDER BY total_students DESC;


-- Course distribution

SELECT
    c.course_name,
    COUNT(DISTINCT s.student_id) AS total_students
FROM courses c
LEFT JOIN students s
    ON c.course_id = s.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY total_students DESC;


-- ============================================================================
-- 6. COUNSELOR PERFORMANCE
-- Business question:
-- Which counselors handle the highest admission volume and billed fees?
--
-- Definition:
-- Admissions are attributed using admissions.counselor_id.
-- Revenue here means billed course fees, not collected payments.
-- ============================================================================

SELECT
    e.emp_id,
    e.emp_name,
    e.department,
    b.branch_name,
    COUNT(a.admission_id) AS total_admissions,
    COALESCE(SUM(a.course_fee), 0) AS total_billed_revenue,
    ROUND(AVG(a.course_fee), 2) AS average_course_fee
FROM employees e
LEFT JOIN branches b
    ON e.branch_id = b.branch_id
LEFT JOIN admissions a
    ON e.emp_id = a.counselor_id
GROUP BY
    e.emp_id,
    e.emp_name,
    e.department,
    b.branch_name
ORDER BY
    total_admissions DESC,
    total_billed_revenue DESC;


-- Top 5 counselors by admission volume

SELECT
    e.emp_id,
    e.emp_name,
    COUNT(a.admission_id) AS total_admissions
FROM employees e
INNER JOIN admissions a
    ON e.emp_id = a.counselor_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY total_admissions DESC
LIMIT 5;


-- ============================================================================
-- 7. ADMISSION SOURCE ANALYSIS
-- Business question:
-- Which lead sources contribute most to successful admissions?
--
-- Definition:
-- Admission records grouped by admissions.lead_source.
-- Conversion here means share of admissions by source, NOT lead conversion.
-- ============================================================================

SELECT
    lead_source,
    COUNT(admission_id) AS total_admissions,
    COUNT(DISTINCT student_id) AS unique_students,
    SUM(course_fee) AS total_billed_revenue,
    ROUND(AVG(course_fee), 2) AS average_course_fee,
    ROUND(
        COUNT(admission_id) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM admissions), 0),
        2
    ) AS admission_contribution_pct
FROM admissions
GROUP BY lead_source
ORDER BY total_admissions DESC;


-- ============================================================================
-- 8. BRANCH AND COURSE COMPARISON
-- Business question:
-- Which branch-course combinations generate the most admissions?
-- ============================================================================

SELECT
    b.branch_name,
    c.course_name,
    COUNT(a.admission_id) AS total_admissions,
    SUM(a.course_fee) AS total_billed_revenue
FROM admissions a
INNER JOIN branches b
    ON a.branch_id = b.branch_id
INNER JOIN courses c
    ON a.course_id = c.course_id
GROUP BY
    b.branch_id,
    b.branch_name,
    c.course_id,
    c.course_name
ORDER BY total_admissions DESC;


-- ============================================================================
-- 9. ADMISSION PERFORMANCE SEGMENTATION
-- Business question:
-- How can branches be classified by admission volume?
--
-- Definition:
-- Segments are based on admission counts in this dataset.
-- Thresholds are analytical categories, not official business targets.
-- ============================================================================

SELECT
    b.branch_name,
    COUNT(a.admission_id) AS total_admissions,
    CASE
        WHEN COUNT(a.admission_id) >= 450 THEN 'High Admissions'
        WHEN COUNT(a.admission_id) >= 350 THEN 'Medium Admissions'
        ELSE 'Low Admissions'
    END AS branch_performance
FROM branches b
LEFT JOIN admissions a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name
ORDER BY total_admissions DESC;


-- ============================================================================
-- END OF STUDENT AND ADMISSIONS ANALYSIS
-- ============================================================================
