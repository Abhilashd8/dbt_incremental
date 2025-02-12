select 
j.value:"id"::varchar as id,
--j.value:"batters"::varchar as batters,
j.value:"name"::varchar as name,
j.value:"ppu"::varchar as ppu,
--j.value:"topping"::varchar topping,
j.value:"type"::varchar type,
j_batter.value:"id"::varchar as batter_id,
j_batter.value:"type"::varchar as batter_type,
j_topping.value:"id"::varchar as topping_id,
j_topping.value:"type"::varchar as topping_type
--j1.value:"batter"::varchar batter
 from {{ ref('stg_src_json__tbl_data_json')}} src,
lateral flatten(input=>src.json_data, outer=>true) j,
lateral flatten(input=>j.value:"batters"."batter", outer=>true) j_batter,
lateral flatten(input=>j.value:"topping" ,outer=>true) j_topping
