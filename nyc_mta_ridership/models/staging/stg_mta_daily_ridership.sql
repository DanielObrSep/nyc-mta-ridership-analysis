WITH renamed AS (
    SELECT
        CAST(date AS DATE) AS date,
        CAST(subways_total_estimated_ridership AS INTEGER) AS subways_total_estimated_ridership,
        CAST("subways_%_of_comparable_pre_pandemic_day" AS FLOAT) / 100 AS subways_pct_of_pre_pandemic,
        CAST(buses_total_estimated_ridership AS INTEGER) AS buses_total_estimated_ridership,
        CAST("buses_%_of_comparable_pre_pandemic_day" AS FLOAT) / 100 AS buses_pct_of_pre_pandemic,
        CAST(lirr_total_estimated_ridership AS INTEGER) AS lirr_total_estimated_ridership,
        CAST("lirr_%_of_comparable_pre_pandemic_day" AS FLOAT) / 100 AS lirr_pct_of_pre_pandemic,
        CAST(metro_north_total_estimated_ridership AS INTEGER) AS metro_north_total_estimated_ridership,
        CAST("metro_north_%_of_comparable_pre_pandemic_day" AS FLOAT) / 100 AS metro_north_pct_of_pre_pandemic,
        CAST(access_a_ride_total_scheduled_trips AS INTEGER) AS access_a_ride_total_scheduled_trips,
        CAST("access_a_ride_%_of_comparable_pre_pandemic_day" AS FLOAT) / 100 AS access_a_ride_pct_of_pre_pandemic,
        CAST(bridges_and_tunnels_total_traffic AS INTEGER) AS bridges_and_tunnels_total_traffic,
        CAST("bridges_and_tunnels_%_of_comparable_pre_pandemic_day" AS FLOAT) / 100 AS bridges_and_tunnels_pct_of_pre_pandemic,
        CAST(staten_island_railway_total_estimated_ridership AS INTEGER) AS staten_island_railway_total_estimated_ridership,
        CAST("staten_island_railway_%_of_comparable_pre_pandemic_day" AS FLOAT) / 100 AS staten_island_railway_pct_of_pre_pandemic,
        CAST(weekday AS INTEGER) AS weekday,
        CAST(is_weekend AS BOOLEAN) AS is_weekend,
        CAST(total_ridership AS INTEGER) AS total_ridership,
        (
            CAST(total_ridership AS FLOAT) /
            NULLIF((
                subways_total_estimated_ridership / NULLIF(subways_pct_of_pre_pandemic, 0)
                + buses_total_estimated_ridership / NULLIF(buses_pct_of_pre_pandemic, 0)
                + lirr_total_estimated_ridership / NULLIF(lirr_pct_of_pre_pandemic, 0)
                + metro_north_total_estimated_ridership / NULLIF(metro_north_pct_of_pre_pandemic, 0)
                + access_a_ride_total_scheduled_trips / NULLIF(access_a_ride_pct_of_pre_pandemic, 0)
                + bridges_and_tunnels_total_traffic / NULLIF(bridges_and_tunnels_pct_of_pre_pandemic, 0)
                + staten_island_railway_total_estimated_ridership / NULLIF(staten_island_railway_pct_of_pre_pandemic, 0)
            ), 0)
        ) AS pct_change_vs_2019,
        CAST(outlier AS BOOLEAN) AS outlier
    FROM {{ ref('mta_daily_ridership') }}
)

SELECT * FROM renamed
