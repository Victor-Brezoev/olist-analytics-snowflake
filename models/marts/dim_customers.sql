with customers as (

    select * from {{ ref('stg_olist__customers') }}

),

orders as (

    select 
        customer_id,
        purchased_at
    from {{ ref('stg_olist__orders') }}

),

customer_orders as (

    select
        c.customer_id,
        c.customer_unique_id_hash,
        c.zip_code_prefix,
        c.city,
        c.state,
        o.purchased_at
    from customers c 
    join orders o on c.customer_id = o.customer_id

),

final as (

    select
        customer_unique_id_hash,
        zip_code_prefix,
        city,
        state,
        min(purchased_at) over (partition by customer_unique_id_hash) as first_order,
        max(purchased_at) over (partition by customer_unique_id_hash) as last_order,
        count(*) over (partition by customer_unique_id_hash) as total_orders

    from customer_orders

    qualify row_number() 
    over (partition by customer_unique_id_hash order by purchased_at, customer_id) = 1 

)

select * from final
    order by total_orders desc
