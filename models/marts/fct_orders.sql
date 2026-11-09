{{
    config(
        materialized = 'incremental',
        unique_key = 'order_id',
        incremental_strategy = 'merge'
    )
}}

with orders as (

    select * from {{ ref('stg_olist__orders') }}

    {% if is_incremental() %}
    where _loaded_at > (select max(_loaded_at) from {{ this }})
    {% endif %}

),

customers as (

    select * from {{ ref('stg_olist__customers') }}

),

items as (

    select * from {{ ref('int_order_items') }}

),

payments as (

    select * from {{ ref('int_order_payments') }}

),

reviews as (

    select * from {{ ref('int_order_reviews_last_review') }}

),

joined as (

    select
        o.order_id,
        c.customer_unique_id_hash,
        o.order_status,
        o.purchased_at,
        o.approved_at,
        o.delivered_to_carrier_at,
        o.delivered_to_customer_at,
        o.estimated_delivery_date,
        i.items_count,
        i.product_revenue,
        i.freight_revenue,
        p.payment_count,
        p.total_payment,
        p.voucher_payment,
        r.review_score,
        o._loaded_at
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join items i on o.order_id = i.order_id
    left join payments p on o.order_id = p.order_id
    left join reviews r on o.order_id = r.order_id

),

final as (

    select
        order_id,
        customer_unique_id_hash,
        order_status,
        cast(purchased_at as date) as order_date,
        purchased_at,
        approved_at,
        delivered_to_carrier_at,
        delivered_to_customer_at,
        estimated_delivery_date,
        items_count,
        product_revenue,
        freight_revenue,
        case
            when order_status in ('canceled', 'unavailable') then 0
            else coalesce(product_revenue, 0) + coalesce(freight_revenue, 0)
        end as net_revenue,
        payment_count,
        total_payment,
        voucher_payment,
        review_score,
        {{ days_between('purchased_at', 'delivered_to_customer_at') }} as delivery_days,
        {{ days_between('estimated_delivery_date', 'delivered_to_customer_at') }} as delay_days,
        cast(delivered_to_customer_at as date) > estimated_delivery_date as is_late,
        _loaded_at
    from joined

)

select * from final