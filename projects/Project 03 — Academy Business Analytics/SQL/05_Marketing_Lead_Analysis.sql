
/* ============================================================================
   Project 03 - Education 360 Business Analytics
   File    : 05_Marketing_Lead_Analysis.sql
   Database: education_360_db (MySQL 8.0)

   Objectives:
     - Total leads.
     - Leads by marketing channel.
     - Lead status analysis.
     - Admission source analysis.
     - Campaign performance and marketing effectiveness.

   IMPORTANT DATA LIMITATION:
     - leads contains 2,000 individual lead records.
     - admissions contains 2,000 admission records.
     - marketing contains campaign-level aggregates:
       39,934 leads generated and 9,550 admissions converted.
     - No validated common person-level key connects leads to admissions.
     - Therefore, no lead-to-admission conversion rate is reported here.
     - Marketing campaign conversion is analyzed separately.

   All queries are SELECT-only.
   ============================================================================ */

USE education_360_db;


/* ----------------------------------------------------------------------------
   1. TOTAL LEADS AND LEAD STATUS

   Business question:
   How many individual leads are recorded, and what is their current status?

   Definition:
   Total leads = number of records in the leads table.
   Status distribution = count of leads in each lead_status category.

   No conversion rate is calculated in this section.
---------------------------------------------------------------------------- */

SELECT
    COUNT(*) AS total_lead_records,
    COUNT(DISTINCT lead_id) AS unique_lead_ids,
    COUNT(DISTINCT student_name) AS distinct_lead_names
FROM leads;


SELECT
    lead_status,
    COUNT(*) AS total_leads,
    ROUND(
        COUNT(*) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM leads), 0),
        2
    ) AS share_of_leads_pct
FROM leads
GROUP BY lead_status
ORDER BY total_leads DESC;


/* ----------------------------------------------------------------------------
   2. LEADS BY SOURCE

   Business question:
   Which channels generate the most individual leads?

   Denominator:
   Total records in the leads table.

   Share of leads =
   Leads from a source / Total leads * 100.

   This measures source distribution, not admission conversion.
---------------------------------------------------------------------------- */

SELECT
    lead_source,
    COUNT(*) AS total_leads,
    COUNT(DISTINCT lead_id) AS unique_leads,
    ROUND(
        COUNT(*) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM leads), 0),
        2
    ) AS lead_source_share_pct
FROM leads
GROUP BY lead_source
ORDER BY total_leads DESC;


/* ----------------------------------------------------------------------------
   3. LEAD STATUS BY SOURCE

   Business question:
   How are lead statuses distributed across different lead sources?

   Definition:
   Counts are grouped by lead_source and lead_status.

   This is a descriptive breakdown only.
   It does not establish that a lead became an admission.
---------------------------------------------------------------------------- */

SELECT
    lead_source,
    lead_status,
    COUNT(*) AS lead_count
FROM leads
GROUP BY
    lead_source,
    lead_status
ORDER BY
    lead_source,
    lead_count DESC;


/* ----------------------------------------------------------------------------
   4. ADMISSIONS BY SOURCE

   Business question:
   Which recorded admission sources contribute the most admissions?

   Denominator:
   Total records in the admissions table.

   Admission source contribution =
   Admissions from a source / Total admissions * 100.

   IMPORTANT:
   This is admission-source contribution, NOT lead conversion rate.
   No direct lead-to-admission matching is assumed.
---------------------------------------------------------------------------- */

SELECT
    lead_source,
    COUNT(*) AS total_admissions,
    COUNT(DISTINCT student_id) AS unique_admitted_students,
    ROUND(
        SUM(course_fee),
        2
    ) AS total_admission_revenue,
    ROUND(
        COUNT(*) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM admissions), 0),
        2
    ) AS admission_source_contribution_pct
FROM admissions
GROUP BY lead_source
ORDER BY total_admissions DESC;


/* ----------------------------------------------------------------------------
   5. CAMPAIGN PERFORMANCE

   Business question:
   Which marketing campaigns and platforms generate leads and admissions?

   Marketing table grain:
   Campaign-level aggregate records.

   Definitions:
   Calculated CPL = ad_spend / leads_generated.
   Calculated campaign conversion =
       admission_converted / leads_generated * 100.

   These metrics are calculated within the marketing table only.
   They must NOT be presented as conversion rates for the individual leads
   table or admissions table.
---------------------------------------------------------------------------- */

SELECT
    campaign_id,
    platform,
    campaign_month,
    ad_spend,
    leads_generated,
    admission_converted,

    ROUND(
        ad_spend / NULLIF(leads_generated, 0),
        2
    ) AS calculated_cost_per_lead,

    ROUND(
        admission_converted * 100.0 /
        NULLIF(leads_generated, 0),
        2
    ) AS calculated_campaign_conversion_pct,

    cost_per_lead AS recorded_cost_per_lead,
    conversion_rate AS recorded_conversion_rate

