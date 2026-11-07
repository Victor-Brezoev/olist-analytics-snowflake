with

source as (

    select * from {{ source('olist', 'order_reviews') }}

),

renamed as (

    select
        review_id,
        order_id,
        cast(review_score as integer) as review_score,
        review_comment_title as comment_title,
        review_comment_message as comment_message,
        cast(review_creation_date as date) as review_created_date,
        cast(review_answer_timestamp as timestamp_ntz) as review_answered_at,
        _source_file,
        _loaded_at

    from source

)

select * from renamed