with

review as (

    select * from {{ ref('stg_olist__order_reviews') }}

),

last_review as (

    select
        order_id,
        review_id,
        review_score,
        review_answered_at,
        count(*) over (partition by order_id) as total_reviews
    from review
        qualify row_number() over(partition by order_id order by review_answered_at desc) = 1
    
)

select * from last_review