# 📊 SQL_Data_Analytics

## 📝 Project Overview

This project is a **SQL-based Exploratory Data Analysis (EDA)** conducted on a simulated data warehouse setup. It involves importing data from CSV files into MySQL tables, performing descriptive statistics, segmentation, trend analysis, and building summarized views for customer and product analytics.

## 🧱 Database Structure

The project creates a MySQL database named `DataWarehouseAnalytics` and consists of the following key tables:

- `dim_customers` – Contains customer details (demographics, IDs, creation date).
- `dim_products` – Contains product metadata (category, cost, product lines).
- `fact_sales` – Transactional sales data (order details, sales amount, quantity, price).

> 📂 Data was imported from **CSV files** into these tables.

## 🗃️ EDA and Analytics

The SQL script contains comprehensive analysis divided into:

### 🔍 Exploratory Data Analysis

- **Schema Exploration** – View all tables and columns.
- **Category Breakdown** – Products grouped by category/subcategory.
- **Time Span Analysis** – Range of orders by date.
- **Customer Insights** – Age ranges, youngest/oldest customers.
- **Sales Metrics** – Total sales, item count, average selling price, total orders.
- **Key Aggregated KPIs** – Created a summary table (`Aggregated_Table`) of business metrics.

### 📐 Dimension Exploration

- Customers by country and gender
- Products by category and cost
- Revenue per customer and per category
- Quantity distribution across countries

### 🏆 Ranking and Performance

- Top 5 and bottom 5 products by revenue
- Top-performing categories
- Top 10 customers by revenue

### 📈 Advanced Analytics

- **Monthly and Yearly Trends** – Total sales, customer counts, and item trends over time.
- **Year-over-Year Product Sales** – Performance flagging (high/low performance).
- **Part-to-Whole** – Contribution of categories to total revenue.
- **Segmentation**:
  - Products: Based on cost and performance ranges.
  - Customers: Grouped as VIP, Regular, and New based on behavior.

### 📋 Report Views

The script creates two views for quick access to summarized reports:

- **Customer Report (`Customer_report`)**:
  - Tracks total sales, orders, quantity, customer lifespan, recency, and segments.
- **Product Report (`product_details`)**:
  - Tracks product-level sales, order counts, average revenue, recency, and performance flags.

## ⚙️ Setup Instructions

1. **Run the SQL Script**  
   - Use MySQL Workbench, phpMyAdmin, or any MySQL-compatible IDE to execute the `SQL_EDA_PROJECT.sql`.

2. **Import Data into Tables**  
   Use **any one** of the following methods to import CSV data into the corresponding tables:

   **Option 1: Using `LOAD DATA INFILE` (Command Line or SQL Query Editor)**  
   - Enable CSV import by setting the global variable:  
     ```sql
     SET GLOBAL local_infile = 1;
     ```
   - Then use:
     ```sql
     LOAD DATA LOCAL INFILE 'path_to_file.csv'
     INTO TABLE your_table
     FIELDS TERMINATED BY ',' 
     ENCLOSED BY '"'
     LINES TERMINATED BY '\n'
     IGNORE 1 ROWS;
     ```

   **Option 2: Using MySQL Workbench Import Wizard**  
   - Right-click the table > *Table Data Import Wizard*
   - Select your CSV file
   - Follow the steps to map columns and import data

> ⚠ Make sure your table structures match the CSV files (column names and data types).
# Sample Results
## Customer Report 
![Customer_report](https://github.com/user-attachments/assets/d090e4d4-722e-493b-a5e0-710cfc6ae43f)

## Product Report
![Product Report](https://github.com/user-attachments/assets/16fefc5d-7f38-4f93-880d-10949d28ad6b)
