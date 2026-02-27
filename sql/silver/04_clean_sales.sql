-- =====================================================
-- SILVER LAYER - VENTAS VALIDADAS Y ENRIQUECIDAS
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.silver.sales` AS
SELECT
  s.campaign_id,
  s.date,
  s.product_id,
  s.revenue_usd,
  -- Validar integridad referencial
  CASE 
    WHEN c.campaign_id IS NOT NULL THEN TRUE 
    ELSE FALSE 
  END AS has_valid_campaign,
  CASE 
    WHEN p.product_id IS NOT NULL THEN TRUE 
    ELSE FALSE 
  END AS has_valid_product,
  -- Enriquecer con info de fecha
  EXTRACT(DAYOFWEEK FROM s.date) AS day_of_week,
  CASE 
    WHEN EXTRACT(DAYOFWEEK FROM s.date) IN (1, 7) THEN TRUE 
    ELSE FALSE 
  END AS is_weekend
FROM `edibs-marketing-analytics.bronze.sales` s
LEFT JOIN `edibs-marketing-analytics.bronze.campaigns` c
  ON s.campaign_id = c.campaign_id
LEFT JOIN `edibs-marketing-analytics.bronze.products` p
  ON s.product_id = p.product_id
WHERE s.campaign_id IS NOT NULL
  AND s.product_id IS NOT NULL
  AND s.date IS NOT NULL
  AND s.revenue_usd >= 0  -- Eliminar revenue negativo
  AND c.campaign_id IS NOT NULL  -- Solo ventas con campañas válidas
  AND p.product_id IS NOT NULL;  -- Solo ventas con productos válidos