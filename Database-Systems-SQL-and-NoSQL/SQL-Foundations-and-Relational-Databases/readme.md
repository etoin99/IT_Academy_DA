# SQL Foundations and Relational Databases 📊

Este proyecto corresponde al **Sprint 2** del itinerario de **Análisis de Datos**. Es el bloque fundamental donde establezco las bases del lenguaje SQL, centrándome en la exploración de datos, la integridad referencial y la generación de reportes mediante lógica condicional.

## 🎯 Objetivos y Logros Técnicos

### 1. Exploración y Validación de Integridad
Antes de realizar análisis complejos, he validado la estructura de la base de datos para asegurar resultados precisos:
* **Auditoría de Registros**: Uso de `COUNT`, `DISTINCT` y comparaciones entre tablas para verificar que los 100 IDs de la tabla `company` coinciden con los registros únicos en la tabla de hechos `transaction`.
* **Comprensión del Modelo Relacional**: Identificación de Llaves Primarias (PK) y Llaves Foráneas (FK) para entender la relación de **Uno a Muchos** entre empresas y transacciones.

### 2. Extracción de Datos y Relaciones (JOINs)
He implementado consultas para cruzar información de diferentes entidades:
* **Inner Joins**: Conexión de tablas para obtener nombres de empresas asociados a sus importes de venta.
* **Filtrado Avanzado**: Uso de operadores como `BETWEEN` e `IN` para segmentar transacciones por rangos de precio (350€ - 400€) y fechas específicas de gran actividad comercial.

### 3. Lógica de Negocio y Clasificación (CASE)
Para responder a peticiones de departamentos como Recursos Humanos o Ventas, he aplicado lógica de programación dentro de SQL:
* **Estructuras Condicionales**: Implementación de `CASE WHEN` para categorizar automáticamente a las empresas según su volumen operativo (ej: "Más de 400 transacciones" vs "Menos de 400").
* **Agregaciones Estadísticas**: Uso de `AVG`, `SUM`, `MIN` y `MAX` para obtener KPIs rápidos sobre el rendimiento de las compañías.

## 🛠️ Stack Tecnológico
* **Motor de Base de Datos**: MySQL Workbench.
* **Lenguaje**: SQL (DQL - Data Query Language).
* **Conceptos clave**: Agregaciones, Joins, Operadores Lógicos y Sentencias Condicionales.

## 📂 Archivos en esta Carpeta
* `Emilio Tornos Iniesta - SPRINT 2.sql`: Script estructurado por niveles (1, 2 y 3) con todas las consultas necesarias para el análisis del ecosistema de transacciones.
* `PDF - Emilio Tornos Iniesta - Tasca S2.01.pdf`: Documentación con la descripción detallada del modelo de datos, diagramas de relación y capturas de los resultados de las consultas.

---
*Fundamentos de SQL y Análisis Relacional - Emilio Tornos*
