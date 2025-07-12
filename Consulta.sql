-- Clasificación de tipos de servicio
WITH service_types AS (
  SELECT
    _id,
    name_es AS name,
    CASE
      WHEN name_es IN ('Servicio A', 'Servicio B', 'Carga Ligera', 'Carga Pesada') THEN 'Logistico'
      WHEN name_es IN ('Moto', 'Carro', 'Taxi', 'Subasta') THEN 'Movilidad'
      ELSE 'Otro'
    END AS type
  FROM `proyecto.dataset.service_types`
),

-- Agregación de transacciones financieras
transactions AS (
  SELECT
    booking_id,
    JSON_VALUE(amount, '$.currency_iso') AS currency,
    SUM(IF(_type = 'ComisionConductor', -CAST(JSON_VALUE(amount, '$.cents') AS INT64)/100, 0)) AS driver,
    SUM(IF(_type = 'ComisionEmpresa', -CAST(JSON_VALUE(amount, '$.cents') AS INT64)/100, 0)) AS company,
    SUM(IF(_type = 'PagoConductor', CAST(JSON_VALUE(amount, '$.cents') AS INT64)/100, 0)) AS booking_driver_payment
  FROM `proyecto.dataset.transacciones_wallet`
  WHERE _type IN ('ComisionConductor', 'ComisionEmpresa', 'PagoConductor')
  GROUP BY booking_id, currency
),

-- Métodos de pago
payment_methods AS (
  SELECT
    _id AS booking_id,
    payment_method_cd,
    CASE 
      WHEN payment_method_cd = '1' THEN 'Efectivo'
      WHEN payment_method_cd = '2' THEN 'Voucher'
      WHEN payment_method_cd = '3' THEN 'Tarjeta'
      ELSE 'Otro'
    END AS payment_method
  FROM `proyecto.dataset.reservas`
)

-- Consulta principal
SELECT
  b._id AS booking_id,
  DATE(TIMESTAMP(b.created_at), "America/Bogota") AS fecha_servicio,
  p.name AS cliente,
  pkg.reference AS referencia_paquete,
  CASE CAST(pkg.status_cd AS INT64)
    WHEN 0 THEN 'En espera'
    WHEN 1 THEN 'Recogido'
    WHEN 2 THEN 'Entregado'
    WHEN 3 THEN 'Cancelado'
    ELSE 'Otro'
  END AS estado_paquete,
  REPLACE(CAST(b.traveled_distance AS STRING), '.', ',') AS distancia_km,
  REPLACE(CAST(b.traveled_time AS STRING), '.', ',') AS duracion_min,
  REPLACE(CAST((IFNULL(CAST(JSON_VALUE(b.final_cost, '$.cents') AS INT64), 0)) / 100 AS STRING), '.', ',') AS costo_servicio,
  REPLACE(CAST((t.driver + t.company) AS STRING), '.', ',') AS ganancia_total,
  d.name AS conductor,
  pm.payment_method AS metodo_pago,
  st.type AS tipo_servicio,
  CASE WHEN b.company_id IS NOT NULL THEN 'B2B' ELSE 'B2C' END AS tipo_negocio

FROM `proyecto.dataset.reservas` b
INNER JOIN service_types st ON st._id = b.requested_service_type_id
LEFT JOIN transactions t ON t.booking_id = b._id
LEFT JOIN `proyecto.dataset.usuarios` p ON p._id = b.cliente_id
LEFT JOIN `proyecto.dataset.usuarios` d ON d._id = b.conductor_id
LEFT JOIN `proyecto.dataset.paquetes` pkg ON pkg.booking_id = b._id
LEFT JOIN payment_methods pm ON pm.booking_id = b._id

WHERE b.status_cd IN (2, 3) -- entregado o cancelado
  AND st.type = 'Logistico'
  AND DATE(TIMESTAMP(b.created_at), "America/Bogota") BETWEEN '2024-01-01' AND '2024-12-31'
  AND IF(b.company_id IS NOT NULL, 'B2B', 'B2C') = 'B2B'
