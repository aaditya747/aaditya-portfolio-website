
/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File    : 06_Placement_Analytics.sql
   Database: education_360_db (MySQL 8.0)

   Objectives:
     - Total placed students.
     - Overall recorded placement rate.
     - Branch-wise placement performance.
     - Placement status distribution.
     - Placement call analysis.
     - Company and salary package analysis.
     - Recruiter/counselor performance where supported.

   IMPORTANT DEFINITIONS:
     - Placed students: distinct student_id with placement_status = 'Placed'.
     - Overall recorded placement rate:
       Distinct placed students / Total students * 100.
     - Total students is used as a proxy denominator because a separate
       eligible-student population is not available in the dataset.
     - This is NOT an official eligible-student placement rate.
     - Placement calls are opportunities/support activity, not successful
       placement outcomes.
     - No placement date column is available, so admission date is used only
       as a cohort reference where explicitly labelled.

   All queries are SELECT-only.
   ============================================================================ */

USE education_360_db;


/* ----------------------------------------------------------------------------
   1. TOTAL PLACED STUDENTS

   Business question:
   How many students have successfully been placed?

   Definition:
   Placed students = distinct student_id with placement_status = 'Placed'.
   ---------------------------------------------------------------------------- */

SELECT
    COUNT(*) AS total_placement_records,
    COUNT(DISTINCT student_id) AS students_with_placement_records,
    COUNT(DISTINCT CASE
        WHEN LOWER(TRIM(placement_status)) = 'placed'
        THEN student_id
    END) AS total_placed_students
FROM placements;


/* Placement status distribution */

SELECT
    placement_status,
    COUNT(*) AS total_records,
    COUNT(DISTINCT student_id) AS unique_students,

    ROUND(
        COUNT(*) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM placements), 0),
        2
    ) AS share_of_placement_records_pct

FROM placements
GROUP BY placement_status
ORDER BY total_records DESC;


/* ----------------------------------------------------------------------------
   2. OVERALL RECORDED PLACEMENT RATE

   Business question:
   What proportion of all recorded students have been placed?

   Denominator:
   Total distinct students in the students table.

   Formula:
   Distinct placed students / Total distinct students * 100.

   Limitation:
   The dataset does not identify a separate eligible-student population.
   Therefore, this is an overall recorded placement rate, not an official
   eligible-student placement rate.
   ---------------------------------------------------------------------------- */

SELECT
    (SELECT COUNT(DISTINCT student_id)
     FROM students) AS total_students,

    (SELECT COUNT(DISTINCT student_id)
     FROM placements
     WHERE LOWER(TRIM(placement_status)) = 'placed')
        AS total_placed_students,

    ROUND(
        (SELECT COUNT(DISTINCT student_id)
         FROM placements
         WHERE LOWER(TRIM(placement_status)) = 'placed') * 100.0
        /
        NULLIF(
            (SELECT COUNT(DISTINCT student_id) FROM students),
            0
        ),
        2
    ) AS overall_recorded_placement_rate_pct;


/* ----------------------------------------------------------------------------
   3. BRANCH-WISE PLACEMENT PERFORMANCE

   Business question:
   Which branches have the highest number and proportion of placed students?

   Denominator:
   Total distinct students belonging to each branch.

   Branch placement rate:
   Placed students in branch / Total students in branch * 100.

   Students without a placement record remain included in the denominator.
   ---------------------------------------------------------------------------- */

SELECT
    b.branch_id,
    b.branch_name,

    COUNT(DISTINCT s.student_id) AS total_students,

    COUNT(DISTINCT CASE
        WHEN LOWER(TRIM(p.placement_status)) = 'placed'
        THEN s.student_id
    END) AS placed_students,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN LOWER(TRIM(p.placement_status)) = 'placed'
            THEN s.student_id
        END) * 100.0
        /
        NULLIF(COUNT(DISTINCT s.student_id), 0),
        2
    ) AS branch_placement_rate_pct

