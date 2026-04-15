# 🚀 Solución: Evaluación Senior Data Platform Engineer - Castor

**Postulante:** [Tu Nombre]  
**Rol:** Senior Data Platform Engineer  
**Enfoque:** Tuning de Base de Datos, Estándares de Gobierno y Seguridad

---

## 📝 Resumen del Proyecto
Resolución estratégica de cuellos de botella en un **Data Warehouse de 8 millones de registros** sobre PostgreSQL 15. El objetivo principal es optimizar el rendimiento de los reportes en Power BI mediante la re-escritura de consultas y una arquitectura de seguridad robusta.

---

## 🛠️ Stack Tecnológico
* **Motor:** PostgreSQL 15.
* **Optimización:** EXPLAIN / ANALYZE, Índices GIN, BRIN y B-tree.
* **Seguridad:** Role-Based Access Control (RBAC) y PII Masking.
* **Gobierno:** Límites de recursos y mantenimiento programado.

---

## 📂 Estructura del Repositorio
La solución se ha modularizado para seguir las mejores prácticas de ingeniería de datos:

* **`sql/01_tuning_queries.sql`**: Re-escritura de queries críticas con reducciones de costo superiores al 50%.
* **`sql/02_index_strategy.sql`**: Plan de indexación para tablas de hechos y configuración de Autovacuum.
* **`sql/03_design_and_bi.sql`**: Implementación de vistas materializadas y gestión de Tablespaces.
* **`sql/04_security_governance.sql`**: Configuración de roles, protección de PII y límites de memoria.

---

## 📈 Aspectos Destacados de la Solución

### 1. Optimización de Performance (Tuning)
Se eliminaron los escaneos secuenciales (Sequential Scans) transformando consultas ineficientes en predicados **SARGables**. Se implementaron **Window Functions** para sustituir subconsultas correlacionadas, optimizando el uso de CPU y memoria.

### 2. Seguridad y Gobierno
Aplicación del principio de **Menor Privilegio**. Se restringió el acceso a datos sensibles (PII) mediante vistas anonimizadas y se establecieron límites de `work_mem` y `statement_timeout` por rol para garantizar la estabilidad del servidor ante consultas pesadas de BI.

---

## 📖 Guía de Estándares para Data Engineers
1. **SARGability:** No aplicar funciones a columnas en el filtro `WHERE`.
2. **No al `SELECT *`:** Solicitar solo columnas necesarias para minimizar el I/O.
3. **Filtrado Temprano:** Reducir el volumen de datos antes de realizar JOINs.
4. **Eficiencia Analítica:** Priorizar Window Functions sobre subqueries.
5. **Cultura de EXPLAIN:** Validar cada cambio con planes de ejecución reales.
