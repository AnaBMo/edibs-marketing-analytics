-- =====================================================
-- GOLD LAYER - DIMENSIÓN DE CAMPAÑAS
-- Lee desde Silver (datos validados)
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.gold.dim_campaign` AS
SELECT
  campaign_id,
  client_id,
  channel,
  budget_usd,
  start_date,
  end_date,
  duration_days  -- Campo calculado en Silver
FROM `edibs-marketing-analytics.silver.campaigns`;