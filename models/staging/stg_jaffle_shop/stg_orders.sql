select id as order_id,
user_id as customer_id,
order_date as order_placed_at,
status as order_status,
_etl_loaded_at as sys_ins_dttm,
current_timestamp as sys_upd_dttm
from {{ source('jaffle_shop','orders') }}
