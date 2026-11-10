
/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File    : 07_Financial_Analytics.sql
   Database: education_360_db (MySQL 8.0)

   Objectives:
     - Total fees billed.
     - Total fees collected.
     - Outstanding fees.
     - Collection by course.
     - Collection by branch.
     - Monthly admission-cohort collection trends.
     - Payment status distribution.
     - Payment mode analysis.

   IMPORTANT DEFINITIONS:
     - Billed fees       = SUM(total_fee)
     - Collected revenue = SUM(paid_fee)
     - Outstanding fees = SUM(remaining_fee)
     - Collection rate   = Collected revenue / Billed fees * 100

   IMPORTANT DATA LIMITATION:
     - The fees table has no payment date.
     - Monthly analysis uses students.admission_date.
     - Therefore, monthly results represent admission-cohort fee collections,
       NOT actual monthly cash receipts.

   All queries are SELECT-only.
   ============================================================================ */

USE education_360_db;


/* ----------------------------------------------------------------------------
   1. BILLED VS COLLECTED VS OUTSTANDING

   Business question:
   How much revenue has been billed, collected and remains outstanding?

   Denominator:
   Total billed fees.

   Collection rate = Total paid_fee / Total total_fee * 100.
   Outstanding rate = Total remaining_fee / Total total_fee * 100.
---------------------------------------------------------------------------- */

SELECT
    COUNT(*) AS total_fee_records,

    COUNT(DISTINCT student_id) AS total_students_with_fee_records,

    ROUND(SUM(total_fee), 2) AS total_billed_fees,

    ROUND(SUM(paid_fee), 2) AS total_fees_collected,

    ROUND(SUM(remaining_fee), 2) AS total_outstanding_fees,

    ROUND(
        SUM(paid_fee) * 100.0 /
        NULLIF(SUM(total_fee), 0),
        2
    ) AS collection_efficiency_pct,

    ROUND(
        SUM(remaining_fee) * 100.0 /
        NULLIF(SUM(total_fee), 0),
        2
    ) AS outstanding_fees_pct

FROM fees;


/* ----------------------------------------------------------------------------
   2. COLLECTION BY COURSE

   Business question:
   Which courses generate the highest billed fees and collected revenue?

   Denominator:
   Total billed fees within each course.

   Course collection rate =
   Course paid fees / Course billed fees * 100.

   Fee records are linked to students to identify their course.
---------------------------------------------------------------------------- */

SELECT
    c.course_id,
    c.course_name,

    COUNT(DISTINCT s.student_id) AS total_students,

    ROUND(SUM(f.total_fee), 2) AS total_billed_fees,

    ROUND(SUM(f.paid_fee), 2) AS total_collected_fees,

    ROUND(SUM(f.remaining_fee), 2) AS total_outstanding_fees,

    ROUND(
        SUM(f.paid_fee) * 100.0 /
        NULLIF(SUM(f.total_fee), 0),
        2
    ) AS course_collection_rate_pct,

    ROUND(
        SUM(f.total_fee) * 100.0 /
        NULLIF((SELECT SUM(total_fee) FROM fees), 0),
        2
    ) AS share_of_total_billed_fees_pct

FROM courses c

LEFT JOIN students s
    ON c.course_id = s.course_id

LEFT JOIN fees f
    ON s.student_id = f.student_id

GROUP BY
    c.course_id,
    c.course_name

ORDER BY total_collected_fees DESC;


/* ----------------------------------------------------------------------------
   3. COLLECTION BY BRANCH

   Business question:
   Which branches contribute the most billed fees and collected revenue?

   Denominator:
   Total billed fees within each branch.

   Branch collection rate =
   Branch paid fees / Branch billed fees * 100.
---------------------------------------------------------------------------- */

SELECT
    b.branch_id,
    b.branch_name,

    COUNT(DISTINCT s.student_id) AS total_students,

    ROUND(SUM(f.total_fee), 2) AS total_billed_fees,

    ROUND(SUM(f.paid_fee), 2) AS total_collected_fees,

    ROUND(SUM(f.remaining_fee), 2) AS total_outstanding_fees,

    ROUND(
        SUM(f.paid_fee) * 100.0 /
        NULLIF(SUM(f.total_fee), 0),
        2
    ) AS branch_collection_rate_pct

FROM branches b

LEFT JOIN students s
    ON b.branch_id = s.branch_id

LEFT JOIN fees f
    ON s.student_id = f.student_id

GROUP BY
    b.branch_id,
    b.branch_name

ORDER BY total_collected_fees DESC;


/* ----------------------------------------------------------------------------
   4. MONTHLY COLLECTION TREND BY ADMISSION DATE

   Business question:
   How do billed fees, collected fees and outstanding fees vary by
   student admission month?

   Date used:
   students.admission_date.

   Denominator:
   Total billed fees within each admission month.

   IMPORTANT:
   This is an admission-cohort collection analysis.
   It is NOT a payment-month or cash-receipt trend because fees has no
   payment date.
---------------------------------------------------------------------------- */

SELECT
    YEAR(s.admission_date) AS admission_year,

    MONTH(s.admission_date) AS admission_month,

    DATE_FORMAT(s.admission_date, '%Y-%m') AS admission_period,

    COUNT(DISTINCT s.student_id) AS total_students,

    ROUND(SUM(f.total_fee), 2) AS total_billed_fees,

    ROUND(SUM(f.paid_fee), 2) AS total_collected_fees,

    ROUND(SUM(f.remaining_fee), 2) AS total_outstanding_fees,

    ROUND(
        SUM(f.paid_fee) * 100.0 /
        NULLIF(SUM(f.total_fee), 0),
        2
    ) AS cohort_collection_rate_pct

