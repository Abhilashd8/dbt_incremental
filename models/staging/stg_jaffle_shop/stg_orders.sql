select id as order_id,
user_id as customer_id,
order_date as order_placed_at,
status as order_status,
current_timestamp as sys_ins_dttm,
current_timestamp as sys_upd_dttm,
_etl_loaded_at 
from {{ source('jaffle_shop','orders') }}
