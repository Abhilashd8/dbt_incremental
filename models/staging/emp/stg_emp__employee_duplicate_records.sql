with 

source as (

    select * from {{ source('emp', 'employee_duplicate_records') }}

),

renamed as (

    select
        id,
        name,
        department,
        salary,
        update_at

    from source

)

select * from renamed
