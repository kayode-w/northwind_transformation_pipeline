select 
id as order_id,
customer as customer_id,
ordertimestamp as order_timestamp,
shippingaddressid as shipping_address_id,
created as order_created_at,
shippingcost as shipping_cost,
total as order_total
from
{{source ('staging', 'order')}}