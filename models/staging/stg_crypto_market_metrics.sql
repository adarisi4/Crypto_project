{{ 
config(materialized='view') 
}}

SELECT c.id, c.name, c.symbol, c.cmc_rank, c.quote_usd_market_cap, c.quote_usd_market_cap_dominance,
c.quote_usd_fully_diluted_market_cap
FROM {{ source('crypto_schema', 'crypto_snapshot') }} as c
ORDER BY c.cmc_rank asc




