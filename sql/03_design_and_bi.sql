-- ==========================================================
-- 3. DISEÑO FÍSICO Y OPTIMIZACIÓN BI
-- ==========================================================

-- Vista Materializada (Punto 2.1)
-- Pre-agregación de métricas mensuales para Power BI.

-- DISEÑO FÍSICO Y BI:
-- Implementación de Materialized Views con índices únicos para permitir refresco concurrente.
-- Estrategia de Tablespaces para separar I/O entre datos volátiles (Staging) y persistentes (Core).

CREATE MATERIALIZED VIEW mv_bi_monthly_sales AS
SELECT product_id, DATE_TRUNC('month', sale_date) AS month, SUM(total_amount) AS revenue
FROM fact_sales GROUP BY 1, 2;

-- Índice único para permitir REFRESH CONCURRENTLY sin bloquear Power BI.
CREATE UNIQUE INDEX idx_mv_monthly_sales_unique ON mv_bi_monthly_sales (product_id, month);

-- Estrategia de Storage (Punto 2.2)
-- Separación física de datos para optimizar I/O.
-- TABLESPACE staging_ts LOCATION '/data/standard_ssd'; -- Volátil
-- TABLESPACE core_ts LOCATION '/data/premium_nvme';    -- Persistente/Lectura BI
