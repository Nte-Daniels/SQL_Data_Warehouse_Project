
/*
====================================================================================================
Quality Checks
====================================================================================================

Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:

    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.

====================================================================================================
*/

------------------------------------------------------------
-- Run ETL Pipelines
------------------------------------------------------------
EXEC bronze.load_bronze;
EXEC silver.load_silver;

------------------------------------------------------------
-- Checking: silver.crm_cust_info
------------------------------------------------------------
-- Check for duplicate or NULL customer IDs
-- Expectation: No results
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

------------------------------------------------------------
-- Checking: silver.erp_loc_a101
------------------------------------------------------------
-- Check for duplicate customer location records
-- Expectation: No results
SELECT
    cid,
    COUNT(*) AS duplicate_count
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Checking: silver.crm_prd_info + silver.erp_px_cat_g1v2
------------------------------------------------------------
-- Check for duplicate active product keys
-- Expectation: No results
SELECT
    prd_key,
    COUNT(*) AS duplicate_count
FROM (
    SELECT
        pn.prd_id,
        pn.cat_id,
        pn.prd_key,
        pn.prd_nm,
        pn.prd_cost,
        pn.prd_line,
        pn.prd_start_dt,
        pc.cat,
        pc.subcat,
        pc.maintenance
    FROM silver.crm_prd_info pn
    LEFT JOIN silver.erp_px_cat_g1v2 pc
        ON pn.cat_id = pc.id
    WHERE prd_end_dt IS NULL
) t
GROUP BY prd_key
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Checking: Gender Consistency (CRM vs ERP)
------------------------------------------------------------
-- CRM is the master source for gender
SELECT
    ci.cst_gndr AS crm_gender,
    ca.gen AS erp_gender,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS resolved_gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid
ORDER BY 1, 2;

------------------------------------------------------------
-- Schema Validation
------------------------------------------------------------
EXEC sp_help 'silver.crm_sales_details';
EXEC sp_help 'gold.dim_products';
EXEC sp_help 'gold.dim_customers';

------------------------------------------------------------
-- Foreign Key Integrity Check
------------------------------------------------------------
-- Check for orphaned fact records
-- Expectation: No results
SELECT
    *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE
    p.product_key IS NULL
    OR c.customer_key IS NULL;
