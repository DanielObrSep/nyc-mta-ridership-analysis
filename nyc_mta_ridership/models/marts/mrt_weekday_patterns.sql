{{ config(materialized='table') }}

SELECT
    weekday,
    service,
    AVG(total_ridership) AS avg_ridership,
    CASE weekday
        WHEN 0 THEN 'Monday'
        WHEN 1 THEN 'Tuesday'
        WHEN 2 THEN 'Wednesday'
        WHEN 3 THEN 'Thursday'
        WHEN 4 THEN 'Friday'
        WHEN 5 THEN 'Saturday'
        WHEN 6 THEN 'Sunday'
    END AS weekday_name

FROM {{ ref('stg_mta_daily_ridership_long') }}
GROUP BY
    weekday,
    service
ORDER BY
    weekday,
    service