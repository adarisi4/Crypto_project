{{ 
config(materialized='view') 
}}

SELECT c.id, c.name, c.symbol, c.MAX_SUPPLY, c.CIRCULATING_SUPPLY, 
c.TOTAL_SUPPLY, c.INFINITE_SUPPLY
FROM {{ source('crypto_schema', 'crypto_snapshot') }} as c




