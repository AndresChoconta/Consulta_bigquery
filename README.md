# 📊 Consulta BigQuery - Reporte de Servicios

Este proyecto contiene una consulta SQL avanzada diseñada para ejecutarse en **Google BigQuery**. El objetivo principal es demostrar **habilidades en manejo de datos complejos**, incluyendo transformación, filtrado y análisis financiero en entornos de producción.

---

## 🧠 Objetivo

Extraer información detallada de servicios logísticos **tipo Pibox** (B2B), aplicando filtros geográficos, temporales y financieros. La consulta permite:

- Cruzar datos desde múltiples tablas relacionadas
- Limpiar y transformar datos estructurados y semiestructurados (JSON)
- Calcular KPIs financieros como **GMV**, **ganancia piloto** y **método de pago**
- Clasificar reservas y usuarios por tipo de servicio y negocio

---

## 🛠️ Tecnologías y herramientas

- **SQL (BigQuery dialect)**
- **Google BigQuery**
- Transformaciones con funciones como `JSON_VALUE`, `CASE`, `SAFE_CAST`, `REPLACE`, `DATETIME`, entre otras.
- Uniones complejas (`INNER JOIN`, `LEFT JOIN`)
- Subconsultas reutilizables (`WITH`)

---

## 🧩 Estructura general

```sql
WITH subconsulta1 AS (...),
     subconsulta2 AS (...)
SELECT ...
FROM tabla1
JOIN subconsulta1 ON ...
WHERE condiciones
