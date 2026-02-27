# Gold Layer - Modelo Estrella

## Estructura

### Dimensiones
- `dim_client` - 5 clientes
- `dim_campaign` - 15 campañas
- `dim_product` - 10 productos
- `dim_date` - Calendario completo

### Tabla de Hechos
- `fact_marketing_performance` - Métricas consolidadas de ads y ventas

## Granularidad
Nivel diario por campaña y producto: `(campaign_id, date_id, product_id)`

## Métricas Pre-calculadas
- ROAS (Return on Ad Spend)
- CPA (Cost Per Acquisition)
- Conversion Rate
- CTR (Click-Through Rate)
- Revenue per Click

## Uso
Esta capa está optimizada para consultas analíticas y dashboards.
Conectar directamente desde Looker Studio o herramientas de BI.