select
    extract(year  from date) as year,
    extract(month from date) as month,
    sum(subways_total_estimated_ridership) as sum_subways_total_estimated_ridership,
    sum(buses_total_estimated_ridership) as sum_buses_total_estimated_ridership,
    sum(lirr_total_estimated_ridership) as sum_lirr_total_estimated_ridership,
    sum(metro_north_total_estimated_ridership) as sum_metro_north_total_estimated_ridership,
    sum(access_a_ride_total_scheduled_trips) as sum_access_a_ride_total_scheduled_trips,
    sum(bridges_and_tunnels_total_traffic) as sum_bridges_and_tunnels_total_traffic,
    sum(staten_island_railway_total_estimated_ridership) as sum_staten_island_railway_total_estimated_ridership,
    avg(subways_pct_of_pre_pandemic) as avg_subways_pct_of_pre_pandemic,
    avg(buses_pct_of_pre_pandemic) as avg_buses_pct_of_pre_pandemic,
    avg(lirr_pct_of_pre_pandemic) as avg_lirr_pct_of_pre_pandemic,
    avg(metro_north_pct_of_pre_pandemic) as avg_metro_north_pct_of_pre_pandemic,
    avg(access_a_ride_pct_of_pre_pandemic) as avg_access_a_ride_pct_of_pre_pandemic,
    avg(bridges_and_tunnels_pct_of_pre_pandemic) as avg_bridges_and_tunnels_pct_of_pre_pandemic,
    avg(staten_island_railway_pct_of_pre_pandemic) as avg_staten_island_railway_pct_of_pre_pandemic
from {{ ref('stg_mta_daily_ridership') }}
group by 1,2
order by 1,2

