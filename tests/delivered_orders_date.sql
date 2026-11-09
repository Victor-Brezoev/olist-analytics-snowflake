select
    order_id,
    order_status,
    delivered_to_customer_at
from {{ ref('fct_orders') }}
    where order_status = 'delivered' and
    delivered_to_customer_at is null