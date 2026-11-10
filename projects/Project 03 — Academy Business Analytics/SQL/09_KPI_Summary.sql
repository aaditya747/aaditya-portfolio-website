
/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File    : 09_KPI_Summary.sql
   Database: education_360_db (MySQL 8.0)

   Objectives:
     - Student count.
     - Admissions.
     - Lead analysis.
     - Placement rate.
     - Total fee collection.
     - Outstanding fees.
     - Top-performing branches.
     - Top-performing courses.
     - Marketing performance.

   IMPORTANT KPI DEFINITIONS:
     - Student count: distinct student IDs.
     - Admissions: admission records.
     - Individual lead conversion: NOT CALCULATED because no validated
       person-level matching key exists between leads and admissions.
     - Placement rate: placed students / total students * 100.
       This is an overall recorded placement rate, not an eligible-student rate.
     - Collection efficiency: paid fees / billed fees * 100.
     - Marketing conversion: campaign admissions / campaign leads * 100.

   All queries are SELECT-only.
   ============================================================================ */

USE education_360_db;


/* ----------------------------------------------------------------------------
   1. STUDENT COUNT

   Business question:
   How many students are registered in the education business?

   Definition:
   Total students = COUNT(DISTINCT student_id).
---------------------------------------------------------------------------- */

SELECT
    COUNT(*) AS total_student_records,

    COUNT(DISTINCT student_id) AS total_unique_students,

    COUNT(DISTINCT branch_id) AS branches_with_students,

    COUNT(DISTINCT course_id) AS courses_with_students

FROM students;


/* ----------------------------------------------------------------------------
   2. ADMISSIONS

   Business question:
   How many admissions have been recorded, and what is their total billed
   course fee value?

   Definition:
   Total admissions = COUNT(admission_id).
   Admission revenue = SUM(course_fee).

   Admission revenue represents billed course fees, not collected cash.
---------------------------------------------------------------------------- */

SELECT
    COUNT(admission_id) AS total_admissions,

    COUNT(DISTINCT student_id) AS unique_admitted_students,

    ROUND(SUM(course_fee), 2) AS total_admission_billed_revenue,

    ROUND(AVG(course_fee), 2) AS average_admission_fee

FROM admissions;


/* Admissions by year */

SELECT
    admission_year,

    COUNT(admission_id) AS total_admissions,

    COUNT(DISTINCT student_id) AS unique_admitted_students,

    ROUND(SUM(course_fee), 2) AS total_billed_revenue

FROM admissions

GROUP BY admission_year

ORDER BY admission_year;


/* ----------------------------------------------------------------------------
   3. LEAD ANALYSIS

   Business question:
   How many individual leads are recorded, and what is their status?

   Definition:
   Total leads = COUNT(DISTINCT lead_id).

   IMPORTANT:
   A person-level lead conversion rate cannot be reliably calculated because
   there is no validated matching key between leads and admissions.

   The status distribution below is descriptive, not admission conversion.
---------------------------------------------------------------------------- */

SELECT
    COUNT(*) AS total_lead_records,

    COUNT(DISTINCT lead_id) AS total_unique_leads,

    COUNT(DISTINCT student_name) AS distinct_lead_names

FROM leads;


/* Lead status distribution */

SELECT
    lead_status,

    COUNT(*) AS total_leads,

    ROUND(
        COUNT(*) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM leads), 0),
        2
    ) AS lead_status_share_pct

FROM leads

GROUP BY lead_status

ORDER BY total_leads DESC;


/* ----------------------------------------------------------------------------
   4. OVERALL RECORDED PLACEMENT RATE

   Business question:
   What percentage of all recorded students have been placed?

   Numerator:
   Distinct students with placement_status = 'Placed'.

   Denominator:
   Total distinct students in the students table.

   Formula:
   Placed students / Total students * 100.

   Limitation:
   This is not an official eligible-student placement rate because the
   dataset does not identify a separate eligible-student population.
---------------------------------------------------------------------------- */

SELECT
    COUNT(DISTINCT s.student_id) AS total_students,

    COUNT(DISTINCT CASE
        WHEN LOWER(TRIM(p.placement_status)) = 'placed'
        THEN s.student_id
    END) AS total_placed_students,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN LOWER(TRIM(p.placement_status)) = 'placed'
            THEN s.student_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT s.student_id), 0),
        2
    ) AS overall_recorded_placement_rate_pct

