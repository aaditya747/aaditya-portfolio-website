# DAX Measures Documentation
## Education 360° — Education Business Analytics

## 1. Overview

This document records the 25 DAX measures extracted from the original Power BI model using DAX Studio and the `INFO.MEASURES()` query. The formulas below preserve the expressions supplied in the DAX Studio results. Business definitions and behavior should be validated against the report and model relationships before final publication.

## 2. Revenue Measures

| Measure | DAX Formula |
|---|---|
| Total Revenue | `CALCULATE(SUM(admissions[course fee]), USERELATIONSHIP(admissions[counselor id], employees[emp id]))` |
| Total fees collected | `SUM(fees[paid fee])` |
| Total remaining fees | `SUM(fees[remaining fee])` |
| Avg Revenue | `AVERAGE(fees[total fee])` |
| pending students | `CALCULATE(COUNT(fees[student id]), fees[payment status] = "Pending")` |
| Avg course fees | `AVERAGE(admissions[course fee])` |
| Collection Efficiency | `DIVIDE(SUM(fees[paid fee]), SUM(fees[total fee])) * 100` |
| Pending Students (Text) | `FORMAT([pending students], "#,##0")` |

## 3. Placement Measures

| Measure | DAX Formula |
|---|---|
| Placed Students | `CALCULATE(COUNT(placements[student id]), placements[placement status] = "Placed")` |
| placement rate | `([Placed Students] / COUNT(placements[student id]) * 100)` |
| Active Placement Students | `CALCULATE(COUNT(placements[student id]), placements[placement status] = "Interview Running")` |
| Average Salary (Placed) | `CALCULATE(AVERAGE(placements[salary package lpa]), placements[placement status] = "Placed")` |
| Total placement call | `SUM(placements[placement calls given])` |
| 5 call students | `CALCULATE(COUNT(placements[placement id]), placements[placement calls given] = 5)` |

## 4. Call Measures

| Measure | DAX Formula |
|---|---|
| effective calls | `CALCULATE(COUNT(calls[call id]), calls[Call Category] = "Effective call")` |
| total calls | `COUNT(calls[call id])` |
| effective call % | `DIVIDE([effective calls], [total calls]) * 100` |

## 5. Marketing Measures

| Measure | DAX Formula |
|---|---|
| Total ad spend | `SUM(marketing[ad spend])` |
| Total marketing leads | `SUM(marketing[leads generated])` |
| Cost per lead | `DIVIDE([Total ad spend], [Total marketing leads])` |

## 6. Lead Measures

| Measure | DAX Formula |
|---|---|
| total leads | `COUNT(leads[lead id])` |
| converted leads | `CALCULATE(COUNT(leads[lead status]), leads[lead status] = "Converted")` |
| Lead Conversion % | `DIVIDE([converted leads], [total leads]) * 100` |

## 7. Student Measures

| Measure | DAX Formula |
|---|---|
| total students | `DISTINCTCOUNT('students dim'[student id])` |
| total admissions | `CALCULATE(DISTINCTCOUNT(admissions[admission id]), USERELATIONSHIP(admissions[counselor id], employees[emp id]))` |

## 8. Validation and Review Notes

The following measures require additional validation before being treated as final business KPIs:

1. **Total Revenue:** Confirm the intended relationship and filter behavior of `USERELATIONSHIP`.
2. **Collection Efficiency:** Check measure formatting to ensure the percentage is displayed correctly.
3. **Placement Rate:** Validate the denominator against the intended eligible student population.
4. **Pending Students:** Confirm whether counting payment records or distinct students is intended.
5. **Avg Revenue:** Confirm whether average total fee or average collected fee is the intended business definition.
6. **Lead Conversion:** Confirm that lead status is the correct conversion indicator and that the denominator represents all eligible leads.

These are validation questions, not confirmed errors. The formulas above are preserved as extracted.

## 9. Source and Methodology

- **Source:** Original Education 360° Power BI model.
- **Extraction tool:** DAX Studio 3.6.2.
- **Metadata query:** `INFO.MEASURES()`.
- **Extraction method:** DAX measure metadata.
- **Total extracted measures:** 25.
- **Measure groups:** 6.

**Note:** This document records the extracted formulas. Business definitions, formatting and relationship behavior must be validated against the actual report before final publication.
