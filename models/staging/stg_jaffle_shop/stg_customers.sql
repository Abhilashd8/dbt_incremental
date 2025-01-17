select ID as customer_id,
first_name as customer_first_name,
REPLACE(last_name,'.',' ') as customer_last_name,
customer_first_name ||' '||customer_last_name as customer_name,
current_timestamp as sys_ins_dttm,
current_timestamp as sys_upd_dttm
from {{ source('jaffle_shop', 'customers') }}