FROM students s

LEFT JOIN placements p
    ON s.student_id = p.student_id;


/* ----------------------------------------------------------------------------
   5. TOTAL FEE COLLECTION

   Business question:
   How much money has been billed and collected?

   Definitions:
   Billed fees = SUM(total_fee).
   Collected fees = SUM(paid_fee).
   Collection efficiency = paid fees / billed fees * 100.

   Denominator:
   Total billed fees.
---------------------------------------------------------------------------- */

SELECT
    COUNT(*) AS total_fee_records,

    ROUND(SUM(total_fee), 2) AS total_billed_fees,

    ROUND(SUM(paid_fee), 2) AS total_fees_collected,

    ROUND(
        SUM(paid_fee) * 100.0 /
        NULLIF(SUM(total_fee), 0),
        2
    ) AS collection_efficiency_pct

FROM fees;


/* ----------------------------------------------------------------------------
   6. OUTSTANDING FEES

   Business question:
   How much billed fee revenue is still outstanding?

   Definition:
   Outstanding fees = SUM(remaining_fee).

   Denominator:
   Total billed fees.

   Outstanding percentage = remaining fees / total billed fees * 100.
---------------------------------------------------------------------------- */

SELECT
    ROUND(SUM(total_fee), 2) AS total_billed_fees,

    ROUND(SUM(paid_fee), 2) AS total_fees_collected,

    ROUND(SUM(remaining_fee), 2) AS total_outstanding_fees,

    ROUND(
        SUM(remaining_fee) * 100.0 /
        NULLIF(SUM(total_fee), 0),
        2
    ) AS outstanding_fees_pct

FROM fees;


/* Students with pending fee balances */

SELECT
    COUNT(*) AS pending_fee_records,

    COUNT(DISTINCT student_id) AS students_with_pending_fees,

    ROUND(SUM(remaining_fee), 2) AS total_pending_amount

FROM fees

WHERE remaining_fee > 0;


/* ----------------------------------------------------------------------------
   7. TOP-PERFORMING BRANCHES

   Business question:
   Which branches perform best in terms of student count, placements
   and fee collection?

   Definitions:
   Placement rate = placed students / branch students * 100.
   Collection = SUM(paid_fee).

   Branches are ranked primarily by placement rate.
   Student counts are displayed to provide context.
---------------------------------------------------------------------------- */

