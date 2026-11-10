
/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File: 03_Data_Quality_Checks.sql
   Database: education_360_db (MySQL 8.0)

   Purpose:
   Identify data quality issues without modifying source records.

   IMPORTANT:
   All queries are diagnostic SELECT statements.
   No UPDATE or DELETE operations are performed.
   DateTable is excluded because it belongs to Power BI.
   ============================================================================ */

USE education_360_db;


-- ============================================================================
-- 1. NULL VALUES
-- Business question: Which important columns contain missing values?
-- Definition: Count of NULL values in each selected column.
-- ============================================================================

SELECT 'students.student_id' AS column_name,
       SUM(student_id IS NULL) AS null_count FROM students
UNION ALL
SELECT 'students.student_name', SUM(student_name IS NULL) FROM students
UNION ALL
SELECT 'students.branch_id', SUM(branch_id IS NULL) FROM students
UNION ALL
SELECT 'students.course_id', SUM(course_id IS NULL) FROM students
UNION ALL
SELECT 'admissions.admission_id', SUM(admission_id IS NULL) FROM admissions
UNION ALL
SELECT 'admissions.student_id', SUM(student_id IS NULL) FROM admissions
UNION ALL
SELECT 'fees.payment_id', SUM(payment_id IS NULL) FROM fees
UNION ALL
SELECT 'fees.paid_fee', SUM(paid_fee IS NULL) FROM fees
UNION ALL
SELECT 'placements.placement_id', SUM(placement_id IS NULL) FROM placements
UNION ALL
SELECT 'placements.placement_status', SUM(placement_status IS NULL) FROM placements
UNION ALL
SELECT 'calls.call_id', SUM(call_id IS NULL) FROM calls
UNION ALL
SELECT 'calls.call_date', SUM(call_date IS NULL) FROM calls
UNION ALL
SELECT 'leads.lead_id', SUM(lead_id IS NULL) FROM leads
UNION ALL
SELECT 'leads.lead_status', SUM(lead_status IS NULL) FROM leads
UNION ALL
SELECT 'marketing.campaign_id', SUM(campaign_id IS NULL) FROM marketing;


-- ============================================================================
-- 2. DUPLICATE IDs AND DUPLICATE ROWS
-- Business question: Are primary identifiers duplicated?
-- Definition: IDs appearing more than once.
-- ============================================================================

SELECT student_id, COUNT(*) AS occurrences
FROM students
GROUP BY student_id
HAVING COUNT(*) > 1;

SELECT admission_id, COUNT(*) AS occurrences
FROM admissions
GROUP BY admission_id
HAVING COUNT(*) > 1;

SELECT payment_id, COUNT(*) AS occurrences
FROM fees
GROUP BY payment_id
HAVING COUNT(*) > 1;

SELECT placement_id, COUNT(*) AS occurrences
FROM placements
GROUP BY placement_id
HAVING COUNT(*) > 1;

SELECT call_id, COUNT(*) AS occurrences
FROM calls
GROUP BY call_id
HAVING COUNT(*) > 1;

SELECT lead_id, COUNT(*) AS occurrences
FROM leads
GROUP BY lead_id
HAVING COUNT(*) > 1;

-- Duplicate complete student records

SELECT student_id, student_name, gender, city,
       branch_id, course_id, admission_date, COUNT(*) AS occurrences
FROM students
GROUP BY student_id, student_name, gender, city,
         branch_id, course_id, admission_date
HAVING COUNT(*) > 1;

-- Check whether student names are unique

SELECT
    COUNT(*) AS total_student_records,
    COUNT(DISTINCT student_name) AS distinct_student_names
FROM students;


-- ============================================================================
-- 3. DATE VALIDITY AND RANGES
-- Business question: Are operational dates missing or outside expected ranges?
-- Definition: NULL dates and minimum/maximum available dates.
-- ============================================================================

SELECT
    'Students' AS table_name,
    SUM(admission_date IS NULL) AS null_dates,
    MIN(admission_date) AS earliest_date,
    MAX(admission_date) AS latest_date
FROM students

UNION ALL

SELECT
    'Admissions',
    SUM(admission_date IS NULL),
    MIN(admission_date),
    MAX(admission_date)
FROM admissions

UNION ALL

SELECT
    'Leads',
    SUM(generated_date IS NULL),
    MIN(generated_date),
    MAX(generated_date)
FROM leads

UNION ALL

