# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  

This project demonstrates a **comprehensive end-to-end data warehousing and analytics solution**, covering the full journey from building a modern data warehouse to delivering actionable business insights.

Designed as a **hands-on portfolio project**, it highlights industry best practices in **data engineering and analytics**, including data modeling, data quality management, and SQL-based analytical reporting.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using **SQL Server** to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (**ERP** and **CRM**) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

## 📊 BI: Analytics & Reporting (Data Analytics)

### Objective
Develop SQL-based analytics to deliver detailed insights into:

- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling data-driven and strategic decision-making.

---

## 🗄️ Data Warehouse Design

The data warehouse is designed using a **dimensional (star schema) model** optimized for analytical workloads.

### Fact Table
- **FactSales**
  - Sales Amount
  - Quantity Sold
  - Order Date
  - Customer Key
  - Product Key

### Dimension Tables
- **DimCustomer**
- **DimProduct**
- **DimDate**
- **DimLocation**

This design ensures high query performance and intuitive reporting.

---

## 🧪 Data Quality & Transformation

The following data processing steps are applied:
- Removal of duplicate records
- Standardization of data types
- Handling of missing or invalid values
- Enforcement of business rules
- Validation of referential integrity

---

## 🛠️ Tools & Technologies

| Category | Technology |
|--------|-----------|
| Database | SQL Server |
| Language | SQL |
| Data Modeling | Star Schema |
| Source Data | CSV Files |
| Analytics | SQL Queries |
| Version Control | Git & GitHub |

---

## 📁 Repository Structure

```text
├── data/
│   ├── erp_data.csv
│   └── crm_data.csv
├── sql/
│   ├── staging/
│   ├── transformations/
│   ├── dimensions/
│   ├── facts/
│   └── analytics/
├── docs/
│   └── data_model.png
└── README.md
