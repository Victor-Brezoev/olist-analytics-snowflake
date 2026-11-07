with 

payments as (

    select * from {{ ref('stg_olist__order_payments') }}

),

aggregated as (

    select
        order_id,
        count(*) as payment_count,
        sum(payment_value) as total_payment,
        sum(case when payment_type = 'voucher' then payment_value else 0 end) as voucher_payment

from payments
group by order_id
)

select * from aggregated