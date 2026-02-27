# sql/bronze/README.md

## Arquitectura de Actualización de Datos

### Estado Actual (Prueba Técnica)
Carga manual mediante script Python ejecutado bajo demanda.

### Arquitectura Propuesta para Producción

#### Flujo Automático:
1. **Trigger:** Cloud Storage detecta nuevo archivo o modificación
2. **Cloud Function:** Se ejecuta automáticamente
3. **Carga a Bronze:** Datos raw actualizados
4. **Transformaciones:** SQL automático (Silver → Gold)
5. **Dashboard:** Looker Studio se refresca automáticamente

#### Ventajas:
- Actualizaciones en tiempo real
- Sin intervención manual
- Escalable a múltiples fuentes
- Registro de cambios (auditoría)

#### Implementación:
```bash
# Crear Cloud Function con trigger de Storage
gcloud functions deploy load_bronze_data \
  --runtime python39 \
  --trigger-resource edibs-marketing-data \
  --trigger-event google.storage.object.finalize
```