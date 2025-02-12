with 

source as (

    select * from {{ source('src_json', 'tbl_data_json') }}

),

renamed as (

    select
        json_data

    from source

)

select * from renamed
