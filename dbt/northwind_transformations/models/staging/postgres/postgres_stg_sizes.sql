select 
id  as product_size_id,
gender as gender_size,
category,
lower(size) as size,
size_us,
size_uk,
size_eu
from {{source ('staging', 'sizes')}}