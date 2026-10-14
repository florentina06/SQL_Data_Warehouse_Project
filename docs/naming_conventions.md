# Naming Conventions

This document defines the naming standards for tables, columns, and stored
procedures across the data warehouse. Following them keeps the project
consistent and easy to navigate.

---

## 1. Table Naming

### Bronze and Silver Layers

Tables in these layers keep the structure of the source data, so each name
combines the source system with the original table name. Source tables are
not renamed.

**Pattern:** `<source>_<table>`

- `<source>` – the system the data comes from (for example `crm` or `erp`)
- `<table>` – the table name exactly as it appears in the source

**Example:** `crm_customer_info` holds customer information from the CRM system.

### Gold Layer

Gold tables are built for analysis, so they use business-friendly names with a
prefix that shows the table's role.

**Pattern:** `<type>_<business_name>`

- `<type>` – the role of the table in the model (see the prefix list below)
- `<business_name>` – a clear name that reflects the business concept

**Examples:**
- `dim_customers` – dimension table with customer attributes
- `fact_sales` – fact table with sales transactions

### Table Prefixes

| Prefix    | Table type      | Examples                              |
|-----------|-----------------|---------------------------------------|
| `dim_`    | Dimension       | `dim_customers`, `dim_products`       |
| `fact_`   | Fact            | `fact_sales`                          |
| `report_` | Reporting view  | `report_customers`, `report_sales_monthly` |

---

## 2. Column Naming

### Surrogate Keys

The primary key of every dimension table is a surrogate key. Its name is the
entity name followed by `_key`.

**Pattern:** `<entity>_key`

**Example:** `customer_key` is the surrogate key of `dim_customers`.

### Technical (Metadata) Columns

Columns created by the warehouse itself, rather than coming from a source
system, start with `dwh_` followed by a description of what they store.

**Pattern:** `dwh_<description>`

**Example:** `dwh_create_date` records when a row was loaded into the warehouse.

---

## 3. Stored Procedures

Procedures that load data are named after the layer they populate.

**Pattern:** `load_<layer>`

**Examples:**
- `load_bronze` – loads data into the Bronze layer
- `load_silver` – loads data into the Silver layer
- `load_gold` – loads data into the Gold layer
