with 

source as (

    select * from {{ source('olist', 'orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        order_status,
        cast(order_purchase_timestamp as timestamp_ntz) as purchased_at,
        cast(order_approved_at as timestamp_ntz) as approved_at,
        cast(order_delivered_carrier_date as timestamp_ntz) as delivered_to_carrier_at,
        cast(order_delivered_customer_date as timestamp_ntz) as delivered_to_customer_at,
        cast(order_estimated_delivery_date as date) as estimated_delivery_date,
        _source_file,
        _loaded_at

    from source

)

select * from renamed