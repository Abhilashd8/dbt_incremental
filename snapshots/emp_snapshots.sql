{% snapshot  emp_snapshot %}

{{
    config(
        target_database = 'analytics',
        target_schema='dbt_adubasi',
        strategy='timestamp',
        unique_key='id',
        updated_at='sys_upd_dttm',
        invalidate_hard_deletes = 'true'
    )
}}

select * from {{ source('emp', 'employee_details') }}

{% endsnapshot %}