SELECT
    'Calls',
    SUM(call_date IS NULL),
    MIN(call_date),
    MAX(call_date)
FROM calls;

-- Future dates relative to the current date

SELECT student_id, admission_date
FROM students
WHERE admission_date > CURRENT_DATE();

SELECT lead_id, generated_date
FROM leads
WHERE generated_date > CURRENT_DATE();

SELECT call_id, call_date
FROM calls
WHERE call_date > CURRENT_DATE();


-- ============================================================================
-- 4. ORPHAN FOREIGN KEYS
-- Business question: Do fact records reference missing dimension records?
-- Definition: Child records with no matching parent identifier.
-- Expected result: Zero rows for valid relationships.
-- ============================================================================

-- Students -> Branches

SELECT s.student_id, s.branch_id
FROM students s
LEFT JOIN branches b ON s.branch_id = b.branch_id
WHERE b.branch_id IS NULL;

-- Students -> Courses

SELECT s.student_id, s.course_id
FROM students s
LEFT JOIN courses c ON s.course_id = c.course_id
WHERE c.course_id IS NULL;

-- Admissions -> Students

SELECT a.admission_id, a.student_id
FROM admissions a
LEFT JOIN students s ON a.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Admissions -> Branches

SELECT a.admission_id, a.branch_id
FROM admissions a
LEFT JOIN branches b ON a.branch_id = b.branch_id
WHERE b.branch_id IS NULL;

-- Admissions -> Courses

SELECT a.admission_id, a.course_id
FROM admissions a
LEFT JOIN courses c ON a.course_id = c.course_id
WHERE c.course_id IS NULL;

-- Admissions -> Employees (counselors)

SELECT a.admission_id, a.counselor_id
FROM admissions a
LEFT JOIN employees e ON a.counselor_id = e.emp_id
WHERE a.counselor_id IS NOT NULL
  AND e.emp_id IS NULL;

-- Fees -> Students

SELECT f.payment_id, f.student_id
FROM fees f
LEFT JOIN students s ON f.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Placements -> Students

SELECT p.placement_id, p.student_id
FROM placements p
LEFT JOIN students s ON p.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Calls -> Students

SELECT c.call_id, c.student_id
FROM calls c
LEFT JOIN students s ON c.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Calls -> Employees

SELECT c.call_id, c.counselor_id
FROM calls c
LEFT JOIN employees e ON c.counselor_id = e.emp_id
WHERE c.counselor_id IS NOT NULL
  AND e.emp_id IS NULL;

-- Employees -> Branches

SELECT e.emp_id, e.branch_id
FROM employees e
LEFT JOIN branches b ON e.branch_id = b.branch_id
WHERE b.branch_id IS NULL;

-- Leads -> Branches

SELECT l.lead_id, l.branch_id
FROM leads l
LEFT JOIN branches b ON l.branch_id = b.branch_id
WHERE l.branch_id IS NOT NULL
  AND b.branch_id IS NULL;


-- ============================================================================
-- 5. UNMATCHED RECORDS BETWEEN RELATED TABLES
-- Business question: Are admissions and operational records consistent?
-- Definition: Compare record counts and identifiers.
-- IMPORTANT: Do not match leads to students using names.
-- ============================================================================

-- Students without admissions

SELECT s.student_id
FROM students s
LEFT JOIN admissions a ON s.student_id = a.student_id
WHERE a.student_id IS NULL;

-- Admissions without corresponding student records

SELECT a.admission_id, a.student_id
FROM admissions a
LEFT JOIN students s ON a.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Students without fee records

SELECT s.student_id
FROM students s
LEFT JOIN fees f ON s.student_id = f.student_id
WHERE f.student_id IS NULL;

-- Students without placement records

SELECT s.student_id
FROM students s
LEFT JOIN placements p ON s.student_id = p.student_id
WHERE p.student_id IS NULL;

-- Students without call records

SELECT s.student_id
FROM students s
LEFT JOIN calls c ON s.student_id = c.student_id
WHERE c.student_id IS NULL;

-- Compare leads and admissions by record counts

SELECT
    (SELECT COUNT(*) FROM leads) AS total_leads,
    (SELECT COUNT(*) FROM admissions) AS total_admissions,
    (SELECT COUNT(*) FROM students) AS total_students;

-- Check overlapping lead IDs and student IDs.
-- An overlap does NOT prove that they represent the same person.

SELECT COUNT(*) AS coincident_id_values
FROM leads l
INNER JOIN students s
    ON l.lead_id = s.student_id;


