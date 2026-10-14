# Sales Data Warehouse & Analytics

A portfolio project that builds a data warehouse in PostgreSQL and uses it to answer business questions about sales.

## Architecture

The warehouse is organized in three layers:

- **Bronze:** raw data loaded directly from the CSV files, unchanged.
- **Silver:** cleaned and standardized data.
- **Gold:** business-ready tables arranged in a star schema, used for reporting.

## What This Project Covers

- **ETL:** loading data from two source systems (CRM and ERP) and transforming it layer by layer.
- **Data modeling:** designing fact and dimension tables for analysis.
- **Analytics:** SQL queries on customer behavior, product performance and sales trends.

## Goals

1. Combine CRM and ERP data into a single, easy-to-query model.
2. Fix data quality problems before analysis.
3. Work with the latest data only (no history tracking).
4. Document the model so both business and technical users can understand it.

## Repository Structure

```
├── datasets/      # Source CSV files (CRM and ERP)
├── docs/          # Diagrams, data catalog and naming conventions
├── scripts/       # SQL scripts for the bronze, silver and gold layers
├── tests/         # Quality checks for the silver and gold layers
├── LICENSE
└── README.md
```

## Acknowledgements

Built while following the Data Warehouse course by Baraa Khatib Salkini (Data With Baraa), with my own changes and additions
