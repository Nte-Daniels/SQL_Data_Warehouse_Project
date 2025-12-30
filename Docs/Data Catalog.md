# Data Dictionary – Gold Layer

## Overview

The **Gold Layer** represents the business-ready data model designed for analytics and reporting.
It follows a **Star Schema** structure consisting of **dimension tables** and **fact tables**.

---

## 1. `gold.dim_customers`

**Purpose:**  
Stores customer details enriched with demographic and geographic data.

### Columns

| Column Name | Data Type | Description |
|------------|----------|-------------|
| customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id | INT | Unique numerical identifier assigned to the customer. |
| customer_number | NVARCHAR(50) | Alphanumeric customer identifier used for tracking and referencing. |
| first_name | NVARCHAR(50) | Customer’s first name as recorded in the system. |
| last_name | NVARCHAR(50) | Customer’s last name or family name. |
| country | NVARCHAR(50) | Country of residence for the customer (e.g., Australia, United States). |
| marital_status | NVARCHAR(50) | Marital status of the customer (e.g., Married, Single). |
| gender | NVARCHAR(50) | Gender of the customer (Male, Female, n/a). |
| birthdate | DATE | Customer’s date of birth. |
| create_date | DATE | Date the customer record was created in the source system. |

---

## 2. `gold.dim_products`

**Purpose:**  
Provides information about products and their attributes.

### Columns

| Column Name | Data Type | Description |
|------------|----------|-------------|
| product_key | INT | Surrogate key uniquely identifying each product record in the product dimension table. |
| product_id | INT | Unique identifier assigned to the product for internal tracking. |
| product_number | NVARCHAR(50) | Structured alphanumeric code representing the product. |
| product_name | NVARCHAR(100) | Descriptive name of the product including key attributes. |
| category_id | NVARCHAR(50) | Unique identifier for the product category. |
| category | NVARCHAR(50) | High-level product classification (e.g., Bikes, Components). |
| subcategory | NVARCHAR(50) | Detailed classification of the product within the category. |
| maintenance | NVARCHAR(50) | Indicates whether the product requires maintenance (Yes / No). |
| cost | INT | Cost or base price of the product. |
| product_line | NVARCHAR(50) | Product line or series (e.g., Road, Mountain). |
| start_date | DATE | Date when the product became available for sale. |

---

## 3. `gold.fact_sales`

**Purpose:**  
Stores transactional sales data used for analytical reporting and performance tracking.

### Columns

| Column Name | Data Type | Description |
|------------|----------|-------------|
| order_number | NVARCHAR(50) | Unique identifier for the sales order. |
| product_key | INT | Surrogate key referencing `gold.dim_products`. |
| customer_key | INT | Surrogate key referencing `gold.dim_customers`. |
| order_date | DATE | Date when the order was placed. |
| shipping_date | DATE | Date when the order was shipped. |
| due_date | DATE | Date when the order was due. |
| sales_amount | INT | Total sales amount for the order line. |
| quantity | INT | Number of units sold. |
| price | INT | Unit price of the product at the time of sale. |

---
