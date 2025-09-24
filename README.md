# NYC MTA Ridership Analysis

A fully reproducible data pipeline and Power BI dashboard to analyze daily ridership trends across New York City’s MTA systems. The project covers data ingestion, transformation, testing, analysis, and visualization using dbt, DuckDB, Python, and Power BI.

# Tech Stack

- dbt (with DuckDB as the engine)  
- Python (pandas, matplotlib, seaborn, duckdb)  
- Power BI (for final dashboard)  
- Git (version control)

# Project Structure

```
NYC MTA Ridership Analysis/
├── data_raw/               # Original CSV file from Maven Analytics
├── dbt_nyc_mta_ridership/  # dbt project (staging, marts, tests)
├── notebooks/              # Cleaning, analysis, and export
│   └── see_data.ipynb
├── reports/                # Power BI .pbix and screenshots
├── scr/                    # cleaning and test
├── requirements.txt        # Python dependencies
├── dev-requirements.txt    # Python dependencies
├── .gitignore              # Excludes .duckdb, target/, checkpoints, etc.
├── README.md               # This file
├── dev.duckdb              # DuckDB database file
└── makefile                # Automation commands (env, clean, dbt, docs)
```
