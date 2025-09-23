with base as (
  select * from {{ ref('clean_mta_daily_ridership') }}
)

select
  cast(date as date) as date,

  cast(subways_total_estimated_ridership as integer) as subways_total_estimated_ridership,
  cast("subways_%_of_comparable_pre_pandemic_day" as integer) as subways_pct_of_pre_pandemic,

  cast(buses_total_estimated_ridership as integer) as buses_total_estimated_ridership,
  cast("buses_%_of_comparable_pre_pandemic_day" as integer) as buses_pct_of_pre_pandemic,

  cast(lirr_total_estimated_ridership as integer) as lirr_total_estimated_ridership,
  cast("lirr_%_of_comparable_pre_pandemic_day" as integer) as lirr_pct_of_pre_pandemic,

  cast(metro_north_total_estimated_ridership as integer) as metro_north_total_estimated_ridership,
  cast("metro_north_%_of_comparable_pre_pandemic_day" as integer) as metro_north_pct_of_pre_pandemic,

  cast(access_a_ride_total_scheduled_trips as integer) as access_a_ride_total_scheduled_trips,
  cast("access_a_ride_%_of_comparable_pre_pandemic_day" as integer) as access_a_ride_pct_of_pre_pandemic,

  cast(bridges_and_tunnels_total_traffic as integer) as bridges_and_tunnels_total_traffic,
  cast("bridges_and_tunnels_%_of_comparable_pre_pandemic_day" as integer) as bridges_and_tunnels_pct_of_pre_pandemic,

  cast(staten_island_railway_total_estimated_ridership as integer) as staten_island_railway_total_estimated_ridership,
  cast("staten_island_railway_%_of_comparable_pre_pandemic_day" as integer) as staten_island_railway_pct_of_pre_pandemic
from base
