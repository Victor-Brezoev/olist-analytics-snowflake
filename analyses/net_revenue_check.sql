-- check items (price + freight) vs payments
-- 98665 orders, 98362 same, 264 paid more, 39 paid less
-- paid more have more installments (6.3 vs 2.9), maybe interest
-- paid less - no reason found, only 39
-- using items, payments can not split by product or seller

with items as (
    select
        order_id,
        sum(price) + sum(freight_value) as items_total
    from {{ ref('stg_olist__order_items') }}
    group by order_id
),

payments as (
    select
        order_id,
        sum(payment_value) as total_payment,
        max(installments) as max_installments,
        max(case when payment_type = 'voucher' then 1 else 0 end) as has_voucher
    from {{ ref('stg_olist__order_payments') }}
    group by order_id
),

compared as (
    select
        i.order_id,
        case
            when abs(i.items_total - p.total_payment) <= 0.01 then 'matching'
            when p.total_payment > i.items_total then 'paid_more'
            else 'paid_less'
        end as result,
        p.max_installments,
        p.has_voucher
    from items i
    join payments p on i.order_id = p.order_id
)

select
    result,
    count(*) as orders,
    round(avg(max_installments), 1) as avg_installments,
    round(avg(has_voucher) * 100, 1) as pct_with_voucher
from compared
group by result


-- orders by status, with and without items
-- 775 orders have no items, most are unavailable and canceled
-- 461 canceled orders still have items, so we filter by status

/*
with items as (
    select distinct order_id
    from {{ ref('stg_olist__order_items') }}
)

select
    o.order_status,
    count(*) as orders,
    count(i.order_id) as orders_with_items
from {{ ref('stg_olist__orders') }} o
left join items i on o.order_id = i.order_id
group by o.order_status
order by orders desc
*/


-- net revenue from staging, same as fct_orders (15735527.03)

/*
select
    sum(i.price + i.freight_value) as net_revenue_from_staging
from {{ ref('stg_olist__order_items') }} i
join {{ ref('stg_olist__orders') }} o on i.order_id = o.order_id
where o.order_status not in ('canceled', 'unavailable')
*/