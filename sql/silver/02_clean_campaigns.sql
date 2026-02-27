-- =====================================================
-- SILVER LAYER - CAMPAÑAS VALIDADAS
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.silver.campaigns` AS
SELECT
  campaign_id,
  client_id,
  TRIM(LOWER(channel)) AS channel,  -- Normalizar a minúsculas
  budget_usd,
  start_date,
  end_date,
  DATE_DIFF(end_date, start_date, DAY) AS duration_days,
  -- Validar que end_date >= start_date
  CASE 
    WHEN end_date >= start_date THEN TRUE 
    ELSE FALSE 
  END AS is_valid_date_range
FROM `edibs-marketing-analytics.bronze.campaigns`
WHERE campaign_id IS NOT NULL
  AND client_id IS NOT NULL
  AND budget_usd >= 0  -- Eliminar presupuestos negativos
  AND end_date >= start_date;  -- Solo campañas con fechas válidas