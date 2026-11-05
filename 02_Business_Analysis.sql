--Monthly_Revenue_Trend

select 
date_trunc('month',o.order_purchase_timestamp)::date as Order_Month,
round(sum(i.price)::numeric,2)as monthly_revenue,
count(distinct(o.order_id)) as total_orders
from orders o join order_items i
on o.order_id=i.order_id
where order_status = 'delivered'
group by order_month
order by order_month asc;

--Top 10 products
select i.product_id as Product_name, round(sum(i.price)::numeric,2) as Total_revenue, count( i.order_item_id) as Total_quantity
from orders as o
join order_items as i 
on o.order_id = i.order_id
where o.order_status='delivered'
group by Product_name
order by total_revenue desc
limit (10);

--Most Revennue Generating State

select c.customer_state as State , round(sum(i.price)::numeric,2) as Total_revenue, count(distinct o.order_id)as total_orders
from orders as o 
join order_items as i
on o.order_id = i.order_id
join customer_dataset as c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by State
order by total_revenue desc;

--Avg Order Value by Payment method

select p.payment_type,round(sum(p.payment_value)::numeric,2) as Total_payment_value, count(p.order_id) as Total_transactions, round(avg(p.payment_value)::numeric,2) as Avg_payment_value
from orders as o
join order_payments as p
on o.order_id = p.order_id
where o.order_status='delivered'
group by p.payment_type
order by total_payment_value desc;

--Bottom 10 Product Categories by Average Review Score

with order_category as(
select distinct
o.order_id, t.product_category_name_english as category
from orders o
join order_items i
on o.order_id = i.order_id
join products p on i.product_id = p.product_id
join product_category_name_translation t
on p.product_category_name = t.product_category_name
where o.order_status = 'delivered'
)
select oc.category ,
round(avg(r.review_score)::numeric,2) as avg_review_score,
count(*) as total_reviews
from order_category oc 
join order_review r on oc.order_id = r.order_id
group by oc.category
having count(*) >=50
order by  avg_review_score asc
limit 10
