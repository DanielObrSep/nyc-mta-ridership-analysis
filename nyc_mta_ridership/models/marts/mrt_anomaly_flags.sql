{{ config(materialized='table') }}

WITH stats AS (
    SELECT
        service,
        AVG(total_ridership) AS avg_ridership,
        STDDEV(total_ridership) AS stdev_ridership
    FROM {{ ref('stg_mta_daily_ridership_long') }}
    GROUP BY service
)

SELECT
    d.date,
    d.service,
    d.total_ridership,
    s.avg_ridership,
    s.stdev_ridership,
    CASE
        WHEN ABS(d.total_ridership - s.avg_ridership) > 3 * s.stdev_ridership THEN TRUE
        ELSE FALSE
    END AS is_outlier
FROM {{ ref('stg_mta_daily_ridership_long') }} d
JOIN stats s ON d.service = s.service

