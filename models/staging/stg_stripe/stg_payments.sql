select id as payment_id,
orderid as order_id,
paymentmethod as payment_method,
status as payment_status,
amount as amount_paid,
created as updated_at,
_batched_at as sys_ins_dttm,
current_timestamp as sys_upd_dttm
from {{source("stripe","payment")}}