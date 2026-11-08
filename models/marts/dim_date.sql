with

date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2016-01-01' as date)",
        end_date="cast('2019-01-01' as date)"
    ) }}

),

final as (

    select
        cast(date_day as date) as date_day,
        year(date_day) as year,
        quarter(date_day) as quarter,
        month(date_day) as month,
        monthname(date_day) as month_name,
        dayofweekiso(date_day) as day_of_week,
        dayname(date_day) as day_name,
        dayofweekiso(date_day) in (6, 7) as is_weekend

    from date_spine

)

select * from final