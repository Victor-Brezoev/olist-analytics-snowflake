with 

source as (

    select * from {{ source('olist', 'customers') }}

),

renamed as (

    select
        customer_id,
        sha2(customer_unique_id, 256) as customer_unique_id_hash,
        customer_zip_code_prefix as zip_code_prefix,
        customer_city as city,
        customer_state as state,
        _source_file,
        _loaded_at

    from source

)

select * from renamed