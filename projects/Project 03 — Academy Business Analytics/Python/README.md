# Education 360° — Python Analysis

## Files
1. `01_Data_Inspection.ipynb` — load and inspect the 11 CSV files.
2. `02_Data_Quality_Validation.ipynb` — missing values, duplicates, candidate keys, dates, and orphan checks.
3. `03_Student_Admissions_Analysis.ipynb` — admissions by course, branch, and month.
4. `04_Marketing_Lead_Analysis.ipynb` — lead status, source conversion, branch performance, and campaign overview.
5. `05_Placement_Analytics.ipynb` — placement status, salary, companies, calls, course, and branch.
6. `06_Financial_Analytics.ipynb` — billed, collected, outstanding fees, payment mode and status.
7. `07_Advanced_Analytics.ipynb` — call effectiveness and counselor analysis.
8. `08_Business_Insights_Report.ipynb` — KPI snapshot and CSV export.
9. `requirements.txt` — Python dependencies.

## Expected project structure
```
Project_03_Education_360_Analysis/
├── Dataset/
│   ├── admissions.csv
│   ├── braches_dim.csv (or branches_dim.csv)
│   ├── calls.csv
│   ├── courses_dim.csv
│   ├── date_table.csv (or DateTable.csv)
│   ├── employees.csv
│   ├── fees.csv
│   ├── leads.csv
│   ├── marketing.csv
│   ├── placements.csv
│   └── students_dim.csv
└── Python/
    └── [these notebooks]
```

## Setup
From a terminal in the `Python` folder:
```bash
python -m pip install -r requirements.txt
```
Open the notebooks in VS Code and run them in order. The loader checks both known spellings of the branch and date CSV filenames.

## Important data notes
- Do not publish student names, email addresses, or phone numbers in a public repository. Anonymize or remove personal identifiers first.
- Do not join `leads` to `students dim` by student name: names are duplicated and no shared unique student ID is present in Leads.
- The Marketing table is at campaign/aggregate grain and has a different row count from the individual Leads table. Analyze separately unless a valid key/grain relationship is established.
- The 2025 date coverage is partial; avoid comparing it directly with full years without accounting for the partial period.
- These notebooks are analysis templates built from the documented table and column names. If a CSV column spelling differs, adjust the referenced column after checking the inspection notebook.
