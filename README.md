# ₿ crypto-data-models

This **dbt project models cryptocurrency data** for real-time analytics, supporting dashboards that track price volatility, sentiment, dominance, scarcity, and other metrics across major tokens.

---

## 💼 Business Goal

**How can we segment and monitor cryptocurrencies based on market cap tier, dilution risk, volatility, and sentiment — to help investors understand trends and asset behavior over time?**

To answer this, I built a data pipeline that collects, cleans, models, and visualizes crypto asset data as of **July 3rd, 2025**, powering a full suite of Tableau dashboards for interactive exploration.

---

## 🔍 Overview of What I Built

- 🧩 A modular dbt project (staging → intermediate → mart) that transforms raw crypto data into analytics-ready Snowflake tables
- ⚙️ Python script to retrieve data via **CoinMarketCap’s public API** (as of July 3, 2025)
- ☁️ Data ingestion pipeline triggered using **AWS EventBridge**, storing the CSV in S3 and transforming it via Snowflake external stages
- 🔁 dbt models to calculate:
  - Token scarcity
  - Market cap tiering
  - Circulating vs max supply
  - Volatility metrics
  - Sentiment classification
- 📊 Tableau dashboards for business users to explore asset trends, compare coins, and understand market dynamics

---

## 📁 Project Layers

### ✅ Staging Layer
- Cleans column names and types from the CoinMarketCap API response
- Filters out irrelevant tokens (e.g. zero volume, missing price)

### ✅ Intermediate Layer
- Computes volatility bands, dilution ratios, and supply metrics
- Creates ranking fields (e.g. by price, market cap, dominance)

### ✅ Mart Layer
- Final `fact_crypto_assets` table joins all enriched features for dashboarding

---

## 📊 Tableau Dashboards

Explore the live dashboards built using the final mart model:

- [Circulation Supply](https://public.tableau.com/app/profile/anubhav7730/viz/Crypto_Data_17519483916090/Circulation_Supply?publish=yes)
- [Price Volatility](https://public.tableau.com/app/profile/anubhav7730/viz/Crypto_Data_17519483916090/PriceVolatility?publish=yes)
- [Daily Price Change](https://public.tableau.com/app/profile/anubhav7730/viz/Crypto_Data_17519483916090/Price_change_Per_Day?publish=yes)
- [Scarcity Level](https://public.tableau.com/app/profile/anubhav7730/viz/Crypto_Data_17519483916090/Scarcity_Level?publish=yes)
- [Dominance Category](https://public.tableau.com/app/profile/anubhav7730/viz/Crypto_Data_17519483916090/Dominance_Category?publish=yes)
- [Price Sentiment](https://public.tableau.com/app/profile/anubhav7730/viz/Crypto_Data_17519483916090/Price_Sentiment)
- [Market Cap Tier](https://public.tableau.com/app/profile/anubhav7730/viz/Crypto_Data_17519483916090/Market_Cap_Tier)
- [Dilution Rat]()
