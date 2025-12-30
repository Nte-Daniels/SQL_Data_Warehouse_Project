/********************************************************************************************
 QUALITY CHECKS – SILVER LAYER
 DESCRIPTION :
     This script performs data quality validation on all SILVER layer tables.
     It checks for:
       - NULL or duplicate primary keys
       - Unwanted spaces in string fields
       - Data standardization & consistency
       - Invalid or out-of-range values
       - Business rule violations

 USAGE NOTES :
     - Run AFTER Silver Layer load completes
     - Investigate and resolve any returned records
********************************************************************************************/


/* ==========================================================================================
   CUSTOMER DIMENSION : silver.crm_cust_info
========================================================================================== */

-- Check for NULLs or duplicate primary keys
SELECT
    cst_id,
    COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check for unwanted spaces in first name
SELECT
    cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);


-- Data standardization – Gender values
SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;


-- Data standardization – Marital status values
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;


/* ==========================================================================================
   PRODUCT DIMENSION : silver.crm_prd_info
========================================================================================== */

-- Check for NULLs or duplicate primary keys
SELECT
    prd_id,
    COUNT(*) AS record_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check for NULL or negative product cost
SELECT
    prd_id,
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;


-- Check for invalid date ranges
SELECT
    prd_id,
    prd_start_dt,
    prd_end_dt
FROM silver.crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_end_dt < prd_start_dt;


-- Data standardization – Product line
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;


/* ==========================================================================================
   SALES FACT : silver.crm_sales_details
========================================================================================== */

-- Business rule check: Sales = Quantity * Price
-- Values must not be NULL, zero, or negative
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE
    sls_sales IS NULL
    OR sls_quantity IS NULL
    OR sls_price IS NULL
    OR sls_sales <= 0
    OR sls_quantity <= 0
    OR sls_price <= 0
    OR sls_sales != sls_quantity * sls_price
ORDER BY sls_sales;


-- Check for invalid date order
SELECT
    sls_ord_num,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt
FROM silver.crm_sales_details
WHERE
    sls_ship_dt < sls_order_dt
    OR sls_due_dt < sls_order_dt;


/* ==========================================================================================
   ERP CUSTOMER : silver.erp_cust_az12
========================================================================================== */

-- Check for NULL primary keys
SELECT
    cid
FROM silver.erp_cust_az12
WHERE cid IS NULL;


-- Check for out-of-range birth dates
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();


-- Data standardization – Gender values
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;


/* ==========================================================================================
   ERP LOCATION : silver.erp_loc_a101
========================================================================================== */

-- Check for NULL customer IDs
SELECT
    cid
FROM silver.erp_loc_a101
WHERE cid IS NULL;


-- Data standardization – Country values
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- Check for unwanted spaces
SELECT *
FROM silver.erp_loc_a101
WHERE cntry != TRIM(cntry);


/* ==========================================================================================
   ERP PRODUCT CATEGORY : silver.erp_px_cat_g1v2
========================================================================================== */

-- Check for NULL IDs
SELECT
    id
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL;


-- Check for unwanted spaces
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);


-- Data standardization – Category values
SELECT DISTINCT
    cat
FROM silver.erp_px_cat_g1v2;


-- Data standardization – Subcategory values
SELECT DISTINCT
    subcat
FROM silver.erp_px_cat_g1v2;
