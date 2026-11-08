--customers with orders from more than 1 address---------

with customer_orders as (
    select 
    c.customer_unique_id_hash,
    c.zip_code_prefix,
    c.city,
    o.purchased_at
    from {{ ref('stg_olist__customers') }} c
    join {{ ref('stg_olist__orders') }} o
    on c.customer_id = o.customer_id
),
customer_location as (
    select 
        customer_unique_id_hash as client,
        count(distinct zip_code_prefix) as locations
    from customer_orders
    group by customer_unique_id_hash
)

select 
    count(*)
from customer_location
where locations > 1
---------------------------------------------------


-- the last order is in dim_customers

with customer_orders as (

    select
        c.customer_unique_id_hash,
        c.zip_code_prefix,
        c.city,
        o.purchased_at
    from {{ ref('stg_olist__customers') }} c
    join {{ ref('stg_olist__orders') }} o
        on c.customer_id = o.customer_id

),

customers_with_more_zips as (

    select customer_unique_id_hash
    from customer_orders
    group by customer_unique_id_hash
    having count(distinct zip_code_prefix) > 1
    limit 1

)

select *
from customer_orders
where customer_unique_id_hash in (select customer_unique_id_hash from customers_with_more_zips)
order by purchased_at

--------------------------------------

select product_id, count(*)
from {{ ref('stg_olist__products') }}
group by product_id
having count(*) > 1