-- =====================================================
-- GOLD LAYER - MÉTRICAS PERSONALIZADAS AVANZADAS
-- Queries para análisis estratégico y dashboard
-- Versión SIN granularidad temporal (agregados totales)
-- =====================================================

-- ========================================
-- 1. ROAS POR CLIENTE (SIN FECHA)
-- ========================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_roas_by_client` AS
SELECT
  dc.client_id,
  dc.client_name,
  dc.industry,
  dc.client_segment,
  SUM(f.revenue_usd) AS total_revenue,
  SUM(f.ad_spend_usd) AS total_ad_spend,
  SAFE_DIVIDE(SUM(f.revenue_usd), SUM(f.ad_spend_usd)) AS roas,
  COUNT(DISTINCT f.campaign_id) AS num_campaigns,
  COUNT(DISTINCT f.date_id) AS days_active
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_client` dc
  ON f.client_id = dc.client_id
GROUP BY dc.client_id, dc.client_name, dc.industry, dc.client_segment
ORDER BY roas DESC;


-- ========================================
-- 2. CPA POR CANAL (SIN FECHA)
-- ========================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_cpa_by_channel` AS
SELECT
  dca.channel,
  SUM(f.ad_spend_usd) AS total_ad_spend,
  SUM(f.conversions) AS total_conversions,
  SAFE_DIVIDE(SUM(f.ad_spend_usd), SUM(f.conversions)) AS cpa,
  SUM(f.clicks) AS total_clicks,
  SUM(f.impressions) AS total_impressions,
  SAFE_DIVIDE(SUM(f.clicks), SUM(f.impressions)) * 100 AS ctr
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_campaign` dca
  ON f.campaign_id = dca.campaign_id
GROUP BY dca.channel
ORDER BY cpa ASC;


-- ========================================
-- 3. PERFORMANCE POR CAMPAÑA (SIN FECHA)
-- ========================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_campaign_performance` AS
SELECT
  dca.campaign_id,
  dc.client_name,
  dca.channel,
  dca.budget_usd,
  SUM(f.revenue_usd) AS total_revenue,
  SUM(f.ad_spend_usd) AS total_ad_spend,
  SUM(f.conversions) AS total_conversions,
  SAFE_DIVIDE(SUM(f.revenue_usd), SUM(f.ad_spend_usd)) AS roas,
  SAFE_DIVIDE(SUM(f.ad_spend_usd), SUM(f.conversions)) AS cpa,
  SAFE_DIVIDE(SUM(f.conversions), SUM(f.clicks)) * 100 AS conversion_rate,
  -- Eficiencia de gasto
  SAFE_DIVIDE(SUM(f.ad_spend_usd), dca.budget_usd) * 100 AS budget_utilization
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_campaign` dca
  ON f.campaign_id = dca.campaign_id
JOIN `edibs-marketing-analytics.gold.dim_client` dc
  ON f.client_id = dc.client_id
GROUP BY dca.campaign_id, dc.client_name, dca.channel, dca.budget_usd
ORDER BY roas DESC;


-- ========================================
-- 4. REVENUE POR PRODUCTO Y CATEGORÍA
-- ========================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_product_performance` AS
SELECT
  dp.product_id,
  dp.product_name,
  dp.price_category,
  SUM(f.revenue_usd) AS total_revenue,
  COUNT(DISTINCT f.campaign_id) AS campaigns_used,
  COUNT(DISTINCT f.date_id) AS days_sold,
  AVG(f.revenue_usd) AS avg_daily_revenue
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_product` dp
  ON f.product_id = dp.product_id
GROUP BY dp.product_id, dp.product_name, dp.price_category
ORDER BY total_revenue DESC;


