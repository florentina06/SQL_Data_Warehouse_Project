# Data Catalog for Gold Layer

## Overview

The Gold Layer contains business-ready data organized into tables to support reporting and analysis. It includes dimension tables that describe customers and products, as well as a fact table that stores sales data.

---

## 1. gold.dim_customers

- **Purpose:** Stores customer information, including personal details and location.
- **Columns:**

| Column Name | Data Type | Description |
|---|---|---|
| customer_key | INT | Surrogate key used to identify each customer record in the dimension table. |
| customer_id | INT | Unique numeric ID assigned to each customer. |
| customer_number | NVARCHAR(50) | Customer code used for identification and tracking. |
| first_name | NVARCHAR(50) | Customer's first name. |
| last_name | NVARCHAR(50) | Customer's last name. |
| country | NVARCHAR(50) | Customer's country of residence (e.g., Australia). |
| marital_status | NVARCHAR(50) | Customer's marital status (e.g., Married, Single). |
| gender | NVARCHAR(50) | Customer's gender (e.g., Male, Female, n/a). |
| birthdate | DATE | Customer's date of birth, stored in YYYY-MM-DD format (e.g., 1971-10-06). |
| create_date | DATE | Date when the customer record was created in the system. |

---

## 2. gold.dim_products

- **Purpose:** Stores product information, including names, categories, and other attributes.
- **Columns:**

| Column Name | Data Type | Description |
|---|---|---|
| product_key | INT | Surrogate key used to identify each product record in the dimension table. |
| product_id | INT | Unique numeric ID assigned to each product. |
| product_number | NVARCHAR(50) | Product code used for identification and tracking. |
| product_name | NVARCHAR(50) | Product name, including details such as type, color, and size. |
| category_id | NVARCHAR(50) | Identifier used to link the product to its category. |
| category | NVARCHAR(50) | Main product category (e.g., Bikes, Components). |
| subcategory | NVARCHAR(50) | More specific classification within the main product category. |
| maintenance | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g., Yes, No). |
| cost | INT | Base cost of the product, expressed in monetary units. |
| product_line | NVARCHAR(50) | Product line the item belongs to (e.g., Road, Mountain). |
| start_date | DATE | Date when the product became available for sale or use. |

---

## 3. gold.fact_sales

- **Purpose:** Stores sales transaction data for reporting and analysis.
- **Columns:**

| Column Name | Data Type | Description |
|---|---|---|
| order_number | NVARCHAR(50) | Unique order number used to identify each sales order (e.g., SO54496). |
| product_key | INT | Key linking the sale to the corresponding product in the product dimension table. |
| customer_key | INT | Key linking the sale to the corresponding customer in the customer dimension table. |
| order_date | DATE | Date when the order was placed. |
| shipping_date | DATE | Date when the order was shipped to the customer. |
| due_date | DATE | Date when payment for the order was due. |
| sales_amount | INT | Total sales amount for the item, expressed in whole currency units (e.g., 25). |
| quantity | INT | Number of units ordered for the item (e.g., 1). |
| price | INT | Price per unit, expressed in whole currency units (e.g., 25). |
