with

sellers as (

    select * from {{ ref('stg_olist__sellers') }}

),

final as (

    select
        seller_id,
        zip_code_prefix,
        city,
        state

    from sellers

)

select * from final