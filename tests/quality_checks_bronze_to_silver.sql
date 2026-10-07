/*
===============================================================================
Data Exploration & Quality Checks (Bronze -> Silver)
===============================================================================
Script Purpose:
    This script contains the investigations performed on the 'bronze' schema
    BEFORE building the Silver layer load procedure (silver.load_silver).
    The findings from these checks define the cleansing and transformation
    rules applied in proc_load_silver.sql.
 
    Checks Performed:
        - Duplicates and NULLs in primary keys.
        - Unwanted leading/trailing spaces in text fields.
        - Data standardization and consistency (distinct values).
        - Invalid or out-of-range dates and invalid date orders.
        - Business rule validation (sales = quantity * price).
        - Key consistency between related tables.
 
Usage Notes:
    - Run each query individually (DBeaver: Ctrl+Enter), not the whole file.
===============================================================================
*/



-- =============================================================================
-- 1. crm_cust_info
-- =============================================================================
 
-- Check for NULLs or duplicates in the primary key
-- Expectation: No Results
SELECT 
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info cci 
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL 

-- Check for unwanted spaces
-- Expectation: No Results
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) 

-- Check data standardization and consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info



-- =============================================================================
-- 2. crm_prd_info
-- =============================================================================
 
-- Check for NULLs or duplicates in the primary key
-- Expectation: No Results
SELECT 
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info cpi  
GROUP BY prd_id 
HAVING COUNT(*) > 1 OR prd_id IS NULL 

-- Check for unwanted spaces
-- Expectation: No Results
SELECT prd_nm 
FROM bronze.crm_prd_info cpi  
WHERE prd_nm != TRIM(prd_nm) 

-- Check for NULLs or Negative Numbers
-- Expectation: No Results
SELECT prd_cost
FROM bronze.crm_prd_info cpi
WHERE prd_cost < 0 OR prd_cost IS NULL 

-- Check data standardization and consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info cpi

-- Check for invalid date orders (end date earlier than start date)
-- Expectation: No Results (found: end dates are unreliable)
SELECT * FROM bronze.crm_prd_info cpi
WHERE prd_end_dt < prd_start_dt

-- Test the fix: derive the end date from the next version's start date
-- End date = day before the next version starts; NULL for the latest version
-- Review these example products manually
SELECT  
	prd_id, prd_key, prd_nm, prd_start_dt, prd_end_dt,
	LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS prd_end_dt_test 
FROM bronze.crm_prd_info cpi
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')



-- =============================================================================
-- 3. crm_sales_details
-- =============================================================================

-- Check for unwanted spaces
-- Expectation: No Results
SELECT * FROM bronze.crm_sales_details csd 
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Check key integrity: every product in sales must exist in the product table
-- Expectation: No Results
SELECT * FROM bronze.crm_sales_details csd 
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info cpi)

-- Check key integrity: every customer in sales must exist in the customer table
-- Expectation: No Results
SELECT * FROM bronze.crm_sales_details csd 
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info )

-- Check for invalid dates
-- Dates are stored as integers in the format YYYYMMDD, so:
--   - zero or negative values cannot be cast to a date
--   - valid values must have exactly 8 digits and fall in a realistic range
-- Decision: replace zeros with NULL (the same logic applies to sls_ship_dt and sls_due_dt)
SELECT 
sls_order_dt,
NULLIF (sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details csd 
WHERE sls_order_dt <= 0 
	OR LENGTH(sls_order_dt::TEXT) != 8 
	OR sls_order_dt > 20500101
	OR sls_order_dt < 19000101

-- Check date order: the order date must be earlier than the ship and due dates
-- Expectation: No Results
SELECT * FROM bronze.crm_sales_details csd 
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check business rules
--   Rule: sales = quantity * price
--   Sales, quantity and price must not be negative, zero or NULL
--
--   Options for handling invalid data:
--     #1 Fix the issues directly in the source system
--     #2 Fix the issues in the data warehouse   <-- chosen here
--
--   Cleansing rules applied:
--     - If sales is negative, zero, NULL or does not match quantity * price, recalculate it as quantity * ABS(price)
--     - If price is negative, zero or NULL, derive it as sales / quantity
-- Expectation: No Results (found: several invalid rows)
SELECT DISTINCT 
	sls_sales,
	sls_quantity,
	sls_price	
FROM bronze.crm_sales_details csd 
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
	OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY 	sls_sales, sls_quantity, sls_price 

-- Test the cleansing logic (compare old vs. new values)
SELECT DISTINCT 
	sls_sales AS old_sls_sales,
	sls_quantity,
	sls_price	AS old_sls_price,
	CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0) 
		ELSE sls_price
	END AS sls_price	
FROM bronze.crm_sales_details csd 
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
	OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY 	sls_sales, sls_quantity, sls_price 



-- =============================================================================
-- 4. erp_cust_az12
-- =============================================================================

-- Check for NULLs or duplicates in the primary key
-- Expectation: No Results
SELECT 
	cid,
	COUNT(*)
FROM bronze.erp_cust_az12 eca 
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL 

-- Check birth dates: out of range or in the future
-- Decision: set future birth dates to NULL
SELECT 
	bdate
FROM bronze.erp_cust_az12 eca 
WHERE bdate < '1924-01-01' OR bdate > CURRENT_DATE

-- Check data standardization and consistency (old vs. normalized values)
SELECT DISTINCT gen,
	CASE 
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12 eca 



-- =============================================================================
-- 5. erp_loc_a101
-- =============================================================================

-- Check the key format
-- bronze.erp_loc_a101.cid contains a '-' (AW-00011000), while silver.crm_cust_info.cst_key does not (AW00011000).
-- Decision: remove the '-' so the tables can be joined
SELECT * FROM bronze.erp_loc_a101 ela 

-- Check data standardization and consistency (old vs. normalized values)
SELECT DISTINCT 
	cntry AS old_cntry,
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101
ORDER BY cntry



-- =============================================================================
-- 6. erp_px_cat_g1v2
-- =============================================================================

-- Check for unwanted spaces
-- Expectation: No Results
SELECT * FROM bronze.erp_px_cat_g1v2 epcgv 
WHERE subcat != TRIM(subcat) OR cat != TRIM(cat) OR maintenance != TRIM(maintenance)

-- Check data standardization and consistency
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2 epcgv 

SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2 epcgv 

SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2 epcgv
