{{ config(materialized='table') }}

SELECT
    date_trunc('month', date) AS month,
    service,
    SUM(total_ridership) AS total_ridership
FROM {{ ref('stg_mta_daily_ridership_long') }}
GROUP BY
    month,
    service
ORDER BY
    month,
    service
