# Relational Data Modeling and Architecture 🏗️

Este proyecto corresponde al **Sprint 4** del itinerario de **Análisis de Datos**. En él, me he encargado de diseñar e implementar desde cero una arquitectura de base de datos completa utilizando un **Modelo en Estrella** (*Star Schema*) para gestionar un sistema de transacciones comerciales.

## 🎯 Objetivos y Logros Técnicos

### 1. Diseño de Arquitectura (Modelo en Estrella)
He diseñado una base de datos robusta (`transactionsSPRINT4`) compuesta por 5 tablas interconectadas, asegurando la integridad referencial y el orden lógico de creación (tablas maestras antes que tablas dependientes):
* **Tablas Maestras**: `user`, `company` y `products`.
* **Tablas de Hechos/Relación**: `credit_card` y `transaction`.

### 2. Integración y Normalización de Datos
He definido tipos de datos optimizados para garantizar la calidad de la información:
* **Validación Temporal**: Uso de `DATE` para fechas de nacimiento, permitiendo cálculos de edad precisos.
* **Formatos Estándar**: Uso de `CHAR` para IDs de longitud fija y `VARCHAR(255)` para emails y direcciones, siguiendo estándares técnicos internacionales.
* **Integridad Referencial**: Implementación de llaves primarias (`PRIMARY KEY`) y foráneas (`FOREIGN KEY`) para conectar el ecosistema de datos.

### 3. Resolución de Problemas y Optimización de Consultas
Uno de los retos más interesantes fue la manipulación de datos para reportes específicos:
* **Corrección de Orden Logístico**: Me di cuenta de que al ordenar IDs guardados como texto, el sistema lo hacía de forma alfabética (1, 10, 11, 2...). Lo solucioné utilizando `CAST(id AS UNSIGNED)` para forzar un orden numérico real en los reportes de ventas.
* **Consultas Multitabla**: Implementación de `INNER JOIN` complejos entre 3 o más tablas para cruzar información de productos, transacciones y estados de venta (filtrando transacciones declinadas).
* **Agregación de Datos**: Uso de `COUNT` y `GROUP BY` para generar rankings de productos más vendidos sin perder información por nombres duplicados.

## 🛠️ Stack Tecnológico
* **Motor de Base de Datos**: MySQL Workbench.
* **Lenguaje**: SQL Avanzado (DDL y DQL).
* **Conceptos de Diseño**: Normalización de bases de datos y Arquitectura en Estrella.

## 📂 Archivos en esta Carpeta
* `Tasca SQL - Emilio Tornos Iniesta - S4.01.sql`: Script completo con la creación de la base de datos, definición de relaciones y las queries de análisis de negocio.
* `PDF - Emilio Tornos Iniesta - Tasca S4.01.pdf`: Documentación detallada con el modelo relacional, capturas de pantalla de los resultados y la explicación técnica de las soluciones aplicadas.

---
*Arquitectura de Datos y SQL Avanzado - Emilio Tornos*