FROM students s

INNER JOIN fees f
    ON s.student_id = f.student_id

WHERE s.admission_date IS NOT NULL

GROUP BY
    YEAR(s.admission_date),
    MONTH(s.admission_date),
    DATE_FORMAT(s.admission_date, '%Y-%m')

ORDER BY
    admission_year,
    admission_month;


/* ----------------------------------------------------------------------------
   5. PAYMENT STATUS DISTRIBUTION

   Business question:
   How are fee records distributed across payment statuses?

   Denominator:
   Total fee records.

   Payment status share =
   Fee records in a status / Total fee records * 100.

   The percentages represent record distribution, not revenue distribution.
---------------------------------------------------------------------------- */

SELECT
    payment_status,

    COUNT(*) AS total_fee_records,

    COUNT(DISTINCT student_id) AS unique_students,

    ROUND(
        COUNT(*) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM fees), 0),
        2
    ) AS payment_status_share_pct,

    ROUND(SUM(total_fee), 2) AS total_billed_fees,

    ROUND(SUM(paid_fee), 2) AS total_collected_fees,

    ROUND(SUM(remaining_fee), 2) AS total_outstanding_fees

FROM fees

GROUP BY payment_status

ORDER BY total_fee_records DESC;


/* ----------------------------------------------------------------------------
   6. PAYMENT MODE ANALYSIS

   Business question:
   Which payment modes contribute the most collected revenue?

   Denominator:
   Total collected fees across all payment modes.

   Payment mode contribution =
   Paid fees for a mode / Total paid fees * 100.
---------------------------------------------------------------------------- */

SELECT
    payment_mode,

    COUNT(*) AS total_transactions,

    COUNT(DISTINCT student_id) AS unique_students,

    ROUND(SUM(total_fee), 2) AS total_billed_fees,

    ROUND(SUM(paid_fee), 2) AS total_collected_fees,

    ROUND(SUM(remaining_fee), 2) AS total_outstanding_fees,

    ROUND(
        SUM(paid_fee) * 100.0 /
        NULLIF((SELECT SUM(paid_fee) FROM fees), 0),
        2
    ) AS collected_revenue_contribution_pct

FROM fees

GROUP BY payment_mode

ORDER BY total_collected_fees DESC;


/* ----------------------------------------------------------------------------
   7. OUTSTANDING FEES ANALYSIS

   Business question:
   Which students have the highest outstanding fee balances?

   Definition:
   Outstanding fees = remaining_fee.

   Only records with a positive outstanding balance are included.
---------------------------------------------------------------------------- */

SELECT
    s.student_id,
    s.student_name,
    b.branch_name,
    c.course_name,

    f.total_fee,
    f.paid_fee,
    f.remaining_fee,
    f.payment_status,
    f.payment_mode,

    ROUND(
        f.remaining_fee * 100.0 /
        NULLIF(f.total_fee, 0),
        2
    ) AS outstanding_percentage

FROM fees f

INNER JOIN students s
    ON f.student_id = s.student_id

LEFT JOIN branches b
    ON s.branch_id = b.branch_id

LEFT JOIN courses c
    ON s.course_id = c.course_id

WHERE f.remaining_fee > 0

ORDER BY f.remaining_fee DESC

LIMIT 20;


/* ----------------------------------------------------------------------------
   8. FINANCIAL RECONCILIATION

   Business question:
   Do billed, collected and outstanding fees reconcile?

   Expected relationship:
   Total billed fees = Total collected fees + Total outstanding fees.

   Difference should be zero, subject to rounding.
---------------------------------------------------------------------------- */

SELECT
    ROUND(SUM(total_fee), 2) AS total_billed_fees,

    ROUND(SUM(paid_fee), 2) AS total_collected_fees,

    ROUND(SUM(remaining_fee), 2) AS total_outstanding_fees,

    ROUND(
        SUM(total_fee) -
        SUM(paid_fee) -
        SUM(remaining_fee),
        2
    ) AS reconciliation_difference

FROM fees;


/* ----------------------------------------------------------------------------
   9. COLLECTION PERFORMANCE BY PAYMENT STATUS AND BRANCH

   Business question:
   How does payment status vary across branches?

   Denominator:
   Total fee records within each branch.

   Status share =
   Fee records for a status / Total fee records in that branch * 100.
---------------------------------------------------------------------------- */

SELECT
    b.branch_name,
    f.payment_status,

    COUNT(*) AS total_fee_records,

    ROUND(SUM(f.paid_fee), 2) AS total_collected_fees,

    ROUND(SUM(f.remaining_fee), 2) AS total_outstanding_fees,

    ROUND(
        COUNT(*) * 100.0 /
        NULLIF(
            (
                SELECT COUNT(*)
                FROM fees f2
                INNER JOIN students s2
                    ON f2.student_id = s2.student_id
                WHERE s2.branch_id = b.branch_id
            ),
            0
        ),
        2
    ) AS branch_payment_status_share_pct

FROM fees f

INNER JOIN students s
    ON f.student_id = s.student_id

INNER JOIN branches b
    ON s.branch_id = b.branch_id

GROUP BY
    b.branch_id,
    b.branch_name,
    f.payment_status

ORDER BY
    b.branch_name,
    total_fee_records DESC;


/* ============================================================================
   END OF SCRIPT

   Reporting limitations:
   1. Billed fees and collected revenue are different financial measures.
   2. Outstanding fees are based on remaining_fee.
   3. Monthly collection is grouped by admission date, not payment date.
   4. Payment status percentages represent fee-record counts.
   5. Payment mode contribution is calculated using collected revenue.
   ============================================================================ */
