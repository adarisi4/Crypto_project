{{ config(materialized='table') }}

WITH base AS (
    SELECT
        id,
        name,
        symbol,
        quote_usd_price,
        quote_usd_percent_change_1h,
        quote_usd_percent_change_24h,
        quote_usd_percent_change_7d,
        quote_usd_percent_change_30d,
        quote_usd_percent_change_60d,
        quote_usd_percent_change_90d
    FROM {{ ref('stg_crypto_prices') }}
),

price_movement AS (
    SELECT *,
        CASE
            WHEN quote_usd_percent_change_24h >= 3 AND quote_usd_percent_change_7d >= 3 THEN 'Very Bullish'
            WHEN quote_usd_percent_change_24h >= 3 AND quote_usd_percent_change_7d BETWEEN 0 AND 2.99 THEN 'Bullish'
            WHEN quote_usd_percent_change_24h <= -3 AND quote_usd_percent_change_7d <= -3 THEN 'Very Bearish'
            WHEN quote_usd_percent_change_24h BETWEEN 0 AND 2.99 AND quote_usd_percent_change_7d > -3 THEN 'Bearish'
            ELSE 'Stagnant'
        END AS price_sentiment
    FROM base
),

price_ranking AS (
    SELECT *,
        CASE
            WHEN quote_usd_price >= 1000 THEN 'Premium'
            WHEN quote_usd_price BETWEEN 100 AND 999.99 THEN 'Medium'
            WHEN quote_usd_price < 100 THEN 'Low'
            ELSE 'Unsure'
        END AS price_ranking
    FROM base
),

price_volatility AS (
    SELECT *,
        ABS(quote_usd_percent_change_90d - quote_usd_percent_change_1h) AS price_volatility
    FROM base
)

SELECT 
    b.id,
    b.name,
    b.symbol,
    b.quote_usd_price,
    b.quote_usd_percent_change_1h,
    b.quote_usd_percent_change_24h,
    b.quote_usd_percent_change_7d,
    b.quote_usd_percent_change_30d,
    b.quote_usd_percent_change_60d,
    b.quote_usd_percent_change_90d,
    pm.price_sentiment,
    pr.price_ranking,
    pv.price_volatility
FROM base AS b
LEFT JOIN price_movement AS pm ON b.id = pm.id
LEFT JOIN price_ranking AS pr ON b.id = pr.id
LEFT JOIN price_volatility AS pv ON b.id = pv.id



