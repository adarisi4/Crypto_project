{{ config(materialized='table') }}

WITH base AS (
    SELECT 
        c.id,
        c.name,
        c.symbol,
        TRY_CAST(c.max_supply AS FLOAT) AS max_supply,
        TRY_CAST(c.circulating_supply AS FLOAT) AS circulating_supply,
        TRY_CAST(c.total_supply AS FLOAT) AS total_supply,
        c.infinite_supply
    FROM {{ ref('stg_crypto_supply') }} as c 
),
scarcity as
(SELECT *, 
 CASE
  WHEN max_supply < 1000000 THEN 'Very Scarce'
  WHEN max_supply BETWEEN 1000000 AND 100000000 THEN 'Scarce'
  WHEN max_supply BETWEEN 100000000 AND 1000000000 THEN 'Moderate'
  WHEN max_supply > 1000000000 THEN 'Abundant'
  ELSE 'Undefined'
END AS scarcity_level
FROM base
 ),
 supply_level as (
    SELECT *,
    CASE
  WHEN infinite_supply = TRUE THEN 'Uncapped'
  WHEN infinite_supply = FALSE THEN 'Capped'
  ELSE 'Unknown'
END AS supply_cap_type
    FROM base
 ),
circulation_ratio as (
SELECT *, 
    circulating_supply/NULLIF(total_supply,0) * 100 as circulation_supply
    FROM base
)
    SELECT b.id,b.name,b.symbol,b.max_supply,b.circulating_supply,b.total_supply,b.infinite_supply, 
    sc.supply_cap_type, sl.scarcity_level, cr.circulation_supply
    FROM base as b
    LEFT JOIN supply_level as sc ON sc.id = b.id
    LEFT JOIN scarcity as sl ON sl.id = b.id
    LEFT JOIN circulation_ratio as cr ON cr.id = b.id
    
    
