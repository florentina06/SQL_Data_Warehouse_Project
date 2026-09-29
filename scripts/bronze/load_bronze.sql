/*
===============================================================================
Load Data: Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This script loads data from external CSV files into the 'bronze' schema tables. For each table it:
      - Truncates the table (removes all existing rows);
      - Loads the data from the CSV file using the COPY command.

WARNING:
    Running this script deletes all existing data in the bronze tables and reloads it from the CSV files.

Usage:
    Run as a script (Alt+X) while connected to the DataWarehouse database.
===============================================================================
*/


TRUNCATE TABLE bronze.crm_cust_info

COPY bronze.crm_cust_info
FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_crm\cust_info.csv'
WITH (
	FORMAT CSV,
	HEADER true,
	DELIMITER ',' 
)



TRUNCATE TABLE bronze.crm_prd_info

COPY bronze.crm_prd_info
FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_crm\prd_info.csv'
WITH (
	FORMAT CSV,
	HEADER true,
	DELIMITER ',' 
)



TRUNCATE TABLE bronze.crm_sales_details

COPY bronze.crm_sales_details
FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_crm\sales_details.csv'
WITH (
	FORMAT CSV,
	HEADER true,
	DELIMITER ',' 
)



TRUNCATE TABLE bronze.erp_cust_az12

COPY bronze.erp_cust_az12
FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_erp\CUST_AZ12.csv'
WITH (
	FORMAT CSV,
	HEADER true,
	DELIMITER ',' 
)



TRUNCATE TABLE bronze.erp_loc_a101

COPY bronze.erp_loc_a101
FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_erp\LOC_A101.csv'
WITH (
	FORMAT CSV,
	HEADER true,
	DELIMITER ',' 
)



TRUNCATE TABLE bronze.erp_px_cat_g1v2

COPY bronze.erp_px_cat_g1v2
FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
	FORMAT CSV,
	HEADER true,
	DELIMITER ',' 
)







