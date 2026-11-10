# 05 — KPI and Measures Guide

> DAX formulas could not be read from the PBIX (see file 03). KPI names, pages and source columns are verified; **formulas are ⏳ PENDING** and must be validated before publishing. "Reference value" columns are computed directly from the CSVs and are what a simple aggregate *should* return with no filters applied; they have **not** been reconciled to the PBIX cards.

| KPI | Definition (business) | DAX formula | Source columns | Dashboard page(s) | Reference value from CSV |
|---|---|---|---|---|---|
| Total Revenue | Revenue earned in context | ⏳ | fees / admissions | Executive, Financial | ⏳ definition unknown (billed total = 66,065,000 if based on total fee) |
| Total fees collected | Money received from students | ⏳ | fees[paid fee] | Financial | 52,491,750 (sum of paid fee) |
| Total remaining fees | Outstanding balance | ⏳ | fees[remaining fee] | Executive, Financial | 13,573,250 (sum of remaining fee) |
| Collection Efficiency | Collected relative to billed | ⏳ | fees[paid fee], fees[total fee] | Financial | 79.45% if paid ÷ total |
| Avg course fees | Average course fee | ⏳ | admissions[course fee] / courses dim[course_fee] | Financial | 33,032.50 if average of admissions[course fee] |
| Avg Revenue | Average revenue | ⏳ | ⏳ | Sales | ⏳ |
| Pending Students (Text) | Students with pending payments | ⏳ | fees[payment status] | Financial | 1,465 rows with status Pending |
| total admissions | Admissions made | ⏳ | admissions[admission id] | Executive, Sales, Placement | 2,000 |
| total students | Students enrolled | ⏳ | students dim[student id] | Executive, Sales | 2,000 |
| total leads | Leads generated | ⏳ | leads[lead id] | Sales | 2,000 |
| converted leads | Leads with status Converted | ⏳ | leads[lead status] | Sales | 638 |
| Lead Conversion % | Converted ÷ total leads | ⏳ | leads | Executive, Sales | 31.90% if converted ÷ total |
| total calls | Calls made | ⏳ | calls[call id] | Sales | 18,226 |
| effective call % | Effective calls ÷ calls | ⏳ | calls[Call Category] | Sales | 39.34% if Effective ÷ total (7,170 / 18,226) |
| Placed Students | Students placed | ⏳ | placements[placement status] | Sales, Placement | 697 |
| placement rate | Placed ÷ students | ⏳ | placements | Executive, Placement | 34.85% if 697 ÷ 2,000 |
| Average Salary (Placed) | Mean package of placed students | ⏳ | placements[salary package lpa] | Placement | 5.24 LPA (mean over the 697 Placed rows) |
| Total placement call | Placement calls given | ⏳ | placements[placement calls given] | Placement | 6,075 (sum of placement calls given) |
| 5 call students | Students with 5 placement calls | ⏳ | placements[placement calls given] | Placement | 414 |
| Active Placement Students | Students in placement process | ⏳ | placements[placement status] | Placement | ⏳ (Searching 665 + Interview Running 638 = 1,303 if that is the definition) |

**How to finish this file:** paste each DAX formula, then compare the card on each page (with no slicers selected) with the reference column; record any difference in file 08.
