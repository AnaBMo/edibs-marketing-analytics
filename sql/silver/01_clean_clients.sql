-- =====================================================
-- SILVER LAYER - CLIENTES VALIDADOS Y NORMALIZADOS
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.silver.clients` AS
SELECT
  client_id,
  TRIM(UPPER(client_name)) AS client_name,  -- Normalizar a mayúsculas
  TRIM(industry) AS industry,
  monthly_retainer_usd,
  -- Clasificación de clientes por retainer
  CASE 
    WHEN monthly_retainer_usd >= 10000 THEN 'Enterprise'
    WHEN monthly_retainer_usd >= 5000 THEN 'Mid-Market'
    ELSE 'SMB'
  END AS client_segment
FROM `edibs-marketing-analytics.bronze.clients`
WHERE client_id IS NOT NULL
  AND client_name IS NOT NULL;