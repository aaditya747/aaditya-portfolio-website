
/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File    : 08_Advanced_Business_Analysis.sql
   Database: education_360_db (MySQL 8.0)

   Objectives:
     - INNER, LEFT and RIGHT JOIN
     - GROUP BY, HAVING and CASE WHEN
     - Subqueries and CTEs
     - RANK, DENSE_RANK and ROW_NUMBER
     - LAG and LEAD
     - Month-over-month comparisons
     - Running totals

   DATA LIMITATIONS:
     - Financial monthly trends use student admission_date, not payment date.
     - Placement cohort trends use admission_date, not placement date.
     - Leads and admissions have no validated person-level matching key.
     - Marketing is campaign-level aggregate data.

   All queries are SELECT-only.
   ============================================================================ */

USE education_360_db;


/* ----------------------------------------------------------------------------
   1. JOIN PATTERNS ACROSS FACT AND DIMENSION TABLES

   Business question:
   How do students, branches, courses and fee records relate?

   Denominator:
   Counts use distinct student IDs to avoid duplication from joins.
---------------------------------------------------------------------------- */


/* 1A. INNER JOIN
   Returns students who have matching branch and course records. */

SELECT
    s.student_id,
    s.student_name,
    s.gender,
    s.city,
    b.branch_name,
    c.course_name,
    s.admission_date

FROM students s

INNER JOIN branches b
    ON s.branch_id = b.branch_id

INNER JOIN courses c
    ON s.course_id = c.course_id

ORDER BY s.student_id

LIMIT 20;


/* 1B. LEFT JOIN
   Keeps all students, including those without a matching fee record. */

SELECT
    COUNT(DISTINCT s.student_id) AS total_students,

    COUNT(DISTINCT f.student_id) AS students_with_fee_records,

    COUNT(DISTINCT CASE
        WHEN f.student_id IS NULL THEN s.student_id
    END) AS students_without_fee_records

FROM students s

LEFT JOIN fees f
    ON s.student_id = f.student_id;


/* 1C. RIGHT JOIN
   Keeps all branches, including branches without matching students. */

SELECT
    b.branch_id,
    b.branch_name,
    COUNT(DISTINCT s.student_id) AS total_students

FROM students s

RIGHT JOIN branches b
    ON s.branch_id = b.branch_id

GROUP BY
    b.branch_id,
    b.branch_name

ORDER BY total_students DESC;


/* 1D. Multi-table business join
   Student, branch, course, placement and fee analysis. */

SELECT
    b.branch_name,
    c.course_name,

    COUNT(DISTINCT s.student_id) AS total_students,

    COUNT(DISTINCT CASE
        WHEN LOWER(TRIM(p.placement_status)) = 'placed'
        THEN s.student_id
    END) AS placed_students,

    ROUND(SUM(f.paid_fee), 2) AS total_fees_collected,

    ROUND(SUM(f.remaining_fee), 2) AS outstanding_fees

FROM students s

LEFT JOIN branches b
    ON s.branch_id = b.branch_id

LEFT JOIN courses c
    ON s.course_id = c.course_id

LEFT JOIN placements p
    ON s.student_id = p.student_id

LEFT JOIN fees f
    ON s.student_id = f.student_id

GROUP BY
    b.branch_name,
    c.course_name

ORDER BY total_fees_collected DESC;


/* ----------------------------------------------------------------------------
   2. HAVING AND CASE WHEN SEGMENTATION

   Business question:
   Which branches and courses perform above selected analytical thresholds?

   Definitions:
   - HAVING filters aggregated results.
   - CASE creates descriptive business segments.
   - Thresholds below are analytical examples, not official targets.
---------------------------------------------------------------------------- */


/* 2A. HAVING: branches with at least 300 students. */

SELECT
    b.branch_name,
    COUNT(DISTINCT s.student_id) AS total_students

FROM branches b

INNER JOIN students s
    ON b.branch_id = s.branch_id

GROUP BY
    b.branch_id,
    b.branch_name

