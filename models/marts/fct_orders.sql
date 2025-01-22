/* This model will find the number of orders placed each day*/

{{
    config(
        materialized = 'incremental',
        unique_key = 'order_id',
        on_schema_change = 'fail',
        incremental_strategy = 'merge',
        merge_exclude_columns = ['sys_ins_dttm','sys_upd_dttm'],
        pre_hook = ('delete from {{ this }} trg
                        where trg.order_id not in (
                            select orders.order_id from {{ ref("stg_orders")}} orders
                            where orders.order_id is not null)'
                        )
            )
        
}}

with  orders as (
select * from {{ ref('stg_orders') }}
where order_status = 'placed'

),

payments as (
    select * from {{ ref('stg_payments') }}
    where payment_status = 'success'
),

customers as (
    select * from {{ ref('stg_customers') }}
),

customer_orders as (
    select customers.customer_name,
        customers.customer_id, 
        orders.order_id,
        orders.order_placed_at,
        orders.order_status
    from orders
    left join customers on customers.customer_id = orders.customer_id
),

find_orders as (
    select customer_name,
        customer_id,
        customer_orders.order_id as order_id,
        order_placed_at,
        order_status,
        payments.payment_status,
        count(customer_orders.order_id) over(partition by customer_orders.customer_id,order_placed_at order by order_placed_at) as total_orders_placed
    from customer_orders 
    join payments on customer_orders.order_id = payments.order_id
    order by order_placed_at desc
    
    
),

--below CTE will remove the duplicates that are going to final table
final as (
    select customer_id || '~'||order_id as cust_ord_intgr_id,
    customer_id,
    order_id, 
    customer_name,
    order_placed_at,
    order_status,
    payment_status,
    total_orders_placed,
    '-1' as is_deleted,
    current_timestamp as sys_ins_dttm,
    current_timestamp as sys_upd_dttm
    from find_orders
    qualify(row_number() over(partition by order_id order by order_placed_at desc)) = 1
)
select * from final 
{%if is_incremental() %}
 where order_placed_at > (select max(order_placed_at) from {{ this }})
{% endif %}





