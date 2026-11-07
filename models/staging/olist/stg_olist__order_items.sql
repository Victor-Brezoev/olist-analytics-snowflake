with 

source as (

    select * from {{ source('olist', 'order_items') }}

),

renamed as (

    select
        order_id,
        cast(order_item_id as integer) as order_item_number,
        product_id,
        seller_id,
        cast(shipping_limit_date as timestamp_ntz) as shipping_limit_at,
        cast(price as number(10, 2)) as price,
        cast(freight_value as number(10, 2)) as freight_value,
        _source_file,
        _loaded_at

    from source

)

select * from renamed