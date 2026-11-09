select
    order_id,
    delivered_to_customer_at,
    purchased_at
from {{ ref('fct_orders') }}
    where delivered_to_customer_at < purchased_at