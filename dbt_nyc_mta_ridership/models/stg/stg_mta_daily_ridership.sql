with base as (Select * FROM {{ref('mta_daily_ridership')}} )

Select
    CAST(date as Date) as date,

    CAST(subways_total_estimated_ridership as integer) as subways_total_estimated_ridership,
    CAST("subways_%_of_comparable_pre_pandemic_day" as float) as subways_pct_of_pre_pandemic,

    CAST(buses_total_estimated_ridership as integer) AS buses_total_estimated_ridership,
    CAST("buses_%_of_comparable_pre_pandemic_day" as float) as buses_pct_of_pre_pandemic,

    CAST(lirr_total_estimated_ridership as integer) AS lirr_total_estimated_ridership,
    CAST("lirr_%_of_comparable_pre_pandemic_day" as float) as lirr_pct_of_pre_pandemic,

    CAST(metro_north_total_estimated_ridership as integer) as metro_north_total_estimated_ridership,
    CAST("metro_north_%_of_comparable_pre_pandemic_day" as float) as metro_north_pct_of_pre_pandemic,

    CAST(access_a_ride_total_scheduled_trips as integer) as access_a_ride_total_scheduled_trips,
    CAST("access_a_ride_%_of_comparable_pre_pandemic_day" as float) as access_a_ride_pct_of_pre_pandemic,

    CAST(bridges_and_tunnels_total_traffic as integer) as bridges_and_tunnels_total_traffic,
    CAST("bridges_and_tunnels_%_of_comparable_pre_pandemic_day" as float) as bridges_and_tunnels_pct_of_pre_pandemic,

    CAST(staten_island_railway_total_estimated_ridership as integer) AS staten_island_railway_total_estimated_ridership,
    CAST("staten_island_railway_%_of_comparable_pre_pandemic_day" as float)  as staten_island_railway_pct_of_pre_pandemic

FROM base

