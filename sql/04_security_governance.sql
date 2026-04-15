-- ==========================================================
-- 4. SEGURIDAD, GOBIERNO Y LÍMITES (RBAC)
-- ==========================================================

-- Roles de Solo Lectura (Punto 3.1)
-- Aplicación del principio de Menor Privilegio (evitando Superuser).

-- GOBIERNO Y SEGURIDAD (RBAC):
-- Aplicación del Principio de Menor Privilegio (PoLP) mediante roles de solo lectura.
-- Aislamiento de recursos (work_mem/timeout) para proteger la estabilidad del servidor ante queries de BI.

CREATE ROLE powerbi_analyst_role;
GRANT USAGE ON SCHEMA core TO powerbi_analyst_role;
GRANT SELECT ON ALL TABLES IN SCHEMA core TO powerbi_analyst_role;

-- Protección de Información Sensible (PII)
-- Revocamos acceso a la tabla base y exponemos datos enmascarados.
REVOKE SELECT ON core.dim_customers FROM powerbi_analyst_role;
CREATE VIEW core.v_customers_masked AS 
SELECT id, customer_name, md5(email) AS email_hash FROM core.dim_customers;
GRANT SELECT ON core.v_customers_masked TO powerbi_analyst_role;

-- Aislamiento de Recursos y Límites (Punto 3.4)
-- Previene que una query pesada agote la RAM del servidor.
ALTER ROLE powerbi_analyst_role SET statement_timeout = '60s';
ALTER ROLE powerbi_analyst_role SET work_mem = '128MB';
