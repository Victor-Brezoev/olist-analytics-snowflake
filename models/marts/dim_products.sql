with products as (

    select * from {{ ref('stg_olist__products') }}

),

translations as (

    select * from {{ ref('stg_olist__category_translation') }}

),

final as (

    select
        p.product_id,
        p.category_name,
        coalesce(t.category_name_english, p.category_name, 'unknown') as category_english_name,
        p.weight_g,
        p.length_cm,
        p.height_cm,
        p.width_cm,
        p.length_cm * p.height_cm * p.width_cm as volume_cm3,
        p.photos_count
    from products p
    left join translations t
    on p.category_name = t.category_name

)

select * from final
