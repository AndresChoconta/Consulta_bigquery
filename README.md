# 📊 Consulta BigQuery - Reporte de Servicios

## 🧠 Objetivo

Extraer información detallada de servicios logísticos, aplicando filtros geográficos, temporales y financieros. La consulta permite:

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
