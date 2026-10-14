/*
===============================================================================
Gold Layer Quality Checks
===============================================================================
Purpose:
    This script runs a series of validation checks on the Gold Layer to confirm
    that the data is reliable, consistent, and ready for analytics. It verifies:
    - Surrogate keys in dimension tables are unique.
    - Fact tables correctly reference their dimension tables (referential integrity).
    - Relationships across the data model are valid and support analytical use.

Notes:
    - Any discrepancies returned by these checks should be investigated and
      resolved before the data is used downstream.
===============================================================================
*/



-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================

-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================

-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================

-- Check the data model connectivity between fact and dimensions
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL
