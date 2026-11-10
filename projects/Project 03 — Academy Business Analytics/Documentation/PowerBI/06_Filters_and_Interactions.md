# 06 — Filters and Interactions

Only features found in the PBIX report layout are listed. Items that could not be checked are marked ⏳.

## 1. Filters

| Filter level | Finding | Status |
|---|---|---|
| Report-level filters | None found | ✅ |
| Page-level filters | None found on any of the 4 pages | ✅ |
| Visual-level filters | None found on any visual | ✅ |

Consequence: every number on the dashboard responds only to slicers and cross-filtering (and to any filters written inside DAX measures ⏳).

## 2. Slicers

Slicers exist **only on page 1 (Executive Dashboard)**. Pages 2–4 contain no slicers.

| Page | Slicer field | Style | Select-all option | Notes |
|---|---|---|---|---|
| Executive Dashboard | courses dim[course_name] | Dropdown | On | Inverted-selection mode flag is stored as true |
| Executive Dashboard | branches dim[branch name] | Dropdown | On | — |
| Executive Dashboard | marketing[platform] | Dropdown | On | Effect on non-marketing visuals ⏳ |

⏳ Whether these slicers are synced to pages 2–4 (Sync slicers pane) could not be confirmed.

## 3. Cross-filtering and cross-highlighting

| Item | Finding | Status |
|---|---|---|
| Default behaviour | All visuals have the "filter other visuals" drill setting enabled, so selecting a bar/slice/point is intended to cross-filter the others on that page | ✅ |
| Custom "Edit interactions" overrides | Not checked | ⏳ |

## 4. Drill-through, tooltips and other interactions

| Feature | Finding | Status |
|---|---|---|
| Drill-through pages | None detected (all four pages are standard visible pages) | ✅ |
| Custom tooltip pages | None detected; the report setting "enhanced tooltips" is on, so default tooltips show field values | ✅ |
| Buttons / page-navigation visuals | None among the visuals (only cards, charts, slicers, text boxes, shapes) | ✅ |
| Bookmarks | Not checked | ⏳ |
| Hierarchy drill-down on charts | Charts use a single axis field (e.g. YearMonth); no hierarchy was found | ✅ |
| Data export | An export-data setting is stored in the report (mode value 1); exact meaning to confirm in Desktop | ⏳ |
| Filter pane | New filter-pane experience enabled; changing filter types allowed | ✅ |

## 5. User interactions (how to use)

1. Pick a course, branch or marketing platform from the Executive page dropdowns.
2. Click a chart element (for example a branch bar) to cross-filter the other visuals on that page.
3. Hover any visual for the default tooltip; click the same element again to clear the selection.
4. Navigate between pages using the page tabs (no custom navigation buttons exist).
