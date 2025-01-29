with 

source as (

    select * from {{ source('emp', 'employee_details') }}

),

renamed as (

    select
        id,
        name,
        position,
        department,
        salary,
        received_at,
        sys_upd_dttm

    from source

)

select * from renamed
