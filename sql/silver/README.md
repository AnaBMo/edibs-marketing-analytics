# Silver Layer - Transformación y Limpieza

## Objetivo
Validar, normalizar y enriquecer los datos crudos del Bronze Layer.

## Transformaciones Aplicadas

### Validaciones
- ✅ Integridad referencial (todas las FKs válidas)
- ✅ Eliminación de valores negativos (revenue, ad_spend, budget)
- ✅ Validación lógica (clicks ≤ impressions, conversions ≤ clicks)
- ✅ Eliminación de nulos en campos críticos

### Normalizaciones
- ✅ TRIM en todos los strings
- ✅ Channel normalizado a minúsculas
- ✅ Client_name normalizado a mayúsculas

### Enriquecimientos
- ✅ `client_segment`: Clasificación por retainer (Enterprise/Mid-Market/SMB)
- ✅ `price_category`: Clasificación de productos (Premium/Mid-Range/Budget)
- ✅ `duration_days`: Duración de campaña calculada
- ✅ `is_weekend`: Flag de fin de semana
- ✅ `is_logically_valid`: Flag de validación lógica en ads

## Calidad de Datos
- **Registros eliminados:** ~0% (datos de origen muy limpios)
- **Campos enriquecidos:** 5
- **Validaciones aplicadas:** 8