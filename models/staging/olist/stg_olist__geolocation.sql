with 

source as (

    select * from {{ source('olist', 'geolocation') }}

),

renamed as (

    select
        geolocation_zip_code_prefix as zip_code_prefix,
        cast(geolocation_lat as float) as latitude,
        cast(geolocation_lng as float) as longitude,
        geolocation_city as city,
        geolocation_state as state,
        _source_file,
        _loaded_at

    from source

)

select * from renamed