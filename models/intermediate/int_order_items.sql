with items as (

    select * from {{ ref('stg_olist__order_items') }}

),

agg as (

    select
        order_id,
        count(*) as items_count, 
        sum(price) as product_revenue,
        sum(freight_value) as freight_revenue
    from items
    group by order_id

)

select * from agg