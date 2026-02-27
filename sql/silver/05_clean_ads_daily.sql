-- =====================================================
-- SILVER LAYER - DATOS DE ADS VALIDADOS
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.silver.ads_daily` AS
SELECT
  campaign_id,
  date,
  impressions,
  clicks,
  conversions,
  ad_spend_usd,
  -- Validaciones de lógica de negocio
  CASE 
    WHEN clicks > impressions THEN FALSE  -- Clicks no pueden > impressions
    WHEN conversions > clicks THEN FALSE   -- Conversions no pueden > clicks
    ELSE TRUE 
  END AS is_logically_valid,
  -- Detectar anomalías
  CASE 
    WHEN clicks = 0 AND conversions > 0 THEN TRUE 
    ELSE FALSE 
  END AS has_conversions_without_clicks
FROM `edibs-marketing-analytics.bronze.ads_daily`
WHERE campaign_id IS NOT NULL
  AND date IS NOT NULL
  AND impressions >= 0
  AND clicks >= 0
  AND conversions >= 0
  AND ad_spend_usd >= 0
  AND clicks <= impressions  -- Validación lógica
  AND conversions <= clicks;  -- Validación lógica