WITH branch_performance AS
(
    SELECT
        b.branch_id,
        b.branch_name,

        COUNT(DISTINCT s.student_id) AS total_students,

        COUNT(DISTINCT CASE
            WHEN LOWER(TRIM(p.placement_status)) = 'placed'
            THEN s.student_id
        END) AS placed_students,

        ROUND(SUM(f.paid_fee), 2) AS total_fees_collected,

        ROUND(SUM(f.remaining_fee), 2) AS outstanding_fees

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

    total_fees_collected,
    outstanding_fees,

    RANK() OVER (
        ORDER BY
            placed_students * 100.0 /
            NULLIF(total_students, 0) DESC
    ) AS branch_performance_rank

FROM branch_performance

ORDER BY branch_performance_rank;


/* ----------------------------------------------------------------------------
   8. TOP-PERFORMING COURSES

   Business question:
   Which courses have the highest student enrolment, placement count
   and fee collection?

   Definitions:
   Course placement rate = placed students / course students * 100.
   Course collection = SUM(paid_fee).

   Courses are ranked primarily by collected fees.
---------------------------------------------------------------------------- */

WITH course_performance AS
(
    SELECT
        c.course_id,
        c.course_name,

        COUNT(DISTINCT s.student_id) AS total_students,

        COUNT(DISTINCT CASE
            WHEN LOWER(TRIM(p.placement_status)) = 'placed'
            THEN s.student_id
        END) AS placed_students,

        ROUND(SUM(f.paid_fee), 2) AS total_fees_collected,

        ROUND(SUM(f.remaining_fee), 2) AS outstanding_fees

    FROM courses c

    LEFT JOIN students s
        ON c.course_id = s.course_id

    LEFT JOIN placements p
        ON s.student_id = p.student_id

    LEFT JOIN fees f
        ON s.student_id = f.student_id

    GROUP BY
        c.course_id,
        c.course_name
)

SELECT
    course_id,
    course_name,
    total_students,
    placed_students,

    ROUND(
        placed_students * 100.0 /
        NULLIF(total_students, 0),
        2
    ) AS course_placement_rate_pct,

    total_fees_collected,
    outstanding_fees,

    RANK() OVER (
        ORDER BY total_fees_collected DESC
    ) AS course_revenue_rank

FROM course_performance

ORDER BY course_revenue_rank;


/* ----------------------------------------------------------------------------
   9. MARKETING PERFORMANCE

   Business question:
   How effective are marketing campaigns in generating leads and admissions?

   Definitions:
   Campaign leads = SUM(leads_generated).
   Campaign admissions = SUM(admission_converted).
   Marketing conversion =
       Campaign admissions / Campaign leads * 100.
   Cost per lead = Total ad spend / Campaign leads.

   IMPORTANT:
   This is an aggregate marketing campaign conversion rate.
   It is not individual lead-to-admission conversion.
---------------------------------------------------------------------------- */

SELECT
    COUNT(*) AS total_campaign_records,

    ROUND(SUM(ad_spend), 2) AS total_marketing_spend,

    SUM(leads_generated) AS total_campaign_leads,

    SUM(admission_converted) AS total_campaign_admissions,

    ROUND(
        SUM(ad_spend) /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS marketing_cost_per_lead,

    ROUND(
        SUM(admission_converted) * 100.0 /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS marketing_campaign_conversion_pct

FROM marketing;


/* Platform-wise marketing performance */

SELECT
    platform,

    COUNT(*) AS campaign_count,

    ROUND(SUM(ad_spend), 2) AS total_ad_spend,

    SUM(leads_generated) AS total_leads_generated,

    SUM(admission_converted) AS total_admissions_converted,

    ROUND(
        SUM(ad_spend) /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS cost_per_lead,

    ROUND(
        SUM(admission_converted) * 100.0 /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS campaign_conversion_pct

FROM marketing

GROUP BY platform

ORDER BY total_admissions_converted DESC;


/* ============================================================================
   10. FINAL KPI REFERENCE SUMMARY

   Business question:
   What are the key education business KPIs in one result?

   Notes:
   - Each KPI is calculated independently from its correct source table.
   - Individual lead conversion is intentionally excluded.
   - Marketing campaign conversion is separately labelled.
   - Placement rate uses all students as a proxy denominator.
   ============================================================================ */

SELECT
    'Total Students' AS kpi_name,
    COUNT(DISTINCT student_id) AS kpi_value
FROM students

UNION ALL

SELECT
    'Total Admissions',
    COUNT(admission_id)
FROM admissions

UNION ALL

SELECT
    'Total Individual Leads',
    COUNT(DISTINCT lead_id)
FROM leads

UNION ALL

SELECT
    'Placed Students',
    COUNT(DISTINCT student_id)
FROM placements
WHERE LOWER(TRIM(placement_status)) = 'placed'

UNION ALL

SELECT
    'Total Billed Fees',
    ROUND(SUM(total_fee), 2)
FROM fees

UNION ALL

SELECT
    'Total Fees Collected',
    ROUND(SUM(paid_fee), 2)
FROM fees

UNION ALL

SELECT
    'Outstanding Fees',
    ROUND(SUM(remaining_fee), 2)
FROM fees

UNION ALL

SELECT
    'Total Marketing Spend',
    ROUND(SUM(ad_spend), 2)
FROM marketing

UNION ALL

SELECT
    'Marketing Leads Generated',
    SUM(leads_generated)
FROM marketing

UNION ALL

SELECT
    'Marketing Admissions Converted',
    SUM(admission_converted)
FROM marketing;


/* ============================================================================
   END OF SCRIPT

   KPI reporting rules:
   1. Do not report individual lead conversion without a validated matching key.
   2. Do not confuse campaign conversion with individual lead conversion.
   3. Use all students as the placement-rate denominator only with the
      "overall recorded placement rate" label.
   4. Keep billed fees, collected fees and outstanding fees separate.
   5. Marketing metrics represent campaign-level aggregate performance.
   ============================================================================ */
