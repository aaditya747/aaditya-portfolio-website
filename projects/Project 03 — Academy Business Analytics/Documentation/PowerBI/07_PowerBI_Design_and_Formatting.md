# 07 — Power BI Design and Formatting

Values come from the PBIX report layout. Screenshots: ⏳ PENDING — please supply one per page so the visual-quality observations can be confirmed.

## 1. Layout

| Property | Value |
|---|---|
| Canvas | 1500 × 1600 px, custom page size, identical on all pages |
| Banner | Full-width text box at the top (height ≈ 117–141 px) |
| KPI strip | Six cards in one row at y ≈ 143, each ≈ 240 × 153 px (x = 18, 258, 498, 738, 978, ≈1217) |
| Chart grid | Two columns (x ≈ 18 and ≈ 751–773), each chart ≈ 680 × 370 px; rows start at y ≈ 321 and ≈ 725–786 |
| Trend row | Page 1: line chart 897 px wide plus slicers at right; Pages 2–3: one full-width (1435 px) line chart at y ≈ 1142 |
| Page 4 | 2 × 3 grid of charts (trends, branch/course, donuts) |

## 2. Theme and colors

| Element | Value |
|---|---|
| Base theme | CY26SU05 |
| Page background shape | `#DFFFE0` (light green) full-canvas rectangle on every page |
| Recurring palette | `#D0EAD0`, `#8EE0A9`, `#499E40`, `#AEF181` (greens); `#FFFFFF` |
| Page-1 banner text color | `#3A2761` (dark purple) |
| Other colors seen once or twice | `#85E3B9`, `#BCDECF`, `#4B6956`, `#A7E4AC`, `#B5E9C2`, `#20DB8A`, `#CDDAE6` |

Overall style: light green, finance/growth-oriented palette with a purple accent for the main title.

## 3. Typography

| Element | Setting |
|---|---|
| Page banners | 36 pt bold; page 1 adds a 24 pt bold subtitle |
| Other text sizes in visuals | mainly 12, 15 and 16 pt; smaller 8–11 pt for secondary labels |
| Font family | No explicit family stored; theme default applies (⏳ confirm in Desktop) |

## 4. KPI card design

Every page uses six "card (new)" visuals of equal size in one aligned row, so the reader meets the headline metrics before any chart. Card colors/borders: ⏳ (confirm from screenshots).

## 5. Chart formatting and visual hierarchy

1. Banner → 2. KPI strip → 3. two-column comparison charts → 4. time-trend chart at the bottom.
Chart families are used consistently: line = trend, donut = composition, bar/column = comparison, treemap = distribution, funnel = stage drop-off.

## 6. Consistency and usability observations

| Observation | Impact | Suggested fix |
|---|---|---|
| Banner formatting differs: page 1 uses purple 36/24 pt; pages 2–4 list only 36 pt bold | Minor inconsistency | Apply one banner style |
| Page 2 pivot is titled "Total Revenue by Month" but shows counselors | Confusing | Rename (e.g. "Counselor Performance") |
| Page 3 clustered bar is titled "Lead Source Conversion" but shows placement rate by course | Misleading | Rename (e.g. "Placement Rate by Course") |
| Page 3 funnel is titled "Sales Funnel" (same as page 2) | Ambiguous | Rename (e.g. "Placement Funnel") |
| Page 4 "Course Revenue Contribution" plots remaining fees | Title vs. content mismatch | Rename or change measure |
| Page 1 bar chart (branch revenue) has no title | Accessibility | Add title |
| Slicers appear only on page 1 | Pages 2–4 cannot be filtered by course/branch | Add or sync slicers |
| Canvas is 1600 px tall | Requires scrolling on most screens | Consider tighter layout |
