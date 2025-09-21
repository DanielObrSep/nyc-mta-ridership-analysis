-- models/mrt/mrt_kpi.sql

with base as (
  select
    subways_total_estimated_ridership,
    buses_total_estimated_ridership,
    lirr_total_estimated_ridership,
    metro_north_total_estimated_ridership,
    access_a_ride_total_scheduled_trips,
    bridges_and_tunnels_total_traffic,
    staten_island_railway_total_estimated_ridership,

    subways_pct_of_pre_pandemic,
    buses_pct_of_pre_pandemic,
    lirr_pct_of_pre_pandemic,
    metro_north_pct_of_pre_pandemic,
    access_a_ride_pct_of_pre_pandemic,
    bridges_and_tunnels_pct_of_pre_pandemic,
    staten_island_railway_pct_of_pre_pandemic
  from {{ ref('stg_mta_daily_ridership') }}
)

select

  sum(subways_total_estimated_ridership) as total_subway_ridership,
  sum(buses_total_estimated_ridership) as buses_total_estimated_ridership,
  sum(lirr_total_estimated_ridership) as lirr_total_estimated_ridership,
  sum(metro_north_total_estimated_ridership) as metro_north_total_estimated_ridership,
  sum(access_a_ride_total_scheduled_trips) as access_a_ride_total_scheduled_trips,
  sum(bridges_and_tunnels_total_traffic) as bridges_and_tunnels_total_traffic,
  sum(staten_island_railway_total_estimated_ridership) as staten_island_railway_total_estimated_ridership,

  sum(subways_total_estimated_ridership) as sum_subways_total_estimated_ridership,
  sum(buses_total_estimated_ridership) as sum_buses_total_estimated_ridership,
  sum(lirr_total_estimated_ridership) as sum_lirr_total_estimated_ridership,
  sum(metro_north_total_estimated_ridership) as sum_metro_north_total_estimated_ridership,
  sum(access_a_ride_total_scheduled_trips) as sum_access_a_ride_total_scheduled_trips,
  sum(bridges_and_tunnels_total_traffic) as sum_bridges_and_tunnels_total_traffic,
  sum(staten_island_railway_total_estimated_ridership) as sum_staten_island_railway_total_estimated_ridership,

  sum(
      coalesce(subways_total_estimated_ridership,0)
    + coalesce(buses_total_estimated_ridership,0)
    + coalesce(lirr_total_estimated_ridership,0)
    + coalesce(metro_north_total_estimated_ridership,0)
    + coalesce(access_a_ride_total_scheduled_trips,0)
    + coalesce(bridges_and_tunnels_total_traffic,0)
    + coalesce(staten_island_railway_total_estimated_ridership,0)
  ) as sum_total_rides,

  avg(subways_pct_of_pre_pandemic) as avg_subways_pct_of_pre_pandemic,
  avg(buses_pct_of_pre_pandemic) as avg_buses_pct_of_pre_pandemic,
  avg(lirr_pct_of_pre_pandemic) as avg_lirr_pct_of_pre_pandemic,
  avg(metro_north_pct_of_pre_pandemic) as avg_metro_north_pct_of_pre_pandemic,
  avg(access_a_ride_pct_of_pre_pandemic) as avg_access_a_ride_pct_of_pre_pandemic,
  avg(bridges_and_tunnels_pct_of_pre_pandemic) as avg_bridges_and_tunnels_pct_of_pre_pandemic,
  avg(staten_island_railway_pct_of_pre_pandemic) as avg_staten_island_railway_pct_of_pre_pandemic,
  avg((
      coalesce(subways_pct_of_pre_pandemic,0)
    + coalesce(buses_pct_of_pre_pandemic,0)
    + coalesce(lirr_pct_of_pre_pandemic,0)
    + coalesce(metro_north_pct_of_pre_pandemic,0)
    + coalesce(access_a_ride_pct_of_pre_pandemic,0)
    + coalesce(bridges_and_tunnels_pct_of_pre_pandemic,0)
    + coalesce(staten_island_railway_pct_of_pre_pandemic,0)
  ) / 7.0) as avg_total_pct_of_pre_pandemic

from base
