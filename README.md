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

1. **Import the Script** into a MySQL-compatible environment (MySQL Workbench, phpMyAdmin, etc.).
2. Ensure **CSV data** for `dim_customers`, `dim_products`, and `fact_sales` are already loaded.
3. Run the script to:
   - Create the database and tables
   - Execute exploratory queries
   - Generate summary views and reports

> 💡 To enable CSV imports, make sure `local_infile=1` is enabled in your MySQL server settings.

