-- Data Quality Check and Exploration

SELECT
	cst_id,
	COUNT(*)
FROM
		silver.crm_cust_info
GROUP BY
	cst_id
HAVING
	COUNT(*) > 1 OR cst_id IS NULL


	-- Check for unwanted Spaces
SELECT
	cst_firstname
FROM
	silver.crm_cust_info
WHERE
	cst_firstname != TRIM(cst_firstname)


-- DATA standardization & Consistency

SELECT DISTINCT cst_gndr
FROM
	silver.crm_cust_info


SELECT * FROM silver.crm_cust_info



-- Checking for Nulls and duplicates in the primary key


SELECT
	prd_id,
	COUNT(*)
FROM		
	bronze.crm_prd_info
GROUP BY
	prd_id
HAVING
	COUNT(*) > 1 OR prd_id IS NULL


SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info;


-- CHECK for NULLs or Negative Numbers

SELECT prd_cost
FROM
	bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL



-- sales quality check
-- sales = Quantity * Price
-- Values must not be NULL, zero, or negative


SELECT DISTINCT
    sls_sales AS old_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price
FROM silver.crm_sales_details
WHERE 
    TRY_CAST(sls_sales AS INT) 
        != TRY_CAST(sls_quantity AS INT) 
           * TRY_CAST(sls_price AS INT)
    OR sls_sales IS NULL
    OR sls_quantity IS NULL
    OR sls_price IS NULL
    OR TRY_CAST(sls_sales AS INT) <= 0
    OR TRY_CAST(sls_quantity AS INT) <= 0
    OR TRY_CAST(sls_price AS INT) <= 0
ORDER BY sls_sales;



-- identify Out-of-range DATES

SELECT DISTINCT
    bdate
FROM
    bronze.erp_cust_az12
WHERE 
    bdate < '1924-01-01' OR bdate > GETDATE()


-- Data Standardization & Consistency
SELECT DISTINCT
gen
FROM
    bronze.erp_cust_az12



SELECT
    REPLACE(cid, '-', '') cid,
    CASE
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
FROM
    bronze.erp_loc_a101



-- DATA Standardization & Consistency

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry





SELECT
    id,
    cat,
    subcat,
    maintenance
FROM
    bronze.erp_px_cat_g1v2


-- CHECK FOR unwanted Spaces

SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(Cat)

-- Data Standardization & Consistency

SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2
