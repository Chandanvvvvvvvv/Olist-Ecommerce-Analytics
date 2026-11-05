-- TOP 3 Products from each Category

with ranked_products as(
select t.product_category_name_english as Category,
i.product_id as Product_Id, 
round(sum(i.price)::numeric,2) as Total_Revenue,
dense_rank() over(
partition by t.product_category_name_english
order by sum(i.price) desc
)as product_rank
from orders o 
join order_items as i
on o.order_id=i.order_id
join products as p
on i.product_id=p.product_id
join product_category_name_translation as t
on p.product_category_name = t.product_category_name 
where o.order_status='delivered'
group by t.product_category_name_english , i.product_id
)

select category,product_id,total_revenue from ranked_products
where product_rank <= 3
order by category asc,product_rank asc;


-- Top 2 sellers by revenue in each state

with Ranked_Seller as (
select s.seller_state as State, 
s.seller_ID as Seller_ID, 
round(sum(i.price)::numeric,2) as Total_Revenue,
dense_rank() over(
partition by s.seller_state
order by sum(i.price) desc
) as seller_rank
from orders o
join order_items i
on o.order_id = i.order_id
join sellers as s
on i.seller_id = s.seller_id
where o.order_status='delivered'
group by s.seller_state,s.Seller_ID
)

select State,Seller_ID,Total_Revenue,seller_rank from Ranked_seller
where seller_rank <=2 
order by state asc, seller_rank asc;

-- Month Over Month Revenue Growth

with monthly_sales as(
select date_trunc('month',o.order_purchase_timestamp)::date as Month,
round(sum(i.price)::numeric,2) as Monthly_revenue
from orders o
join order_items i
on o.order_id = i.order_id
where o.order_status ='delivered'
group by Month
)

select Month,Monthly_revenue,
sum(monthly_revenue) over (order by month asc) as Cumulative_Revenue,
round(
(monthly_revenue - lag(monthly_revenue) over (order by month asc))/ nullif(lag(monthly_revenue) over 
(order by month asc),0) *100,2) as mom_pct_growth
from monthly_sales
order by month asc;

--Customer repeat Purchase Rate

with customer_orders as (
select c.customer_unique_id as Customer, count(c.customer_unique_id) as Repeat_Purchases
from customer_dataset c
join orders o 
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id
)

select count(*) as total_customers,
count( case when repeat_purchases >1 then 1 end) as Repeat_customer,
round((count( case when repeat_purchases>1 then 1 end)::numeric/count(*)*100),2) as repat_purchase_pct
from customer_orders;

-- Delivery Delay Analysis  & late delivery Rate

with delivery_delay as(
select
(o.order_delivered_customer_date::date - o.order_estimated_delivery_date::date) as delay_days
from orders o
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
)

select count(*) as total_delivered_orders,
count(case when delay_days>0 then 1 end) as delayed_orders,
round(
(count(case when delay_days>0 then 1 end)::numeric/count (*)*100),2)
as delivery_delay_pct,
round(
avg(case when delay_days>0 then delay_days end)::numeric,1) as avg_late_days
from delivery_delay;

--RFM Analysis
WITH rfm_raw AS (
    SELECT 
        c.customer_unique_id AS customer,
        (SELECT MAX(order_purchase_timestamp)::date FROM orders) - MAX(o.order_purchase_timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency, 
        ROUND(SUM(i.price)::numeric, 2) AS monetary_value 
    FROM customer_dataset c 
    JOIN orders o ON c.customer_id = o.customer_id 
    JOIN order_items i ON o.order_id = i.order_id 
    WHERE o.order_status = 'delivered' 
    GROUP BY c.customer_unique_id
), 

rfm AS (
    SELECT 
        customer,
        recency,
        frequency,
        monetary_value,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary_value ASC) AS m_score,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score 
    FROM rfm_raw
), 

rfm_category AS (
    SELECT 
        customer,
        recency,
        frequency,
        monetary_value,
        r_score,
        f_score,
        m_score,
        CASE 
            WHEN r_score >= 4 AND m_score >= 4 THEN 'VIP' 
            WHEN f_score >= 3 THEN 'Loyal' 
            WHEN r_score <= 2 AND m_score >= 3 THEN 'At Risk' 
            WHEN r_score = 1 AND m_score = 1 THEN 'Lost Customer' 
            WHEN r_score >= 4 AND f_score = 1 THEN 'New Customer' 
            ELSE 'Regular' 
        END AS customer_categorization 
    FROM rfm
	
)
SELECT 
    customer_categorization,
    COUNT(customer) AS total_customers,
    ROUND(COUNT(customer) * 100.0 / SUM(COUNT(customer)) OVER (), 2) AS customer_share_pct,
    ROUND(AVG(recency), 1) AS avg_recency_days,
    ROUND(AVG(frequency), 2) AS avg_orders,
    ROUND(AVG(monetary_value), 2) AS avg_revenue_per_customer,
    ROUND(SUM(monetary_value), 2) AS total_segment_revenue
FROM rfm_category
GROUP BY customer_categorization
ORDER BY total_segment_revenue DESC;



-- Seller Concentration

with seller_sales as(
select i.seller_id as Seller_ID, round(sum(i.price)::numeric,2) as Total_revenue
from order_items i
join orders o
on i.order_id = o.order_id
where o.order_status = 'delivered'
group by seller_id),
seller_bucket as(
select
seller_id,
total_revenue,
ntile(5) over (order by Total_revenue desc) as seller_tier
from seller_sales
)

select 
seller_tier,
count(seller_id) as total_sellers,
sum(total_revenue) as tier_revenue,
round(sum(total_revenue)::numeric / sum(sum(total_revenue)) over() *100,2) as pct_of_total
from seller_bucket
group by seller_tier
order by seller_tier ASC;






