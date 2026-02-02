select 
id as label_id,
name as label_name,
slugname as label_slugname
from {{source ('staging', 'labels')}}