# Brazilian E-Commerce (Olist) Retail & Logistics Analytics

An end-to-end data analytics project exploring 100,000+ orders from the Brazilian e-commerce platform Olist (2016–2018). This repository focuses on relational modeling, SQL-driven business analytics, and Python-based exploratory data analysis (EDA) to understand delivery delay bottlenecks, customer behavior, and review score drivers.

---

## Business Questions Solved

### 1. SQL Phase (Relational Data Modeling & Querying)
* **Customer Retention & Repeat Dynamics:** Quantified customer reorder behavior, discovering an extreme single-order dynamic (>96% one-time purchasers) indicating low long-term customer lifetime value (LTV).
* **RFM Customer Segmentation:** Classified customer cohorts by Recency, Frequency, and Monetary parameters using PostgreSQL window functions and CTEs.
* **Logistics & Delivery Bottlenecks:** Pinpointed state-level delivery transit lags and compared actual delivery timelines against estimated carrier dates.
* **Seller Concentration:** Analyzed Gross Merchandise Value (GMV) distribution across sellers to assess platform dependency on top sellers.

### 2. Python Phase (EDA & Statistical Correlation)
* **Delivery Lag vs. Review Score Correlation:** 
  * Pearson correlation revealed a moderate negative correlation ($r \approx -0.30$) between total delivery time and customer review scores.
  * Late orders severely penalized customer satisfaction: **on-time orders averaged a review score of 4.21 (median 5.0)**, whereas **delayed orders plummeted to an average of 2.55 (median 2.0)**.
* **State-Level SLA Variance:**
  * Identified regional delivery bottlenecks, with northeastern states experiencing late delivery rates exceeding 20% (e.g., Alagoas at 24%, Maranhão at 20%).
* **Outlier & Distribution Analysis:**
  * Performed Interquartile Range (IQR) analysis on order values and freight fees, isolating upper-tier freight values contributing to regional churn.

---

## Key Visualizations

1. **Review Score Distribution (On-Time vs. Late):** Confirms that delivery punctuality is the single largest operational driver of 5-star ratings vs. 1-star reviews.
2. **Delay Severity Boxplots:** Late deliveries exceeding estimated arrival times by more than 10–15 days almost exclusively result in 1-star ratings.

---

## Tech Stack & Tools

* **Database:** PostgreSQL (Relational schema modeling, CTEs, Window Functions, Aggregate Joins)
* **Python Libraries:** `pandas`, `numpy`, `sqlalchemy`, `seaborn`, `matplotlib`, `python-dotenv`
* **BI & Reporting:** Power BI (Dataset exported for interactive KPI tracking)

---

## Project Structure

```text
├── Python/
│   ├── DATA Analysis.ipynb      # EDA, statistical correlation, and outlier testing
│   ├── .env.example             # Template for local database credentials
│   └── olist_delivery_final.csv # Cleaned export for Power BI reporting
├── SQL/
│   ├── schema_setup.sql         # 9-table relational database schema
│   └── analytical_queries.sql   # 17 business queries (RFM, GMV, Retention)
├── .gitignore                   # Ignores sensitive credentials (.env)
└── README.md                    # Project documentation
```

---

## How to Run Locally

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Chandanvvvvvvvv/olist-ecommerce-analytics.git
   cd olist-ecommerce-analytics
   ```

2. **Set Up Python Environment:**
   ```bash
   pip install pandas numpy seaborn matplotlib sqlalchemy psycopg2-binary python-dotenv
   ```

3. **Configure Environment Variables:**
   * Create a `.env` file in the project folder with your local PostgreSQL credentials:
     ```text
     DB_USER=postgres
     DB_PASS=your_password
     DB_HOST=localhost
     DB_PORT=5432
     DB_NAME=Olist_Customer_DataBase
     ```

4. **Run the Notebook:**
   * Open `Python/DATA Analysis.ipynb` in VS Code or JupyterLab and execute the cells.
