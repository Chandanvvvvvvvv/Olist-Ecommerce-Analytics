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
sum(monthly_revenue) over (order by month asc) as Cumulative_Revenue
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
avg(case when delay_days>0 then 1 end)::numeric,1) as avg_late_days
from delivery_delay;

--RFM Analysis

with RFM_raw as (
select c.customer_unique_id as Customer,
('2018-10-18'::date-max(o.order_purchase_timestamp)::date) as Recency,
count(distinct o.order_id )as Frequency,
round(sum(i.price)::numeric,2) as monetary_value
from customer_dataset c
join orders o
on c.customer_id = o.customer_id
join order_items i
on o.order_id = i.order_id
where o.order_status = 'delivered'
group by Customer
order by monetary_value desc
),
rfm as(
select Customer,Recency,frequency,monetary_value, 
(ntile(5) over (order by Frequency ASC)) as f_score,
(ntile(5) over (order by Monetary_value asc)) as m_score,
(ntile(5) over (order by Recency desc)) as r_score
from RFM_raw),
rfm_category as(
select customer,recency,frequency,
f_score,m_score,r_score,
case 
when r_score>=4 and m_score>=4 then 'VIP'
when f_score>= 4 then 'Loyal'
when r_score <= 2 and m_score>=3 then 'Churn'
when r_score=1 and m_score = 1 then 'Lost_Customer'
when r_score >= 4 and f_score=1 then 'New_Customer'
else 'Regular'
end as Customer_Categorization
from RFM)
-- Summary of the categorization Condensed
select 
customer_categorization,
count(*) as Total_customers,
round(count(*)::numeric / sum(count(*)) over()*100,2) as pct_of_base
from rfm_category
group by customer_categorization
order by total_customers desc;


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






