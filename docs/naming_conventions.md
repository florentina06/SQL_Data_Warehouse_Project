# Table Naming Conventions

## Bronze Rules
- Names start with the source system, followed by the original table name (no renaming).
- Pattern: `<sourcesystem>_<entity>`
  - `<sourcesystem>`: source system (e.g., `crm`, `erp`)
  - `<entity>`: table name exactly as in the source
- Example: `crm_customer_info` → customer data from the CRM system.

## Silver Rules
- Same approach as Bronze: source system prefix plus the original table name.
- Pattern: `<sourcesystem>_<entity>`
  - `<sourcesystem>`: source system (e.g., `crm`, `erp`)
  - `<entity>`: table name exactly as in the source
- Example: `crm_customer_info` → customer data from the CRM system.

## Gold Rules
- Names are business-friendly and begin with a category prefix.
- Pattern: `<category>_<entity>`
  - `<category>`: the table's role (e.g., `dim`, `fact`)
  - `<entity>`: descriptive name tied to the business domain (e.g., customers, products, sales)
- Examples:
  - `dim_customers` → dimension table for customers
  - `fact_sales` → fact table for sales transactions

### Category Prefixes

| Prefix    | Meaning         | Examples                              |
|-----------|-----------------|---------------------------------------|
| `dim_`    | Dimension table | `dim_customer`, `dim_product`         |
| `fact_`   | Fact table      | `fact_sales`                          |
| `report_` | Report table    | `report_customers`, `report_sales_monthly` |

---

# Column Naming Conventions

## Surrogate Keys
- Primary keys in dimension tables end with `_key`.
- Pattern: `<table_name>_key`
  - `<table_name>`: the entity the key belongs to
  - `_key`: marks the column as a surrogate key
- Example: `customer_key` → surrogate key of `dim_customers`.

## Technical Columns
- System-generated metadata columns start with `dwh_`.
- Pattern: `dwh_<column_name>`
  - `dwh`: reserved prefix for warehouse metadata
  - `<column_name>`: what the column is used for
- Example: `dwh_create_date` → date the record was loaded into the warehouse.

---

# Stored Procedures
- Loading procedures follow the pattern `load_<layer>`.
  - `<layer>`: the layer being loaded (`bronze`, `silver` or `gold`)
- Examples:
  - `load_bronze` → loads data into the Bronze layer
  - `load_silver` → loads data into the Silver layer
