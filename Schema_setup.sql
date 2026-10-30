-- Customer Table
Create table Customer_Dataset(
customer_id Varchar(50) Primary key,
customer_unique_id Varchar(50) Not Null,
customer_zip_code_prefix varchar(10),
customer_city varchar(50),
customer_state varchar(5)
);
select* from customer_dataset limit(5);
select count(*) from customer_dataset;

--Order Table
create table orders (
order_id varchar(50) primary key,
customer_id varchar(50), foreign key (customer_id) references customer_dataset(customer_id),
order_status varchar(25),
order_purchase_timestamp timestamp,
order_approved_at timestamp,
order_delivered_carrier_date timestamp,
order_delivered_customer_date timestamp,
order_estimated_delivery_date timestamp);
select * from orders limit(5);
select count(*) from orders;

-- Order Payments Table
create table order_payments(
order_id varchar(50),
payment_sequential int,
payment_type varchar(50),
payment_installments int,
payment_value numeric(10,2),
primary key (order_id,payment_sequential));
select * from order_payments limit(5);
select count(*) from order_payments;

--Order Items Table
create table order_items(
order_id varchar(50),
order_item_id  int,
product_id varchar(50),
seller_id varchar(50),
shipping_limit_date timestamp,
price numeric(10,2),
freight_value numeric(10,2),
primary key (order_id,order_item_id));
select * from order_items limit(5);
select count(*) from order_items;

-- Geolocation Table
create table geolocation(
geolocation_zip_code_prefix varchar(50),
geolocation_lat numeric(18,15),
geolocation_lng numeric(18,15),
geolocation_city varchar(50),
geolocation_state varchar(50));
select count(*) from geolocation;

-- Products Table
create table products(
product_id varchar(50) primary key,
product_category_name varchar(50),
product_name_lenght int,
product_description_lenght int,
product_photos_qty int,
product_weight_g int,
product_length_cm int,
product_height_cm int,
product_width_cm int);
select count(*) from products;

-- Sellers Table
create table sellers (
seller_id varchar(50) primary key,
seller_zip_code_prefix varchar(15),
seller_city varchar(50),
seller_state varchar(5));
select count(*) from sellers;

-- Product_Category_Name_Translation
create table product_category_name_translation (
product_category_name varchar(50),
product_category_name_english varchar(50));

-- Order_review
create table order_review(
review_id varchar(50),
order_id varchar(50),
review_score int,
review_comment_title text,
review_comment_message text,
review_creation_date timestamp,
review_answer_timestamp timestamp);
select count(*) from order_review;


CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_status ON orders(order_status);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_order_items_seller_id ON order_items(seller_id);
CREATE INDEX idx_order_payments_order_id ON order_payments(order_id);
CREATE INDEX idx_order_reviews_order_id ON order_review(order_id);
CREATE INDEX idx_products_category ON products(product_category_name);
