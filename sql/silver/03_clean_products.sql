-- =====================================================
-- SILVER LAYER - PRODUCTOS VALIDADOS
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.silver.products` AS
SELECT
  product_id,
  TRIM(product_name) AS product_name,
  price_usd,
  -- Categorizar productos por precio
  CASE 
    WHEN price_usd >= 500 THEN 'Premium'
    WHEN price_usd >= 200 THEN 'Mid-Range'
    ELSE 'Budget'
  END AS price_category
FROM `edibs-marketing-analytics.bronze.products`
WHERE product_id IS NOT NULL
  AND product_name IS NOT NULL
  AND price_usd > 0;  -- Eliminar precios <= 0