HAVING COUNT(DISTINCT s.student_id) >= 300

ORDER BY total_students DESC;


/* 2B. CASE: branch placement performance segmentation. */

SELECT
    branch_name,
    total_students,
    placed_students,
    placement_rate_pct,

    CASE
        WHEN placement_rate_pct >= 40 THEN 'High Placement'
        WHEN placement_rate_pct >= 30 THEN 'Moderate Placement'
        ELSE 'Needs Improvement'
    END AS placement_performance_segment

FROM
(
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
            END) * 100.0 /
            NULLIF(COUNT(DISTINCT s.student_id), 0),
            2
        ) AS placement_rate_pct

    FROM branches b

    LEFT JOIN students s
        ON b.branch_id = s.branch_id

    LEFT JOIN placements p
        ON s.student_id = p.student_id

    GROUP BY
        b.branch_id,
        b.branch_name
) AS branch_performance

ORDER BY placement_rate_pct DESC;


/* 2C. CASE: fee collection segmentation. */

SELECT
    student_id,
    total_fee,
    paid_fee,
    remaining_fee,

    CASE
        WHEN remaining_fee = 0 THEN 'Fully Paid'
        WHEN paid_fee = 0 THEN 'No Payment'
        WHEN remaining_fee < total_fee THEN 'Partially Paid'
        ELSE 'Review Required'
    END AS collection_segment

FROM fees

ORDER BY remaining_fee DESC;


/* ----------------------------------------------------------------------------
   3. SUBQUERIES

   Business question:
   Which courses, students and branches perform above overall averages?
---------------------------------------------------------------------------- */


/* 3A. Courses with above-average course fees. */

SELECT
    course_id,
    course_name,
    course_fee

FROM courses

WHERE course_fee >
(
    SELECT AVG(course_fee)
    FROM courses
)

ORDER BY course_fee DESC;


/* 3B. Students with outstanding fees above the average outstanding balance. */

SELECT
    student_id,
    total_fee,
    paid_fee,
    remaining_fee

FROM fees

WHERE remaining_fee >
(
    SELECT AVG(remaining_fee)
    FROM fees
)

ORDER BY remaining_fee DESC;


/* 3C. Branches with more students than the average branch student count. */

SELECT
    b.branch_name,
    COUNT(DISTINCT s.student_id) AS total_students

FROM branches b

INNER JOIN students s
    ON b.branch_id = s.branch_id

GROUP BY
    b.branch_id,
    b.branch_name

HAVING COUNT(DISTINCT s.student_id) >
(
    SELECT AVG(branch_student_count)
    FROM
    (
        SELECT
            COUNT(DISTINCT student_id) AS branch_student_count
        FROM students
        GROUP BY branch_id
    ) AS branch_counts
)

ORDER BY total_students DESC;


/* ----------------------------------------------------------------------------
   4. COMMON TABLE EXPRESSIONS (CTEs)

   Business question:
   Can we create readable intermediate datasets for business analysis?
---------------------------------------------------------------------------- */


/* 4A. CTE: branch-wise placement and collection summary. */

WITH branch_summary AS
(
    SELECT
        b.branch_id,
        b.branch_name,

        COUNT(DISTINCT s.student_id) AS total_students,

        COUNT(DISTINCT CASE
            WHEN LOWER(TRIM(p.placement_status)) = 'placed'
            THEN s.student_id
        END) AS placed_students,

        ROUND(SUM(f.paid_fee), 2) AS fees_collected

    FROM branches b

    LEFT JOIN students s
        ON b.branch_id = s.branch_id

    LEFT JOIN placements p
        ON s.student_id = p.student_id

    LEFT JOIN fees f
        ON s.student_id = f.student_id

    GROUP BY
        b.branch_id,
        b.branch_name
)

SELECT
    branch_id,
    branch_name,
    total_students,
    placed_students,

    ROUND(
        placed_students * 100.0 /
        NULLIF(total_students, 0),
        2
    ) AS placement_rate_pct,

    fees_collected

FROM branch_summary

ORDER BY placement_rate_pct DESC;


