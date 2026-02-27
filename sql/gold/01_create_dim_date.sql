-- =====================================================
-- GOLD LAYER - DIMENSIÓN DE FECHAS
-- Tabla calendario para análisis temporal
-- =====================================================

CREATE OR REPLACE TABLE `edibs-marketing-analytics.gold.dim_date` AS
SELECT DISTINCT
  date AS date_id,
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(QUARTER FROM date) AS quarter,
  EXTRACT(MONTH FROM date) AS month,
  FORMAT_DATE('%B', date) AS month_name,
  EXTRACT(WEEK FROM date) AS week,
  EXTRACT(DAY FROM date) AS day,
  EXTRACT(DAYOFWEEK FROM date) AS day_of_week,
  FORMAT_DATE('%A', date) AS day_name,
  CASE WHEN EXTRACT(DAYOFWEEK FROM date) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend
FROM (
  SELECT date FROM `edibs-marketing-analytics.silver.sales`
  UNION DISTINCT
  SELECT date FROM `edibs-marketing-analytics.silver.ads_daily`
)
ORDER BY date_id;