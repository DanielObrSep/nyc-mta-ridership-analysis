{{ config(materialized='table') }}

SELECT
    date,
    service,
    SUM(total_ridership) AS total_ridership
FROM {{ ref('stg_mta_daily_ridership_long') }}
GROUP BY
    date,
    service
ORDER BY
    date,
    service