FROM branches b

LEFT JOIN students s
    ON b.branch_id = s.branch_id

LEFT JOIN placements p
    ON s.student_id = p.student_id

GROUP BY
    b.branch_id,
    b.branch_name

ORDER BY branch_placement_rate_pct DESC;


/* ----------------------------------------------------------------------------
   4. PLACEMENT TREND / COHORT ANALYSIS

   Business question:
   How do placement outcomes vary by student admission year and month?

   Definition:
   Students are grouped by their admission date, not their actual placement
   date. The dataset does not contain a dedicated placement date.

   Denominator:
   Students admitted in the respective cohort.
   ---------------------------------------------------------------------------- */

SELECT
    YEAR(s.admission_date) AS admission_year,
    MONTH(s.admission_date) AS admission_month,

    COUNT(DISTINCT s.student_id) AS total_students,

    COUNT(DISTINCT CASE
        WHEN LOWER(TRIM(p.placement_status)) = 'placed'
        THEN s.student_id
    END) AS placed_students,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN LOWER(TRIM(p.placement_status)) = 'placed'
            THEN s.student_id
        END) * 100.0
        /
        NULLIF(COUNT(DISTINCT s.student_id), 0),
        2
    ) AS cohort_recorded_placement_rate_pct

FROM students s

LEFT JOIN placements p
    ON s.student_id = p.student_id

WHERE s.admission_date IS NOT NULL

GROUP BY
    YEAR(s.admission_date),
    MONTH(s.admission_date)

ORDER BY
    admission_year,
    admission_month;


/* ----------------------------------------------------------------------------
   5. PLACEMENT CALLS VS OUTCOME

   Business question:
   How many placement calls are recorded, and how do call counts relate
   descriptively to placement status?

   Definition:
   Placement calls = SUM(placement_calls_given) from placements.
   Average calls = average placement calls per student record.

   Important:
   This is descriptive analysis. It does not establish that calls caused
   successful placements.
   ---------------------------------------------------------------------------- */

SELECT
    placement_status,

    COUNT(DISTINCT student_id) AS total_students,

    SUM(placement_calls_given) AS total_placement_calls,

    ROUND(
        AVG(placement_calls_given),
        2
    ) AS average_calls_per_student,

    MIN(placement_calls_given) AS minimum_calls,

    MAX(placement_calls_given) AS maximum_calls

FROM placements

GROUP BY placement_status

ORDER BY total_students DESC;


/* Placement call distribution */

SELECT
    placement_calls_given,
    COUNT(DISTINCT student_id) AS total_students,

    ROUND(
        COUNT(DISTINCT student_id) * 100.0 /
        NULLIF((SELECT COUNT(DISTINCT student_id) FROM placements), 0),
        2
    ) AS student_share_pct

FROM placements

GROUP BY placement_calls_given

ORDER BY placement_calls_given;


/* ----------------------------------------------------------------------------
   6. COMPANY AND SALARY PACKAGE ANALYSIS

   Business question:
   Which companies recruit students, and what salary packages are recorded?

   Denominator:
   Placed students with a non-NULL salary package for salary averages.

   Only records with placement_status = 'Placed' are included.
   ---------------------------------------------------------------------------- */

SELECT
    company_name,

    COUNT(DISTINCT student_id) AS placed_students,

    ROUND(
        AVG(salary_package_lpa),
        2
    ) AS average_salary_lpa,

    ROUND(
        MIN(salary_package_lpa),
        2
    ) AS minimum_salary_lpa,

    ROUND(
        MAX(salary_package_lpa),
        2
    ) AS maximum_salary_lpa

FROM placements

WHERE LOWER(TRIM(placement_status)) = 'placed'
  AND company_name IS NOT NULL
  AND TRIM(company_name) <> ''

GROUP BY company_name

