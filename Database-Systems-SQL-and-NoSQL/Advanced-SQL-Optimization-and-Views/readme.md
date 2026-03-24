# Advanced SQL Optimization and Views 🗄️

Este proyecto corresponde al **Sprint 3** del itinerario de **Análisis de Datos**. El enfoque principal es el diseño de estructuras relacionales, la manipulación avanzada de tablas (DDL/DML) y la optimización de reportes mediante la creación de vistas técnicas para negocio.

## 🎯 Objetivos y Logros Técnicos

### 1. Diseño y Modelado de Datos (DDL)
He diseñado e implementado la tabla `credit_card`, asegurando la integridad referencial y la coherencia con el modelo de datos global:
* **Optimización de Tipos de Datos**: He seleccionado tipos como `VARCHAR(20)` para identificadores y `CHAR` para campos de longitud fija (IBAN, PAN, PIN), garantizando un equilibrio entre flexibilidad y rendimiento.
* **Mantenimiento de Esquema**: He utilizado comandos `ALTER TABLE` para refinar la estructura, modificando tipos de columnas y eliminando campos obsoletos para mantener una base de datos eficiente y profesional.

### 2. Gestión de Datos y Actualizaciones (DML)
* **Poblamiento de Registros**: He gestionado la inserción de datos asegurando que formatos críticos como fechas y códigos de seguridad se mantengan íntegros.
* **Lógica de Actualización**: He aplicado comandos `UPDATE` utilizando funciones de sistema como `CURDATE()` para automatizar la gestión de fechas actuales dentro de la tabla de tarjetas.

### 3. Business Intelligence mediante Vistas (Views)
He desarrollado la vista técnica `InformeTecnico`, una herramienta estratégica que consolida información dispersa en un único punto de consulta:
* **Consultas Multi-tabla**: Implementación de `INNER JOIN` para unificar datos de `transaction`, `data_user`, `credit_card` y `company`.
* **Abstracción para Negocio**: He aplicado alias descriptivos para que el usuario final pueda interpretar los resultados sin necesidad de conocer los nombres técnicos de la base de datos.
* **Auditoría y Orden**: Los resultados se presentan ordenados de forma descendente por el ID de transacción, optimizando la revisión de los movimientos más recientes.

## 🛠️ Stack Tecnológico
* **Motor de Base de Datos**: MySQL Workbench.
* **Lenguaje**: SQL (Data Definition Language y Data Manipulation Language).
* **Herramientas de Diseño**: Modelado relacional y diagramas EER.

## 📂 Archivos en esta Carpeta
* `SQL - Emilio Tornos Iniesta - Tasca S3.01.sql`: El script completo con toda la lógica de creación, modificación y generación de vistas.
* `PDF - Emilio Tornos Iniesta - Tasca S3.01.pdf`: Documentación técnica con la explicación paso a paso y capturas de los resultados obtenidos.

---
*Diseño de Bases de Datos y Optimización SQL - Emilio Tornos*
