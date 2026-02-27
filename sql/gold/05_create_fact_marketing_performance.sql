-- =====================================================
-- GOLD LAYER - TABLA DE HECHOS
-- Combina datos de ventas y publicidad desde Silver
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.gold.fact_marketing_performance` AS
WITH sales_agg AS (
  SELECT
    campaign_id,
    date,
    product_id,
    SUM(revenue_usd) AS revenue_usd
  FROM `edibs-marketing-analytics.silver.sales`
  GROUP BY campaign_id, date, product_id
),
ads_agg AS (
  SELECT
    campaign_id,
    date,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    SUM(ad_spend_usd) AS ad_spend_usd
  FROM `edibs-marketing-analytics.silver.ads_daily`
  GROUP BY campaign_id, date
),
combined AS (
  SELECT
    COALESCE(s.campaign_id, a.campaign_id) AS campaign_id,
    COALESCE(s.date, a.date) AS date_id,
    s.product_id,
    c.client_id,
    COALESCE(s.revenue_usd, 0) AS revenue_usd,
    COALESCE(a.impressions, 0) AS impressions,
    COALESCE(a.clicks, 0) AS clicks,
    COALESCE(a.conversions, 0) AS conversions,
    COALESCE(a.ad_spend_usd, 0) AS ad_spend_usd
  FROM sales_agg s
  FULL OUTER JOIN ads_agg a
    ON s.campaign_id = a.campaign_id 
    AND s.date = a.date
  LEFT JOIN `edibs-marketing-analytics.silver.campaigns` c
    ON COALESCE(s.campaign_id, a.campaign_id) = c.campaign_id
)
SELECT
  campaign_id,
  date_id,
  product_id,
  client_id,
  
  -- Métricas base
  revenue_usd,
  impressions,
  clicks,
  conversions,
  ad_spend_usd,
  
  -- Métricas calculadas básicas
  SAFE_DIVIDE(revenue_usd, ad_spend_usd) AS roas,
  SAFE_DIVIDE(ad_spend_usd, conversions) AS cpa,
  SAFE_DIVIDE(conversions, clicks) * 100 AS conversion_rate,
  SAFE_DIVIDE(clicks, impressions) * 100 AS ctr,
  SAFE_DIVIDE(revenue_usd, clicks) AS revenue_per_click
  
FROM combined
WHERE campaign_id IS NOT NULL 
  AND date_id IS NOT NULL;