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
