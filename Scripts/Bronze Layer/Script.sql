/********************************************************************************************
 SCRIPT NAME : BRONZE LAYER DDL & LOAD
 DESCRIPTION :
     CREATES BRONZE LAYER TABLES FOR CRM AND ERP SOURCE DATA
     AND LOADS DATA USING BULK INSERT.
********************************************************************************************/

------------------------------------------------------------
-- CRM TABLES
------------------------------------------------------------

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(100),
	prd_cost DECIMAL(10,2),
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt NVARCHAR(50),  
	sls_ship_dt NVARCHAR(50),   
	sls_due_dt NVARCHAR(50),     
	sls_sales NVARCHAR(50),      
	sls_quantity NVARCHAR(50),   
	sls_price NVARCHAR(50)       
);


------------------------------------------------------------
-- ERP TABLES
------------------------------------------------------------

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate NVARCHAR(50),
	gen NVARCHAR(10)
);


IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);


IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
);

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
	DECLARE 
		@start_time        DATETIME,
		@end_time          DATETIME,
		@batch_start_time  DATETIME,
		@batch_end_time    DATETIME;

	BEGIN TRY
		SET NOCOUNT ON;

		-- batch start
		SET @batch_start_time = GETDATE();

		PRINT 'Loading Bronze Layer';
		PRINT '======================================================================';
		PRINT 'Batch Start Time: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
		PRINT '';

		------------------------------------------------------------
		-- CRM TABLES
		------------------------------------------------------------

		PRINT 'Loading CRM Tables';
		PRINT '----------------------------------------------------------------------';

		-- crm_cust_info
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		SET NOCOUNT OFF;

		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Daniel\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET NOCOUNT ON;
		SET @end_time = GETDATE();

		PRINT ' >> Load Duration: ' 
			  + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
			  + ' seconds';
		PRINT ' >> -------------------------------------------------';
		PRINT '';

		-- crm_prd_info
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		SET NOCOUNT OFF;

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Daniel\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET NOCOUNT ON;
		SET @end_time = GETDATE();

		PRINT ' >> Load Duration: ' 
			  + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
			  + ' seconds';
		PRINT ' >> -------------------------------------------------';
		PRINT '';

		-- crm_sales_details
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		SET NOCOUNT OFF;

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Daniel\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET NOCOUNT ON;
		SET @end_time = GETDATE();

		PRINT ' >> Load Duration: ' 
			  + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
			  + ' seconds';
		PRINT ' >> -------------------------------------------------';
		PRINT '';

		PRINT 'CRM TABLES LOADED SUCCESSFULLY';
		PRINT '----------------------------------------------------------------------';

		------------------------------------------------------------
		-- ERP TABLES
		------------------------------------------------------------

		PRINT 'Loading ERP Tables';
		PRINT '----------------------------------------------------------------------';

		-- erp_cust_az12
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		SET NOCOUNT OFF;

		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Daniel\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET NOCOUNT ON;
		SET @end_time = GETDATE();

		PRINT ' >> Load Duration: ' 
			  + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
			  + ' seconds';
		PRINT ' >> -------------------------------------------------';
		PRINT '';

		-- erp_loc_a101
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		SET NOCOUNT OFF;

		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Daniel\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET NOCOUNT ON;
		SET @end_time = GETDATE();

		PRINT ' >> Load Duration: ' 
			  + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
			  + ' seconds';
		PRINT ' >> -------------------------------------------------';
		PRINT '';

		-- erp_px_cat_g1v2
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		SET NOCOUNT OFF;

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Daniel\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET NOCOUNT ON;
		SET @end_time = GETDATE();

		PRINT ' >> Load Duration: ' 
			  + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
			  + ' seconds';
		PRINT ' >> -------------------------------------------------';
		PRINT '';

		------------------------------------------------------------
		-- batch end
		------------------------------------------------------------

		SET @batch_end_time = GETDATE();

		PRINT '======================================================================';
		PRINT 'BRONZE LAYER LOADED SUCCESSFULLY';
		PRINT 'Batch End Time  : ' + CONVERT(NVARCHAR, @batch_end_time, 120);
		PRINT 'Total Duration  : ' 
			  + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
			  + ' seconds';
		PRINT '======================================================================';

	END TRY
	BEGIN CATCH
		PRINT '======================================================================';
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE : ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR LINE    : ' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT '======================================================================';

		THROW;
	END CATCH
END;
