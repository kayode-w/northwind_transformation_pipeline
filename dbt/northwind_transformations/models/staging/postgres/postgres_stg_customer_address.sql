select 
id as address_id,
customerid as customer_id,
firstname as first_name,
lastname as last_name,
address1 as address_line_1,
city as city,
zip,
created as address_created_at
from {{source('staging', 'address')}}