ORDER BY placed_students DESC, average_salary_lpa DESC;


/* Overall salary package statistics for placed students */

SELECT
    COUNT(DISTINCT student_id) AS placed_students_with_salary,

    ROUND(
        AVG(salary_package_lpa),
        2
    ) AS average_salary_lpa,

    ROUND(
        MIN(salary_package_lpa),
        2
    ) AS minimum_salary_lpa,

    ROUND(
        MAX(salary_package_lpa),
        2
    ) AS maximum_salary_lpa,

    ROUND(
        SUM(salary_package_lpa),
        2
    ) AS sum_of_recorded_salary_packages

FROM placements

WHERE LOWER(TRIM(placement_status)) = 'placed'
  AND salary_package_lpa IS NOT NULL;


/* ----------------------------------------------------------------------------
   7. BRANCH-WISE SALARY ANALYSIS

   Business question:
   How do average salary packages differ across branches?

   Denominator:
   Placed students with non-NULL salary packages in each branch.
   ---------------------------------------------------------------------------- */

SELECT
    b.branch_name,

    COUNT(DISTINCT CASE
        WHEN LOWER(TRIM(p.placement_status)) = 'placed'
             AND p.salary_package_lpa IS NOT NULL
        THEN s.student_id
    END) AS placed_students_with_salary,

    ROUND(
        AVG(CASE
            WHEN LOWER(TRIM(p.placement_status)) = 'placed'
            THEN p.salary_package_lpa
        END),
        2
    ) AS average_salary_lpa

FROM branches b

LEFT JOIN students s
    ON b.branch_id = s.branch_id

LEFT JOIN placements p
    ON s.student_id = p.student_id

GROUP BY
    b.branch_id,
    b.branch_name

ORDER BY average_salary_lpa DESC;


/* ----------------------------------------------------------------------------
   8. EMPLOYEE / COUNSELOR PLACEMENT PERFORMANCE

   Business question:
   How many placement calls are associated with each employee/counselor?

   Limitation:
   The placements table does not contain a recruiter or employee ID.
   Therefore, employee-level placement ownership cannot be established.

   The calls table contains counselor_id, allowing call activity analysis.
   This query measures call activity only, not successful placements.
   ---------------------------------------------------------------------------- */

SELECT
    e.emp_id,
    e.emp_name,
    e.department,
    b.branch_name,

    COUNT(c.call_id) AS total_recorded_calls,

    COUNT(DISTINCT c.student_id) AS students_contacted,

    ROUND(
        AVG(c.call_duration_min),
        2
    ) AS average_call_duration_min

FROM employees e

LEFT JOIN branches b
    ON e.branch_id = b.branch_id

LEFT JOIN calls c
    ON e.emp_id = c.counselor_id

GROUP BY
    e.emp_id,
    e.emp_name,
    e.department,
    b.branch_name

ORDER BY total_recorded_calls DESC;


/* ----------------------------------------------------------------------------
   9. PLACEMENT CALL CATEGORY ANALYSIS

   Business question:
   What types of placement-related calls are recorded?

   Denominator:
   All records in the calls table.
   ---------------------------------------------------------------------------- */

SELECT
    call_category,
    call_status,

    COUNT(*) AS total_calls,

    COUNT(DISTINCT student_id) AS students_contacted,

    ROUND(
        COUNT(*) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM calls), 0),
        2
    ) AS share_of_all_calls_pct

FROM calls

GROUP BY
    call_category,
    call_status

ORDER BY total_calls DESC;


/* ============================================================================
   END OF SCRIPT

   Reporting limitations:
   1. Total students is a proxy denominator, not a verified eligible-student
      denominator.
   2. Admission date is used for cohort analysis, not as a placement date.
   3. Placement calls do not prove placement success.
   4. Employee call activity does not prove recruiter placement ownership.
   5. Salary analysis includes placed students with recorded salary values.
   ============================================================================ */
