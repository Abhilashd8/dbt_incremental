--This anlyses will generate compiled code.
--To find and remove the duplicates present in the source table.

With find_duplicate_records as (select distinct * 
from {{ ref('stg_emp__employee_duplicate_records') }}
order by id
)

select * from find_duplicate_records