/* 4B. CTE: student fee collection segmentation. */

WITH fee_summary AS
(
    SELECT
        student_id,
        total_fee,
        paid_fee,
        remaining_fee,

        CASE
            WHEN remaining_fee = 0 THEN 'Fully Paid'
            WHEN paid_fee = 0 THEN 'No Payment'
            ELSE 'Partially Paid'
        END AS payment_segment

    FROM fees
)

SELECT
    payment_segment,

    COUNT(*) AS total_fee_records,

    ROUND(SUM(total_fee), 2) AS billed_fees,

    ROUND(SUM(paid_fee), 2) AS collected_fees,

    ROUND(SUM(remaining_fee), 2) AS outstanding_fees

FROM fee_summary

GROUP BY payment_segment

ORDER BY outstanding_fees DESC;


/* 4C. CTE: monthly admission-cohort financial analysis.

   Date used: students.admission_date.
   This is not a payment-month collection report.
*/

WITH monthly_finance AS
(
    SELECT
        DATE_FORMAT(s.admission_date, '%Y-%m') AS admission_month,

        SUM(f.total_fee) AS billed_fees,

        SUM(f.paid_fee) AS collected_fees,

        SUM(f.remaining_fee) AS outstanding_fees

    FROM students s

    INNER JOIN fees f
        ON s.student_id = f.student_id

    WHERE s.admission_date IS NOT NULL

    GROUP BY DATE_FORMAT(s.admission_date, '%Y-%m')
)

SELECT
    admission_month,

    ROUND(billed_fees, 2) AS billed_fees,

    ROUND(collected_fees, 2) AS collected_fees,

    ROUND(outstanding_fees, 2) AS outstanding_fees

FROM monthly_finance

ORDER BY admission_month;


/* ----------------------------------------------------------------------------
   5. RANK, DENSE_RANK AND ROW_NUMBER

   Business question:
   How do branches rank by placement performance and companies rank by salary?

   Denominator:
   Branch placement rate uses total students within each branch.
---------------------------------------------------------------------------- */


/* 5A. RANK: branches by placement rate. */

WITH branch_placement AS
(
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
            END) * 100.0 /
            NULLIF(COUNT(DISTINCT s.student_id), 0),
            2
        ) AS placement_rate_pct

    FROM branches b

    LEFT JOIN students s
        ON b.branch_id = s.branch_id

    LEFT JOIN placements p
        ON s.student_id = p.student_id

    GROUP BY
        b.branch_id,
        b.branch_name
)

SELECT
    branch_name,
    total_students,
    placed_students,
    placement_rate_pct,

    RANK() OVER (
        ORDER BY placement_rate_pct DESC
    ) AS branch_rank,

    DENSE_RANK() OVER (
        ORDER BY placement_rate_pct DESC
    ) AS dense_branch_rank,

    ROW_NUMBER() OVER (
        ORDER BY placement_rate_pct DESC, branch_name
    ) AS row_number_rank

FROM branch_placement;


/* 5B. DENSE_RANK: companies by average salary package. */

WITH company_salary AS
(
    SELECT
        company_name,

        COUNT(DISTINCT student_id) AS placed_students,

        ROUND(AVG(salary_package_lpa), 2) AS average_salary_lpa

    FROM placements

    WHERE LOWER(TRIM(placement_status)) = 'placed'
      AND company_name IS NOT NULL
      AND TRIM(company_name) <> ''
      AND salary_package_lpa IS NOT NULL

    GROUP BY company_name
)

SELECT
    company_name,
    placed_students,
    average_salary_lpa,

    DENSE_RANK() OVER (
        ORDER BY average_salary_lpa DESC
    ) AS salary_rank

FROM company_salary

ORDER BY salary_rank, company_name;


/* 5C. ROW_NUMBER: top 3 highest salary records per company. */

