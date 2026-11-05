--Basic SQL Query

-- Status of the Orders
select order_status as  Order_status ,
count(order_id) as total_count 
from orders 
group by Order_status 
order by total_count DESC;

-- Total Delivered Orders
select order_status , 
count(order_id) as total_count 
from orders 
where order_status = 'delivered' 
group by order_status ;

--Total merchandise revenue
select count(distinct o.order_id) as Total_delivered_orders ,
sum(i.price) as Total_merchandise_revenue 
from orders o inner join order_items i 
on o.order_id=i.order_id 
where order_status='delivered';

--AVG Order Value
select count(distinct o.order_id) as Total_delivered_orders , 
sum(i.price) as Total_merchandise_revenue, 
round(sum(i.price)/count(distinct o.order_id)::numeric,2)as Avg_order_value 
from orders o join order_items i 
on o.order_id=i.order_id 
where order_status='delivered';


--Top 10 Product_Category
select t.product_category_name_english as Product_Category, 
round(sum(i.price)::numeric,2) as Total_revenue 
from orders o join order_items i 
on o.order_id=i.order_id 
join products as p
on i.product_id = p.product_id
join product_category_name_translation as t
on p.product_category_name=t.product_category_name
where o.order_status='delivered'
group by t.product_category_name_english
order by total_revenue Desc
limit (10);