FROM marketing
ORDER BY ad_spend DESC;


/* ----------------------------------------------------------------------------
   6. MARKETING PLATFORM PERFORMANCE

   Business question:
   Which advertising platforms generate the most leads and admissions?

   Denominator:
   Platform-level campaign totals.

   Platform conversion =
   Total campaign admissions / Total campaign leads * 100.

   This is an aggregate marketing metric, not individual lead conversion.
---------------------------------------------------------------------------- */

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
    ) AS platform_cost_per_lead,

    ROUND(
        SUM(admission_converted) * 100.0 /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS platform_conversion_pct

FROM marketing
GROUP BY platform
ORDER BY total_admissions_converted DESC;


/* ----------------------------------------------------------------------------
   7. MONTHLY MARKETING PERFORMANCE

   Business question:
   How does marketing spending and campaign performance change over time?

   Denominator:
   Monthly campaign totals.

   Monthly conversion =
   Monthly admissions converted / Monthly leads generated * 100.

   This remains a campaign-level aggregate metric.
---------------------------------------------------------------------------- */

SELECT
    campaign_month,
    COUNT(*) AS campaign_count,
    ROUND(SUM(ad_spend), 2) AS total_ad_spend,
    SUM(leads_generated) AS total_leads_generated,
    SUM(admission_converted) AS total_admissions_converted,

    ROUND(
        SUM(ad_spend) /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS monthly_cost_per_lead,

    ROUND(
        SUM(admission_converted) * 100.0 /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS monthly_campaign_conversion_pct

FROM marketing
GROUP BY campaign_month
ORDER BY campaign_month;


/* ----------------------------------------------------------------------------
   8. OVERALL MARKETING EFFECTIVENESS

   Business question:
   What are the overall spending, lead-generation and admission-conversion
   results recorded in the marketing campaign dataset?

   Denominator:
   Total marketing leads generated (campaign-level aggregate).

   Conversion =
   Total marketing admissions converted / Total marketing leads generated
   * 100.

   This must be labelled Marketing Campaign Conversion Rate.
---------------------------------------------------------------------------- */

SELECT
    COUNT(*) AS total_campaign_records,
    ROUND(SUM(ad_spend), 2) AS total_marketing_spend,
    SUM(leads_generated) AS total_marketing_leads,
    SUM(admission_converted) AS total_marketing_admissions,

    ROUND(
        SUM(ad_spend) /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS overall_cost_per_lead,

    ROUND(
        SUM(admission_converted) * 100.0 /
        NULLIF(SUM(leads_generated), 0),
        2
    ) AS marketing_campaign_conversion_pct

FROM marketing;


/* ----------------------------------------------------------------------------
   9. MARKETING DATA QUALITY AND RECONCILIATION

   Business question:
   Are the campaign metrics internally consistent, and how do the different
   lead/admission datasets compare?

   IMPORTANT:
   The counts below are separate dataset totals.
   They are NOT joined or treated as matching individuals.
---------------------------------------------------------------------------- */

SELECT
    (SELECT COUNT(*) FROM leads) AS individual_lead_records,

    (SELECT COUNT(*) FROM admissions) AS admission_records,

    (SELECT SUM(leads_generated) FROM marketing)
        AS campaign_leads_generated,

    (SELECT SUM(admission_converted) FROM marketing)
        AS campaign_admissions_converted;


-- Check whether stored campaign CPL matches recalculated CPL.

SELECT
    campaign_id,
    platform,
    cost_per_lead AS stored_cpl,

    ROUND(
        ad_spend / NULLIF(leads_generated, 0),
        2
    ) AS calculated_cpl,

    ROUND(
        cost_per_lead -
        (ad_spend / NULLIF(leads_generated, 0)),
        2
    ) AS cpl_difference

FROM marketing
WHERE leads_generated > 0;


-- Check whether stored conversion rate matches recalculated conversion.

SELECT
    campaign_id,
    platform,
    conversion_rate AS stored_conversion_rate,

    ROUND(
        admission_converted * 100.0 /
        NULLIF(leads_generated, 0),
        2
    ) AS calculated_conversion_rate,

    ROUND(
        conversion_rate -
        (
            admission_converted * 100.0 /
            NULLIF(leads_generated, 0)
        ),
        2
    ) AS conversion_rate_difference

FROM marketing
WHERE leads_generated > 0;


/* ============================================================================
   END OF SCRIPT

   Reporting rules:
   1. Do not call marketing campaign conversion the individual lead conversion.
   2. Do not join leads to admissions using student_name or coincident IDs.
   3. Admission source contribution is not lead conversion.
   4. Resolve the data-grain and matching-key issue before publishing a
      person-level lead-to-admission conversion rate.
   ============================================================================ */
