# 04 — Dashboard Page Documentation

All visuals below were read from the PBIX report layout. Titles are reproduced exactly as stored (including leading/trailing spaces). "Business interpretation" explains how to read the visual; it does not state any result. Dashboard screenshots: ⏳ PENDING (please supply one image per page).

Fields are shown as `table[column]`; measures as **Measure** (host table in file 03). Aggregation applied to plain columns (for example a count of `placement id`) is ⏳ not readable.

---

## Page 1 — Executive Dashboard

**Purpose:** one-screen summary of revenue, admissions, students, outstanding fees, placement and lead conversion, with course/branch/platform slicers.
**Banner:** "360 EDUCATION BUSINESS ANALYTICS PLATFORM / Executive Overview Dashboard". **Visuals:** 6 cards, 5 charts, 3 slicers.

### KPI cards

| Card | Measure | Business interpretation |
|---|---|---|
| 1 | **Total Revenue** | Headline revenue for the current filter selection. |
| 2 | **total admissions** | Number of admissions in context. |
| 3 | **total students** | Student count in context. |
| 4 | **Total remaining fees** | Fees still to be collected. |
| 5 | **placement rate** | Share of students placed. |
| 6 | **Lead Conversion %** | Share of leads that convert to admissions. |

### Charts

| Visual type | Title | Fields | Measures | Purpose | Business interpretation |
|---|---|---|---|---|---|
| Line chart | Total Revenue by Month | DateTable[YearMonth] | **Total Revenue** | Revenue trend over time | Rising/falling months show seasonality of revenue. |
| Donut chart | Total admissions by course name | courses dim[course_name] | **total admissions** | Course mix of admissions | Larger slices = courses driving enrolment. |
| Bar chart | *(no title)* | branches dim[branch name] | **Total Revenue** | Branch comparison | Longest bars = highest-revenue branches. |
| Column chart | Student Count by Course and Placement Status | courses dim[course_name], placements[Placment success ], placements[placement id] | none (column aggregation ⏳) | Placement outcome by course | Compares placed vs. not-placed students within each course. |
| Line chart | Admission Trend by Month | DateTable[YearMonth] | **total admissions** | Admission momentum | Shows peaks and troughs in enrolment. |

### Slicers

| Slicer | Field | Style | Notes |
|---|---|---|---|
| 1 | courses dim[course_name] | Dropdown | "Select all" enabled; inverted-selection mode flag is on |
| 2 | branches dim[branch name] | Dropdown | "Select all" enabled |
| 3 | marketing[platform] | Dropdown | "Select all" enabled; effect on non-marketing visuals ⏳ (marketing has no shared key) |

### Business questions answered
How much revenue and how many admissions are we generating, and when? Which courses and branches lead? How much fee is outstanding? How do placement outcomes differ by course?

---

## Page 2 — Sales analysis

**Purpose:** lead, call and admission performance. **Banner:** "Sales & Admission Analytics". **Visuals:** 6 cards, 5 charts/tables.

### KPI cards

| Card | Measure | Business interpretation |
|---|---|---|
| 1 | **total leads** | Lead volume generated. |
| 2 | **converted leads** | Leads that reached "Converted". |
| 3 | **Lead Conversion %** | Conversion efficiency of the sales funnel. |
| 4 | **total calls** | Counselor call activity. |
| 5 | **effective call %** | Share of calls that are productive. |
| 6 | **Avg Revenue** | Average revenue per unit (definition ⏳). |

### Visuals

| Visual type | Title | Fields | Measures | Purpose | Business interpretation |
|---|---|---|---|---|---|
| Funnel | Sales Funnel | none | **converted leads**, **total leads**, **Placed Students**, **total students** | Stage-by-stage drop-off | Narrowing bars show attrition between lead, conversion, student and placed stages (stage order ⏳). |
| Clustered bar | Lead Source Conversion | leads[lead source] | **converted leads** | Compare sources | Longer bar = source producing more converted leads (absolute, not a rate). |
| Pivot table / matrix | Total Revenue by Month *(title does not match content)* | employees[emp name] | **total calls**, **Lead Conversion %**, **Total Revenue**, **total admissions** | Counselor scorecard | Compares each employee's calls, conversion, admissions and revenue. |
| Column chart | Branch Conversion Comparison | branches dim[branch name] | **converted leads**, **total leads** | Branch comparison | Gap between the two columns = leads not converted. |
| Line chart | Admission Trend by Month | DateTable[YearMonth] | **total admissions** | Admission trend (full width) | Same logic as page 1. |

