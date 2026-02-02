select 
id as order_position_id,
orderid as order_id,
articleid as article_id,
amount,
price,
created as order_position_created_at
from {{source ('staging', 'order_positions')}}