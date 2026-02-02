select 
    id as customer_id,
    firstname first_name,
    lastname last_name,
    initcap(gender :: text) gender,
    email,
    dateofbirth date_of_birth,
    currentaddressid address_id,
    date(created) account_created_on
from  {{source('staging', 'customer')}}