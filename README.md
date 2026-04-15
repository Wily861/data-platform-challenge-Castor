# 🚀 Solución: Evaluación Senior Data Platform Engineer - Castor

**Postulante:** Wily Duvan Villamil Rey  
**Rol:** Senior Data Platform Engineer  
**Perfil:** [LinkedIn: wily-rey-dba](https://www.linkedin.com/in/wily-rey-dba)  
**Enfoque:** Optimización de Consultas, Arquitectura de Datos y Gobierno Corporativo

---

## 📝 Resumen del Proyecto
Resolución estratégica de cuellos de botella en un **Data Warehouse de 8 millones de registros** sobre PostgreSQL 15. La solución se centra en la estabilización de los reportes de Power BI mediante la optimización de planes de ejecución y la implementación de una arquitectura de seguridad robusta para garantizar la alta disponibilidad de los recursos.

---

## 🛠️ Stack Tecnológico
* **Motor:** PostgreSQL 15.
* **Optimización:** EXPLAIN / ANALYZE, Índices GIN, BRIN y B-tree.
* **Seguridad:** Role-Based Access Control (RBAC) y PII Masking.
* **Gobierno:** Gestión de Work Load (Limits) y Mantenimiento Programado.

---

## 📂 Estructura del Repositorio
Para garantizar la escalabilidad y el orden, el repositorio se ha modularizado de la siguiente manera:

* **[`sql/01_tuning_queries.sql`](./sql/01_tuning_queries.sql)**: Re-escritura de queries críticas bajo el estándar SARGable, logrando reducciones de costo superiores al 50%.
* **[`sql/02_index_strategy.sql`](./sql/02_index_strategy.sql)**: Implementación de índices avanzados (BRIN) y optimización del Autovacuum para el manejo de grandes volúmenes.
* **[`sql/03_design_and_bi.sql`](./sql/03_design_and_bi.sql)**: Diseño de vistas materializadas y estrategia de almacenamiento por Tablespaces para optimizar el I/O.
* **[`sql/04_security_governance.sql`](./sql/04_security_governance.sql)**: Implementación de roles de solo lectura, protección de datos sensibles (PII) y aislamiento de recursos por rol.

---

## ⚖️ Decisiones de Arquitectura y Trade-offs
Para esta solución de 8 millones de registros, se tomaron decisiones basadas en el equilibrio entre almacenamiento e I/O:

* **Índices BRIN (Block Range Index):** Seleccionados para la tabla de hechos cronológica por su bajísimo impacto en disco (comparado con B-tree) y alta velocidad de escaneo en rangos de fechas. Esto evita el sobre-indexado que degradaría el rendimiento de las cargas masivas.
  
* **Índices GIN con `pg_trgm`:** Implementados específicamente para la auditoría de correos electrónicos. Los índices tradicionales no optimizan búsquedas con comodín inicial (`%dominio.com`), mientras que los trigramas permiten un filtrado de texto eficiente.
  
* **Aislamiento de Recursos:** Se configuró `work_mem` y `statement_timeout` por rol para prevenir que consultas analíticas pesadas saturen la RAM, garantizando la estabilidad del entorno productivo para otros procesos críticos.

---

## 📈 Aspectos Críticos de la Solución

### 1. Optimización de Performance (Tuning)
Se eliminaron de raíz los escaneos secuenciales (Sequential Scans) ineficientes. Mediante el uso de **Window Functions** y la transformación de predicados a formatos **SARGables**, se garantiza una respuesta rápida del motor incluso en procesos analíticos complejos.

### 2. Seguridad y Gobierno de Datos
Se implementó el **Principio de Menor Privilegio (PoLP)**. El acceso a la capa analítica se realiza mediante vistas que enmascaran información personal (PII), y se establecieron límites estrictos de `work_mem` y `statement_timeout` para evitar la degradación del servicio por consultas costosas.

---

## 📖 Guía de Estándares para Data Engineers
Esta guía establece las bases para un desarrollo de alto rendimiento:
1.  **SARGability:** Prohibido envolver columnas en funciones dentro del filtro `WHERE` para no inhabilitar los índices.
2.  **Proyección Selectiva:** Prohibido el uso de `SELECT *`. Se deben solicitar solo las columnas estrictamente necesarias para el negocio.
3.  **Filtrado Temprano:** Reducción agresiva de datasets mediante filtros aplicados antes de realizar JOINs complejos.
4.  **Eficiencia Analítica:** Priorización del uso de Window Functions sobre subconsultas correlacionadas para reducir la complejidad computacional.
5.  **Cultura de EXPLAIN:** Es obligatorio validar cada cambio mediante planes de ejecución, buscando siempre una reducción demostrable en el costo operativo.
