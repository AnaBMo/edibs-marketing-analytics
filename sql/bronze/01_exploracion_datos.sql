-- =====================================================
-- EXPLORACIÓN DE DATOS - BRONZE LAYER
-- Análisis de estructura y calidad de datos
-- =====================================================

-- Ver estructura de clients
SELECT 
  column_name,
  data_type,
  is_nullable
FROM `edibs-marketing-analytics.bronze.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'clients'
ORDER BY ordinal_position;

-- Ver estructura de campaigns
SELECT 
  column_name,
  data_type,
  is_nullable
FROM `edibs-marketing-analytics.bronze.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'campaigns'
ORDER BY ordinal_position;

-- Ver estructura de products
SELECT 
  column_name,
  data_type,
  is_nullable
FROM `edibs-marketing-analytics.bronze.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'products'
ORDER BY ordinal_position;

-- Ver estructura de sales
SELECT 
  column_name,
  data_type,
  is_nullable
FROM `edibs-marketing-analytics.bronze.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'sales'
ORDER BY ordinal_position;

-- Ver estructura de ads_daily
SELECT 
  column_name,
  data_type,
  is_nullable
FROM `edibs-marketing-analytics.bronze.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'ads_daily'
ORDER BY ordinal_position;

-- =====================================================
-- VALIDACIÓN DE CALIDAD DE DATOS
-- =====================================================

-- Contar registros y verificar duplicados
SELECT 'clients' as tabla, COUNT(*) as total_registros, COUNT(DISTINCT client_id) as ids_unicos
FROM `edibs-marketing-analytics.bronze.clients`
UNION ALL
SELECT 'campaigns', COUNT(*), COUNT(DISTINCT campaign_id)
FROM `edibs-marketing-analytics.bronze.campaigns`
UNION ALL
SELECT 'products', COUNT(*), COUNT(DISTINCT product_id)
FROM `edibs-marketing-analytics.bronze.products`
UNION ALL
SELECT 'sales', COUNT(*), COUNT(DISTINCT CONCAT(CAST(campaign_id AS STRING), '_', CAST(date AS STRING), '_', CAST(product_id AS STRING)))
FROM `edibs-marketing-analytics.bronze.sales`
UNION ALL
SELECT 'ads_daily', COUNT(*), COUNT(DISTINCT CONCAT(CAST(campaign_id AS STRING), '_', CAST(date AS STRING)))
FROM `edibs-marketing-analytics.bronze.ads_daily`;