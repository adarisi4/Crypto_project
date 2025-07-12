{{ config(materialized='table') }}

WITH prices AS (
    SELECT * FROM {{ ref('dim_prices') }}
),
supply AS (
    SELECT * FROM {{ ref('dim_supply') }}
),
market AS (
    SELECT * FROM {{ ref('dim_market_metrics') }}
)

SELECT 
    p.id,
    p.name,
    p.symbol,

    -- Price Metrics
    p.quote_usd_price,
    p.quote_usd_percent_change_1h,
    p.quote_usd_percent_change_24h,
    p.quote_usd_percent_change_7d,
    p.price_sentiment,
    p.price_ranking,
    p.price_volatility,

    -- Supply Metrics
    s.max_supply,
    s.total_supply,
    s.circulating_supply,
    s.infinite_supply,
    s.supply_cap_type,
    s.scarcity_level,
    s.circulation_supply,

    -- Market Metrics
    m.cmc_rank,
    m.quote_usd_market_cap,
    m.quote_usd_market_cap_dominance,
    m.quote_usd_fully_diluted_market_cap,
    m.market_cap_tier,
    m.dominance_category,
    m.dilution_ratio

FROM prices p
LEFT JOIN supply s ON p.id = s.id
LEFT JOIN market m ON p.id = m.id
