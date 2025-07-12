{{ config(materialized='view') }}

WITH base AS (
    SELECT *
    FROM {{ ref('stg_crypto_market_metrics') }}
),

cap_size AS (
    SELECT *,
        CASE
            WHEN TRY_CAST(quote_usd_market_cap AS FLOAT) >= 10000000000 THEN 'Mega Cap'
            WHEN TRY_CAST(quote_usd_market_cap AS FLOAT) BETWEEN 1000000000 AND 9999999999 THEN 'Large Cap'
            WHEN TRY_CAST(quote_usd_market_cap AS FLOAT) BETWEEN 100000000 AND 999999999 THEN 'Mid Cap'
            WHEN TRY_CAST(quote_usd_market_cap AS FLOAT) BETWEEN 10000000 AND 99999999 THEN 'Small Cap'
            ELSE 'Micro Cap'
        END AS market_cap_tier
    FROM base
),

market_dominance AS (
    SELECT *,
        CASE
            WHEN quote_usd_market_cap_dominance >= 10 THEN 'Dominant'
            WHEN quote_usd_market_cap_dominance BETWEEN 1 AND 9.99 THEN 'Established'
            WHEN quote_usd_market_cap_dominance BETWEEN 0.1 AND 0.99 THEN 'Niche'
            ELSE 'Negligible'
        END AS dominance_category
    FROM base
),  

dilution_risk AS (
    SELECT *,
        TRY_CAST(quote_usd_market_cap AS FLOAT) 
        / NULLIF(TRY_CAST(quote_usd_fully_diluted_market_cap AS FLOAT), 0) AS dilution_ratio
    FROM base
)

SELECT 
    b.id,
    b.name,
    b.symbol,
    b.cmc_rank,
    b.quote_usd_market_cap,
    b.quote_usd_market_cap_dominance,
    b.quote_usd_fully_diluted_market_cap,
    cs.market_cap_tier,
    md.dominance_category,
    dr.dilution_ratio

FROM base AS b
LEFT JOIN cap_size AS cs ON cs.id = b.id
LEFT JOIN market_dominance AS md ON md.id = b.id
LEFT JOIN dilution_risk AS dr ON dr.id = b.id
