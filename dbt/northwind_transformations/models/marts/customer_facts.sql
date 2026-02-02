with customers as
(
	select 
	a.customer_id,
	concat(a.first_name,' ',a.last_name) as customer_name,
	a.gender,
	a.email,
	a.date_of_birth,
	extract(year from current_date) - extract(year from a.date_of_birth) as age,
	concat(b.address_line_1,', ',city,', ',zip) as address,
	account_created_on as registered_date
	from
	{{ ref('postgres_stg_customers') }}a
	left join 
	{{ ref('postgres_stg_customer_address') }} b
	on a.address_id = b.address_id
),
orders as 
(
	select customer_id,
	min(date(order_created_at)) as first_order_date,
	max(date(order_created_at)) as last_order_date,
	count(distinct order_id) as total_orders,
	sum(order_total) as total_spend
	from {{ ref('postgres_stg_orders') }}
	group by customer_id
)
select 
customers.*,
orders.first_order_date,
orders.last_order_date,
orders.total_orders,
orders.total_spend
from customers 
left join orders on customers.customer_id = orders.customer_id