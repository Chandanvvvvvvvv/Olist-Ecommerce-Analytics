# Olist-Ecommerce-Analytics
End-to-end SQL analysis on 100k+ Brazilian e-commerce orders using PostgreSQL (RFM, Delays, Pareto).
# Brazilian E-Commerce (Olist) End-to-End Analytics

An end-to-end data analytics project exploring over **100,000 orders** from the Brazilian e-commerce platform **Olist** (2016–2018).

The project tracks the complete analytics lifecycle across three core phases:
1. **Relational Data Modeling & PostgreSQL Setup**
2. **Advanced SQL Analysis & Hygiene Auditing**
3. **Python Exploratory Data Analysis & Power BI Executive Dashboard**

---

## Repository Structure

```text
olist-ecommerce-analytics/
├── sql/
│   ├── 01_schema_setup.sql          # Relational DDL & table constraints
│   ├── 02_data_hygiene_audit.sql     # NULL handling & deduplication logic
│   └── 03_analysis_queries.sql      # Core business analysis queries
├── python/                          # [Upcoming] Data validation & EDA notebooks
├── power_bi/                        # [Upcoming] Executive dashboard .pbix file
├── docs/
│   └── er_diagram.png               # Relational database schema diagram
└── README.md

Data Architecture & Entity Relationship Diagram
The database is built on a relational star/snowflake schema linking 9 core tables:

Core Entities: customers, orders, order_items, sellers, products

Transactional Attributes: order_payments, order_reviews

Auxiliary Data: geolocation, product_category_name_translation

Database Implementation (PostgreSQL)
Schema Definition: Configured primary keys, foreign key constraints, and appropriate data types (VARCHAR, TIMESTAMP, NUMERIC(10,2)).

Data Integrity Checks: Audit routines designed to handle missing timestamps, duplicate geographic postal codes, and unmapped product categories.

Environment: PostgreSQL 16 via pgAdmin 4.

Project Roadmap
[x] Database configuration and relational table mapping

[x] Schema DDL setup and foreign key relationships

[ ] Comprehensive data quality and hygiene audit scripts

[ ] Exploratory and advanced SQL analysis (RFM segmentation, logistics delays, seller Pareto analysis)

[ ] Python Exploratory Data Analysis (EDA) & distribution cross-validation

[ ] Power BI interactive reporting dashboard

[ ] Strategic business takeaways & recommendations

Author
Business Analytics Project

Documentation and analysis scripts maintained as part of an end-to-end analytics portfolio.
