with 
orders as
(
	select 
	o.order_id,
	o.customer_id,
	o.order_timestamp,
	op.article_id,
	o.shipping_address_id,
	sum(o.shipping_cost) total_shipping_cost,
	sum(op.amount) total_orders,
	sum(op.price) order_total
	from 
	{{ ref('postgres_stg_orders') }} o
	left join 
	{{ ref('postgres_stg_order_positions') }} op
	on o.order_id = op.order_id
	group by 
	o.order_id,
	o.customer_id,
	o.order_timestamp,
	op.article_id, /*article table contains the colors and sizes of the products. we don't need those now*/
	o.shipping_address_id
),
products as
(
	select 
	pr.product_id, 
	pr.product_name,
	pr.category,
	pr.product_gender,
	date(pr.product_created_at),
	ar.article_id
	from 
	{{ ref('postgres_stg_products') }} pr
	left join 
	{{ ref('postgres_stg_articles') }} ar
	on pr.product_id = ar.product_id
)
select 
orders.order_id,
orders.customer_id,
products.product_id,
products.product_name,
products.category,
products.product_gender,
orders.order_timestamp,
orders.shipping_address_id,
orders.total_shipping_cost,
orders.total_orders,
orders.order_total
from orders 
left join products 
on orders.article_id = products.article_id