### Business questions answered
Which sources and branches convert best? Which counselors combine high calls with high conversion/revenue? How do admissions move month to month?

---

## Page 3 — Placement Analytics

**Purpose:** placement outcomes and effort. **Banner:** "Placement Analytics". **Visuals:** 6 cards, 5 charts.

### KPI cards

| Card | Measure | Business interpretation |
|---|---|---|
| 1 | **Placed Students** | Count of placed students. |
| 2 | **placement rate** | Placed share of students. |
| 3 | **Average Salary (Placed)** | Average package of placed students (LPA unit in source column). |
| 4 | **Total placement call** | Total placement calls given. |
| 5 | **5 call students** | Students who received five placement calls (maximum value in data). |
| 6 | **Active Placement Students** | Students still in the placement process (definition ⏳). |

### Visuals

| Visual type | Title | Fields | Measures | Purpose | Business interpretation |
|---|---|---|---|---|---|
| Funnel | Sales Funnel *(title reused from page 2)* | none | **Active Placement Students**, **Placed Students**, **total admissions** | Admission-to-placement flow | Shows how many admitted students reach active placement and placed status. |
| Clustered bar | Lead Source Conversion *(title does not match content)* | courses dim[course_name] | **placement rate** | Placement rate by course | Higher bar = course with better placement outcomes. |
| Treemap | Company-wise Student Distribution | placements[company name] | **Placed Students** | Hiring-company mix | Larger tiles = companies hiring more students. |
| Column chart | Branch-wise Placement Performance | branches dim[branch name] | **Active Placement Students**, **Placed Students** | Branch comparison | Compares pipeline vs. outcomes per branch. |
| Line chart | Monthly Placement Trend | DateTable[YearMonth] | **Placed Students** | Placement over time | Month attribution method ⏳ (placements has no date column). |

**Calls and placement analysis:** no visual combines the calls table with placements. Call effort appears only through the **Total placement call** and **5 call students** cards (placement-table measures).

### Business questions answered
How many students are placed and at what salary? Which courses, branches and companies perform best? How much placement-call effort is applied?

---

## Page 4 — Financial Analytics

**Purpose:** fee collection and revenue. **Banner:** "Fees & Financial Analytics". **Visuals:** 6 cards, 6 charts.

### KPI cards

| Card | Measure | Business interpretation |
|---|---|---|
| 1 | **Total Revenue** | Total revenue in context. |
| 2 | **Total fees collected** | Cash actually received. |
| 3 | **Total remaining fees** | Outstanding balance. |
| 4 | **Collection Efficiency** | Collected relative to billed (definition ⏳). |
| 5 | **Avg course fees** | Average fee per course/admission. |
| 6 | **Pending Students (Text)** | Students with pending payments, text-formatted (definition ⏳). |

### Visuals

| Visual type | Title | Fields | Measures | Purpose | Business interpretation |
|---|---|---|---|---|---|
| Line chart | Monthly Revenue Trend | DateTable[YearMonth] | **Total Revenue** | Revenue over time | Seasonality and growth. |
| Line chart | Fee Collection Trend | DateTable[YearMonth] | **Total fees collected** | Collections over time | Compare with the revenue trend to spot collection lag. |
| Column chart | Branch Revenue Analysis | branches dim[branch name] | **Total Revenue** | Branch revenue | Highest columns = top-earning branches. |
| Bar chart | Course Revenue Contribution *(plots remaining fees)* | courses dim[course_name] | **Total remaining fees** | Outstanding fees by course | Longest bar = course with most unpaid fees (title suggests revenue; content is remaining fees). |
| Donut chart | Payment Status Breakdown | fees[payment status] | **Total fees collected** | Collected amount by status | Shows how collected money splits across Completed / Pending statuses. |
| Donut chart | Payment Mode Analysis | fees[payment mode], fees[paid fee] | none (column aggregation ⏳) | Preferred payment channels | Larger slices = more-used modes (Cash, Card, Net Banking, UPI). |

### Business questions answered
How much have we billed, collected and left outstanding? Which branches and courses carry the revenue and the unpaid balance? How do payment status and mode break down?
