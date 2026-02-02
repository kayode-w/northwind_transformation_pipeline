select
id as article_id,
productid as product_id,
ean,
colorid as color_id,
size,
description,
originalprice as original_price,
taxrate as tax_rate,
discountinpercent as discount_in_percent,
currentlyactive as is_active,
created as article_created_at
from {{source ('staging', 'articles')}}