-- ========================================
-- 5. TENDENCIA TEMPORAL (MENSUAL)
-- ========================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_monthly_trends` AS
SELECT
  dd.year,
  dd.month,
  dd.month_name,
  SUM(f.revenue_usd) AS monthly_revenue,
  SUM(f.ad_spend_usd) AS monthly_ad_spend,
  SUM(f.conversions) AS monthly_conversions,
  SAFE_DIVIDE(SUM(f.revenue_usd), SUM(f.ad_spend_usd)) AS monthly_roas,
  COUNT(DISTINCT f.campaign_id) AS active_campaigns
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_date` dd
  ON f.date_id = dd.date_id
GROUP BY dd.year, dd.month, dd.month_name
ORDER BY dd.year, dd.month;


-- ========================================
-- 6. TOP 10 MEJORES DÍAS
-- ========================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_top_days` AS
SELECT
  f.date_id,
  dd.day_name,
  dd.is_weekend,
  SUM(f.revenue_usd) AS daily_revenue,
  SUM(f.conversions) AS daily_conversions,
  SAFE_DIVIDE(SUM(f.revenue_usd), SUM(f.ad_spend_usd)) AS daily_roas
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_date` dd
  ON f.date_id = dd.date_id
GROUP BY f.date_id, dd.day_name, dd.is_weekend
ORDER BY daily_revenue DESC
LIMIT 10;


-- ============================================
-- 7. ANÁLISIS FIN DE SEMANA vs DÍAS LABORABLES
-- ============================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_weekend_analysis` AS
SELECT
  CASE WHEN dd.is_weekend THEN 'Weekend' ELSE 'Weekday' END AS period_type,
  SUM(f.revenue_usd) AS total_revenue,
  SUM(f.ad_spend_usd) AS total_ad_spend,
  SUM(f.conversions) AS total_conversions,
  SAFE_DIVIDE(SUM(f.revenue_usd), SUM(f.ad_spend_usd)) AS roas,
  SAFE_DIVIDE(SUM(f.ad_spend_usd), SUM(f.conversions)) AS cpa,
  COUNT(DISTINCT f.date_id) AS days_count
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_date` dd
  ON f.date_id = dd.date_id
GROUP BY dd.is_weekend;


-- ========================================
-- 8. CLIENTE + CANAL (ANÁLISIS CRUZADO)
-- ========================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_client_channel_matrix` AS
SELECT
  dc.client_name,
  dca.channel,
  SUM(f.revenue_usd) AS revenue,
  SUM(f.ad_spend_usd) AS ad_spend,
  SAFE_DIVIDE(SUM(f.revenue_usd), SUM(f.ad_spend_usd)) AS roas,
  SUM(f.conversions) AS conversions
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_client` dc
  ON f.client_id = dc.client_id
JOIN `edibs-marketing-analytics.gold.dim_campaign` dca
  ON f.campaign_id = dca.campaign_id
GROUP BY dc.client_name, dca.channel
ORDER BY dc.client_name, roas DESC;


-- =====================================================
-- 9. ROAS POR CANAL (SIN FECHA)
-- =====================================================
CREATE OR REPLACE VIEW `edibs-marketing-analytics.gold.v_roas_by_channel` AS
SELECT
  dca.channel,
  SUM(f.revenue_usd) AS total_revenue,
  SUM(f.ad_spend_usd) AS total_ad_spend,
  SUM(f.conversions) AS total_conversions,
  SUM(f.clicks) AS total_clicks,
  SUM(f.impressions) AS total_impressions,
  -- Métricas calculadas
  SAFE_DIVIDE(SUM(f.revenue_usd), SUM(f.ad_spend_usd)) AS roas,
  SAFE_DIVIDE(SUM(f.ad_spend_usd), SUM(f.conversions)) AS cpa,
  SAFE_DIVIDE(SUM(f.clicks), SUM(f.impressions)) * 100 AS ctr
FROM `edibs-marketing-analytics.gold.fact_marketing_performance` f
JOIN `edibs-marketing-analytics.gold.dim_campaign` dca
  ON f.campaign_id = dca.campaign_id
GROUP BY dca.channel
ORDER BY roas DESC;