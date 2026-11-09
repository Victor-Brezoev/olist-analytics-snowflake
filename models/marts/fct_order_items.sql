with items as (

    select * from {{ ref('stg_olist__order_items') }}

),

orders as (

    select * from {{ ref('stg_olist__orders') }}

),

customers as (

    select * from {{ ref('stg_olist__customers') }}

),

final as (

    select
        i.order_id,
        i.order_item_number,
        i.product_id,
        i.seller_id,
        c.customer_unique_id_hash,
        o.order_status,
        cast(o.purchased_at as date) as order_date,
        i.price,
        i.freight_value,
        case
            when o.order_status in ('canceled', 'unavailable') then 0
            else i.price + i.freight_value
        end as net_revenue
    from items i
    left join orders o on i.order_id = o.order_id
    left join customers c on o.customer_id = c.customer_id

)

select * from final