-- ==========================================================
-- 2. ESTRATEGIA DE ÍNDICES Y MANTENIMIENTO
-- ==========================================================

-- Estrategia para Tabla de Hechos (8M registros)
-- Se utiliza un índice BRIN para la fecha por su alta eficiencia en espacio 
-- y rendimiento en tablas particionadas por tiempo.
CREATE INDEX idx_sales_brin_date ON fact_sales USING BRIN (sale_date);

-- Autovacuum Tuning (Punto 1.3)
-- Optimización para cargas masivas diarias (alta tasa de escritura/borrado).
ALTER TABLE fact_sales SET (
  autovacuum_vacuum_scale_factor = 0.05, -- Trigger al 5% de cambios
  autovacuum_vacuum_cost_limit = 1000     -- Mayor presupuesto de I/O para limpieza
);

-- Script de Mantenimiento Programado (Punto 3.8)
-- Evita el "bloating" y actualiza estadísticas para el optimizador.
VACUUM ANALYZE fact_sales;
REINDEX TABLE CONCURRENTLY fact_sales;
