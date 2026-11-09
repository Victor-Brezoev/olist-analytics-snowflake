---total_orders - 98666          orders_with_more_sellers - 1278        max_sellers - 5
---

with seller_per_order as (
    
    select
    order_id, 
    count(distinct seller_id) as unique_sellers
from {{ ref('stg_olist__order_items') }}
group by order_id

)

select
    count(*) as total_orders,
    sum(case when unique_sellers > 1 then 1 else 0 end) as order_with_more_sellers,
    max(unique_sellers) as max_sellers
from seller_per_order