-- ============================================================================
-- 6. NUMERIC VALIDITY
-- Business question: Are financial and operational numeric values reasonable?
-- Definition: Negative values, out-of-range percentages and fee arithmetic.
-- ============================================================================

-- Negative fee values

SELECT payment_id, total_fee, paid_fee, remaining_fee
FROM fees
WHERE total_fee < 0
   OR paid_fee < 0
   OR remaining_fee < 0;

-- Fee arithmetic mismatch

SELECT payment_id, total_fee, paid_fee, remaining_fee,
       paid_fee + remaining_fee AS calculated_total
FROM fees
WHERE paid_fee + remaining_fee <> total_fee;

-- Collection percentage outside the 0-1 fraction range

SELECT payment_id, collection_pct
FROM fees
WHERE collection_pct < 0
   OR collection_pct > 1;

-- Negative marketing spend or counts

SELECT campaign_id, ad_spend, leads_generated, admission_converted
FROM marketing
WHERE ad_spend < 0
   OR leads_generated < 0
   OR admission_converted < 0;

-- Negative call durations

SELECT call_id, call_duration_min
FROM calls
WHERE call_duration_min < 0;

-- Negative placement salary packages

SELECT placement_id, salary_package_lpa
FROM placements
WHERE salary_package_lpa < 0;

-- Marketing conversion anomalies

SELECT campaign_id, platform, leads_generated,
       admission_converted, conversion_rate
FROM marketing
WHERE admission_converted > leads_generated
   OR conversion_rate > 1;


-- ============================================================================
-- 7. INCONSISTENT CATEGORY VALUES AND SPELLING
-- Business question: Are category labels consistent?
-- Definition: List distinct values and their record counts.
-- ============================================================================

-- Placement success spelling

SELECT placement_success, COUNT(*) AS occurrences
FROM placements
GROUP BY placement_success
ORDER BY occurrences DESC;

-- Placement status

SELECT placement_status, COUNT(*) AS occurrences
FROM placements
GROUP BY placement_status
ORDER BY occurrences DESC;

-- Lead status

SELECT lead_status, COUNT(*) AS occurrences
FROM leads
GROUP BY lead_status
ORDER BY occurrences DESC;

-- Payment status

SELECT payment_status, COUNT(*) AS occurrences
FROM fees
GROUP BY payment_status
ORDER BY occurrences DESC;

-- Payment mode

SELECT payment_mode, COUNT(*) AS occurrences
FROM fees
GROUP BY payment_mode
ORDER BY occurrences DESC;

-- Marketing platforms

SELECT platform, COUNT(*) AS campaigns
FROM marketing
GROUP BY platform
ORDER BY campaigns DESC;

-- Lead sources

SELECT lead_source, COUNT(*) AS leads
FROM leads
GROUP BY lead_source
ORDER BY leads DESC;


-- ============================================================================
-- 8. FINDINGS LOG
-- Business question: What are the key data-quality indicators?
-- Definition: Summary counts and known source limitations.
-- ============================================================================

SELECT
    (SELECT COUNT(*) FROM students) AS student_records,
    (SELECT COUNT(DISTINCT student_id) FROM students) AS unique_students,
    (SELECT COUNT(DISTINCT student_name) FROM students) AS distinct_student_names,
    (SELECT COUNT(*) FROM admissions) AS admission_records,
    (SELECT COUNT(*) FROM leads) AS lead_records,
    (SELECT COUNT(*) FROM marketing) AS marketing_campaign_records,
    (SELECT COUNT(*) FROM placements) AS placement_records,
    (SELECT COUNT(*) FROM calls) AS call_records;

-- Compare lead status counts with admission records

SELECT
    lead_status,
    COUNT(*) AS lead_records
FROM leads
GROUP BY lead_status;

SELECT COUNT(*) AS total_admissions
FROM admissions;

-- Known issues to investigate and document:
-- 1. Student names are not unique; do not use names as join keys.
-- 2. Lead and student IDs are not proven to identify the same people.
-- 3. Marketing campaign data has a different grain from individual leads.
-- 4. Marketing contains conversion anomalies above 100%.
-- 5. Source placement_success includes the spelling 'Sucess'.
-- 6. Fees does not contain a payment date.
-- 7. DateTable is maintained separately in Power BI.
-- 8. Source data is not modified by this script.

-- ============================================================================
-- END OF DATA QUALITY CHECKS
-- ============================================================================
