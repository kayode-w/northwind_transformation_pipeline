select 
id as stock_id,
articleid as article_id,
count as stock_count,
created as stock_created_at
from 
{{source('staging', 'stock')}}