WITH company_student_salary AS
(
    SELECT
        company_name,
        student_id,
        salary_package_lpa,

        ROW_NUMBER() OVER (
            PARTITION BY company_name
            ORDER BY salary_package_lpa DESC, student_id
        ) AS salary_row_number

    FROM placements

    WHERE LOWER(TRIM(placement_status)) = 'placed'
      AND company_name IS NOT NULL
      AND TRIM(company_name) <> ''
      AND salary_package_lpa IS NOT NULL
)

SELECT
    company_name,
    student_id,
    salary_package_lpa,
    salary_row_number

FROM company_student_salary

WHERE salary_row_number <= 3

ORDER BY company_name, salary_row_number;


/* ----------------------------------------------------------------------------
   6. LAG / LEAD MONTH-OVER-MONTH

   Business question:
   How does admission-cohort fee collection change from one month to another?

   Date used:
   students.admission_date.

   Denominator:
   Previous month's collected fees for percentage change.

   IMPORTANT:
   This is a cohort-based collection comparison, not actual payment-month
   revenue growth.
---------------------------------------------------------------------------- */

WITH monthly_collection AS
(
    SELECT
        DATE_FORMAT(s.admission_date, '%Y-%m') AS admission_month,

        SUM(f.paid_fee) AS collected_fees

    FROM students s

    INNER JOIN fees f
        ON s.student_id = f.student_id

    WHERE s.admission_date IS NOT NULL

    GROUP BY DATE_FORMAT(s.admission_date, '%Y-%m')
),

monthly_comparison AS
(
    SELECT
        admission_month,
        collected_fees,

        LAG(collected_fees) OVER (
            ORDER BY admission_month
        ) AS previous_month_collection,

        LEAD(collected_fees) OVER (
            ORDER BY admission_month
        ) AS next_month_collection

    FROM monthly_collection
)

SELECT
    admission_month,

    ROUND(collected_fees, 2) AS collected_fees,

    ROUND(previous_month_collection, 2)
        AS previous_month_collection,

    ROUND(next_month_collection, 2)
        AS next_month_collection,

    ROUND(
        collected_fees - previous_month_collection,
        2
    ) AS month_over_month_change,

    ROUND(
        (collected_fees - previous_month_collection) * 100.0 /
        NULLIF(previous_month_collection, 0),
        2
    ) AS month_over_month_growth_pct

FROM monthly_comparison

ORDER BY admission_month;


/* ----------------------------------------------------------------------------
   7. RUNNING TOTALS

   Business question:
   How do billed fees and collected fees accumulate across admission cohorts?

   Date used:
   students.admission_date.

   Definition:
   Running total = cumulative sum of monthly cohort values in date order.

   This is not a cash-receipt running total.
---------------------------------------------------------------------------- */

WITH monthly_finance AS
(
    SELECT
        DATE_FORMAT(s.admission_date, '%Y-%m') AS admission_month,

        SUM(f.total_fee) AS billed_fees,

        SUM(f.paid_fee) AS collected_fees

    FROM students s

    INNER JOIN fees f
        ON s.student_id = f.student_id

    WHERE s.admission_date IS NOT NULL

    GROUP BY DATE_FORMAT(s.admission_date, '%Y-%m')
)

SELECT
    admission_month,

    ROUND(billed_fees, 2) AS monthly_billed_fees,

    ROUND(collected_fees, 2) AS monthly_collected_fees,

    ROUND(
        SUM(billed_fees) OVER (
            ORDER BY admission_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_billed_fees,

    ROUND(
        SUM(collected_fees) OVER (
            ORDER BY admission_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_collected_fees

FROM monthly_finance

ORDER BY admission_month;


/* ============================================================================
   END OF SCRIPT

   Advanced SQL concepts demonstrated:
     1. INNER JOIN
     2. LEFT JOIN
     3. RIGHT JOIN
     4. GROUP BY and HAVING
     5. CASE WHEN
     6. Scalar and derived-table subqueries
     7. Common Table Expressions
     8. RANK
     9. DENSE_RANK
    10. ROW_NUMBER
    11. LAG and LEAD
    12. Running totals with window functions

   Data limitations are documented alongside the relevant analyses.
   ============================================================================ */
