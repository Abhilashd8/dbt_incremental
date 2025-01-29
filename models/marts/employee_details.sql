{{
    config(
        materialized='incremental',
        unique_key='id',
        on_schema_change = 'sync_all_columns'
    )
}}


select * from {{ source('emp', 'employee_details') }} as employee_details

{% if is_incremental() %}
where employee_details.sys_upd_dttm > (select max(sys_upd_dttm) from {{this}})
{% endif %}

