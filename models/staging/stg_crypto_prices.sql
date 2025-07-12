{{ 
config(materialized='view') 
}}

SELECT c.ID, c.NAME, c.symbol, c.quote_usd_price, c.quote_usd_percent_change_1h, 
c.quote_usd_percent_change_24h, c.quote_usd_percent_change_7d,
c.quote_usd_percent_change_30d, c.quote_usd_percent_change_60d,
c.quote_usd_percent_change_90d
FROM {{ source('crypto_schema', 'crypto_snapshot') }} as c




