-- ==========================================================
-- 1. ANÁLISIS Y OPTIMIZACIÓN DE CONSULTAS
-- ==========================================================

-- Query 1: Reporte de Ventas Históricas
-- Problema: EXTRACT(YEAR) impide el uso de índices (Sequential Scan).
-- Solución: Rango de fechas explícito para habilitar Index Range Scan.

CREATE INDEX IF NOT EXISTS idx_sales_date_amount ON fact_sales (sale_date) INCLUDE (total_amount, product_id);

SELECT p.product_name, SUM(s.total_amount) AS total_revenue
FROM fact_sales s
JOIN dim_products p ON s.product_id = p.id
WHERE s.sale_date >= '2023-01-01' AND s.sale_date < '2024-01-01'
GROUP BY p.product_name;

-- Query 2: Auditoría de Clientes (Dominios)
-- Problema: LIKE con % inicial y SELECT * son ineficientes en 8M de filas.
-- Solución: Índice GIN de trigramas para búsqueda parcial y proyección selectiva.
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_cust_email_trgm ON dim_customers USING GIN (email gin_trgm_ops);

SELECT s.id, s.sale_date, s.total_amount, c.customer_name, c.email
FROM fact_sales s
INNER JOIN dim_customers c ON s.customer_id = c.id
WHERE c.email LIKE '%@empresa_objetivo.com'
ORDER BY s.sale_date DESC
LIMIT 1000;

-- Query 3: Desempeño sobre el Promedio
-- Problema: Subquery correlacionada ejecuta O(n^2), bloqueando el rendimiento.
-- Solución: Window Function para calcular el promedio en una sola pasada (O(n)).
WITH Sales_Stats AS (
    SELECT id, total_amount, customer_id,
           AVG(total_amount) OVER(PARTITION BY customer_id) AS avg_amount
    FROM fact_sales
)
SELECT id, total_amount, customer_id FROM Sales_Stats WHERE total_amount > avg_amount;
