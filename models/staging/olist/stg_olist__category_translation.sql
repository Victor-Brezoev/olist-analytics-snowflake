with 

source as (

    select * from {{ source('olist', 'category_translation') }}

),

renamed as (

    select
        product_category_name as category_name,
        product_category_name_english as category_name_english,
        _source_file,
        _loaded_at

    from source

)

select * from renamed