-- =====================================================
-- GOLD LAYER - DIMENSIÓN DE CLIENTES
-- Lee desde Silver (datos validados y normalizados)
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.gold.dim_client` AS
SELECT
  client_id,
  client_name,
  industry,
  monthly_retainer_usd,
  client_segment  -- Campo enriquecido desde Silver
FROM `edibs-marketing-analytics.silver.clients`;