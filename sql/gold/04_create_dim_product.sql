-- =====================================================
-- GOLD LAYER - DIMENSIÓN DE PRODUCTOS
-- Lee desde Silver (datos validados)
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.gold.dim_product` AS
SELECT
  product_id,
  product_name,
  price_usd,
  price_category  -- Campo enriquecido desde Silver
FROM `edibs-marketing-analytics.silver.products`;