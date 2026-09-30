	/*
	===============================================================================
	Stored Procedure: Load Bronze Layer (Source -> Bronze)
	===============================================================================
	Purpose:
    	This procedure loads data into the 'bronze' schema from external CSV files.
	    It performs the following actions:
	      - TRUNCATES the table, removing all existing rows
	      - LOADS the data from the CSV file using the COPY command

	Monitoring:
    - Prints progress messages using RAISE NOTICE
    - Measures and prints the load duration for each individual table
    - Measures and prints the total duration of the entire bronze layer load

	Error Handling:
    - The EXCEPTION block catches any error that occurs during loading
    - It prints the error message (SQLERRM) and the error code (SQLSTATE)

	WARNING:
    Running this procedure deletes all existing data in the bronze tables
    and reloads it from the CSV files.
	===============================================================================
	*/
	
	

-- 1. Create the procedure
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$

DECLARE
	start_time       TIMESTAMP;
	end_time         TIMESTAMP;
	batch_start_time TIMESTAMP;
	batch_end_time   TIMESTAMP;

BEGIN
		batch_start_time := clock_timestamp();

		RAISE NOTICE '========================================================';
		RAISE NOTICE 'Loading Bronze Layer';
		RAISE NOTICE '========================================================';
	
		RAISE NOTICE '--------------------------------------------------------';
		RAISE NOTICE 'Loading CRM Tables';
		RAISE NOTICE '--------------------------------------------------------';
	
	
		start_time := clock_timestamp();
		RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
	
		RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
		COPY bronze.crm_cust_info
		FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_crm\cust_info.csv'
		WITH (
			FORMAT CSV,
			HEADER true,
			DELIMITER ','
		);

		end_time := clock_timestamp();
		RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
		RAISE NOTICE '>> ---------------------';

	
		
		start_time := clock_timestamp();
		RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
	
		RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
		COPY bronze.crm_prd_info
		FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_crm\prd_info.csv'
		WITH (
			FORMAT CSV,
			HEADER true,
			DELIMITER ','
		);

		end_time := clock_timestamp();
		RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
		RAISE NOTICE '>> ---------------------';

	
	
		start_time := clock_timestamp();
		RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
	
		RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
		COPY bronze.crm_sales_details
		FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_crm\sales_details.csv'
		WITH (
			FORMAT CSV,
			HEADER true,
			DELIMITER ','
		);

		end_time := clock_timestamp();
		RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
		RAISE NOTICE '>> ---------------------';
	
		

		RAISE NOTICE '--------------------------------------------------------';
		RAISE NOTICE 'Loading ERP Tables';
		RAISE NOTICE '--------------------------------------------------------';
	
	

		start_time := clock_timestamp();
		RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
	
		RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
		COPY bronze.erp_cust_az12
		FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FORMAT CSV,
			HEADER true,
			DELIMITER ','
		);

		end_time := clock_timestamp();
		RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
		RAISE NOTICE '>> ---------------------';
	

	
		start_time := clock_timestamp();
		RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
	
		RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
		COPY bronze.erp_loc_a101
		FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_erp\LOC_A101.csv'
		WITH (
			FORMAT CSV,
			HEADER true,
			DELIMITER ','
		);

		end_time := clock_timestamp();
		RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
		RAISE NOTICE '>> ---------------------';


	
		start_time := clock_timestamp();
		RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	
		RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		COPY bronze.erp_px_cat_g1v2
		FROM 'E:\Studii\02. IT\ProiectSQL\Suport proiect\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FORMAT CSV,
			HEADER true,
			DELIMITER ','
		);

		end_time := clock_timestamp();
		RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
		RAISE NOTICE '>> ---------------------';


		batch_end_time := clock_timestamp();
		RAISE NOTICE '========================================================';
		RAISE NOTICE 'Loading Bronze Layer is Completed';
		RAISE NOTICE 'Total Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
		RAISE NOTICE '========================================================';



	EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE '========================================================';
		RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
		RAISE NOTICE 'Error Message: %', SQLERRM;
		RAISE NOTICE 'Error Code: %', SQLSTATE;
		RAISE NOTICE '========================================================';

END;
$$;


-- 2. Run the procedure
CALL bronze.load_bronze();


-- 3. Check the rows
SELECT 'crm_cust_info' AS tables, COUNT(*) AS row FROM bronze.crm_cust_info
UNION ALL
SELECT 'crm_prd_info', COUNT(*) FROM bronze.crm_prd_info
UNION ALL
SELECT 'crm_sales_details', COUNT(*) FROM bronze.crm_sales_details
UNION ALL
SELECT 'erp_cust_az12', COUNT(*) FROM bronze.erp_cust_az12
UNION ALL
SELECT 'erp_loc_a101', COUNT(*) FROM bronze.erp_loc_a101
UNION ALL
SELECT 'erp_px_cat_g1v2', COUNT(*) FROM bronze.erp_px_cat_g1v2;



