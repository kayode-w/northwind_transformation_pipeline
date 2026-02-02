select 
id as product_id,
name as product_name,
labelid as product_label_id,
category,
initcap(gender :: text) as product_gender,
currentlyactive as is_active,
created as product_created_at
from {{source ('staging', 'products') }}