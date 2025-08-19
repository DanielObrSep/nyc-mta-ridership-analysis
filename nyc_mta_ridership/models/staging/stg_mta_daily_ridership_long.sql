{{ config(materialized='table') }}

WITH base AS (
    SELECT *
    FROM {{ ref('stg_mta_daily_ridership') }}
)

SELECT
    date,
    'subway' AS service,
    subways_total_estimated_ridership AS total_ridership,
    weekday,
    is_weekend,
    pct_change_vs_2019,
    outlier
FROM base

UNION ALL

SELECT
    date,
    'bus' AS service,
    buses_total_estimated_ridership AS total_ridership,
    weekday,
    is_weekend,
    pct_change_vs_2019,
    outlier
FROM base

UNION ALL

SELECT
    date,
    'lirr' AS service,
    lirr_total_estimated_ridership AS total_ridership,
    weekday,
    is_weekend,
    pct_change_vs_2019,
    outlier
FROM base

UNION ALL

SELECT
    date,
    'metro_north' AS service,
    metro_north_total_estimated_ridership AS total_ridership,
    weekday,
    is_weekend,
    pct_change_vs_2019,
    outlier
FROM base

UNION ALL

SELECT
    date,
    'access_a_ride' AS service,
    access_a_ride_total_scheduled_trips AS total_ridership,
    weekday,
    is_weekend,
    pct_change_vs_2019,
    outlier
FROM base

UNION ALL

SELECT
    date,
    'bridges_and_tunnels' AS service,
    bridges_and_tunnels_total_traffic AS total_ridership,
    weekday,
    is_weekend,
    pct_change_vs_2019,
    outlier
FROM base

UNION ALL

SELECT
    date,
    'staten_island_railway' AS service,
    staten_island_railway_total_estimated_ridership AS total_ridership,
    weekday,
    is_weekend,
    pct_change_vs_2019,
    outlier
FROM base
