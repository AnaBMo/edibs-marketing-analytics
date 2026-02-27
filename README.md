# EDIBS Marketing Analytics

Análisis completo de marketing digital para agencia: modelado de datos en BigQuery, arquitectura medallón, métricas de performance y dashboard ejecutivo en Looker Studio.

---

##  Proyecto

Diseño y construcción de modelo analítico completo para agencia de marketing digital que gestiona campañas para múltiples clientes.

**Entregables:**
- ✅ Arquitectura medallón completa (Bronze → Silver → Gold)
- ✅ Modelo estrella optimizado en BigQuery
- ✅ Dashboard ejecutivo en Looker Studio con 5 visualizaciones
- ✅ Análisis estratégico con insights accionables

---

##  Estructura
```
edibs-marketing-analytics/
├── index.html              # Documentación completa (Fase 1 + Fase 2)
├── diagrams/               # Modelo relacional y esquema estrella
├── sql/
│   ├── bronze/            # Datos crudos
│   ├── silver/            # Limpieza y validación
│   └── gold/              # Modelo estrella + vistas analíticas
└── python/                # Scripts de carga
```

---

##  Arquitectura

**Medallion Architecture en BigQuery:**

- **Bronze:** 5 tablas (clients, campaigns, products, sales, ads_daily)
- **Silver:** Limpieza, normalización, enriquecimientos
- **Gold:** Modelo estrella (4 dimensiones + 1 fact table) + 9 vistas analíticas

---

##  Resultados Clave

**Dashboard:** [Ver en Looker Studio](https://lookerstudio.google.com/s/vFdXddMmvvs)

**KPIs:**
- Revenue: $1.64M (73 días)
- ROAS: 1.34 (⚠️ bajo - requiere optimización)
- CPA: $15.23
- Conversiones: 81,236

**Insights Principales:**
1.  ROAS global crítico (1.34) - necesita llegar a 2.0
2.  LinkedIn lidera (ROAS 1.40) pero diferencia mínima vs otros canales
3.  Alta concentración: top 2 clientes = 45% revenue

---

##  Stack Tecnológico

- **Cloud:** Google Cloud Platform
- **Data Warehouse:** BigQuery
- **Procesamiento:** SQL, Python
- **Visualización:** Looker Studio
- **Docs:** HTML + Bootstrap 5

---

##  Documentación

Toda la documentación técnica y análisis está disponible en:

**👉 [index.html](https://anabmo.github.io/edibs-marketing-analytics/)**

Incluye:
- Modelo relacional y esquema estrella con diagramas
- Cálculo de métricas (ROAS, CPA, Conversion Rate)
- Medidas personalizadas avanzadas
- Propuesta de mejora estructural
- 5 insights estratégicos con recomendaciones
- Dashboard embebido

---

##  Uso

**Ver documentación:**
```bash
# Abrir index.html en navegador
open index.html
```

**Explorar queries SQL:**
```bash
cd sql/gold/
# Ver modelo estrella y vistas analíticas
```

**Dashboard interactivo:**
[https://lookerstudio.google.com/s/vFdXddMmvvs](https://lookerstudio.google.com/s/vFdXddMmvvs)

---

## 📝 Contexto

Prueba técnica para **Analista de Datos** en EDIBS School.

**Nota:** Proyecto desarrollado con datos sintéticos. Las credenciales de GCP no están incluidas por seguridad.

---

**Desarrollado por Ana Morales** | 2026
