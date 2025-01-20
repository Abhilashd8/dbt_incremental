{%- set payment_methods = ["credit_card","coupon","bank_transfer","gift_card"] -%}



with src_payments as (
    
    select * from {{ source('stripe', 'payment') }}
),

final as (
select orderid,
    {% for payment_method in  payment_methods -%}

    sum(case when paymentmethod = '{{payment_method}}' then amount else 0 end) as {{ payment_method }}_amount
    
    {%- if not loop.last -%}
        ,
    {% endif -%}
    {%- endfor %}
from src_payments
where status = 'success'
group by orderid

)

select * from final