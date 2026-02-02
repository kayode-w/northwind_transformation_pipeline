select 
id as color_id,
initcap(name) as color_name,
rgb as color_rgb
from {{source ('staging', 'colors')}}
