# NoSQL Database Systems - MongoDB 🍃

Este proyecto corresponde al **Sprint 5** del itinerario de **Análisis de Datos**. En él, exploro el ecosistema **NoSQL** utilizando **MongoDB**, centrándome en el análisis de una base de datos documental para una aplicación de entretenimiento cinematográfico.

## 🎯 Objetivos y Logros Técnicos

### 1. Modelado Documental y Gestión de Colecciones
He trabajado con una estructura de datos flexible basada en documentos BSON/JSON, gestionando colecciones clave para el negocio:
* **Estructura Multidimensional**: Gestión de colecciones interrelacionadas como `movies`, `users`, `theatres`, `sessions` y `comments`.
* **Tratamiento de Datos Anidados**: Manipulación de documentos con arrays y objetos embebidos, una de las grandes ventajas de MongoDB frente al modelo relacional.

### 2. Consultas y Extracción de Datos (DQL)
He implementado consultas de filtrado y recuperación de datos para responder a requerimientos analíticos:
* **Filtros Avanzados**: Uso de operadores lógicos para extraer información específica (como los primeros comentarios del sistema o filtrado de películas por género y año).
* **Proyecciones**: Selección de campos específicos para optimizar la carga de datos en las respuestas del servidor.

### 3. Análisis Geoespacial y Visualización
Uno de los puntos más destacados de este proyecto ha sido la gestión de datos de ubicación de los cines (`theatres`):
* **Estándar GeoJSON**: Verificación y manejo del formato `Point` para coordenadas [longitud, latitud].
* **Análisis de Esquema en Compass**: He utilizado la herramienta **Analyze Schema** de MongoDB Compass para detectar automáticamente campos geoespaciales.
* **Mapeo Global**: Visualización interactiva de la distribución geográfica de los teatros sobre un mapa, transformando coordenadas crudas en información visual de valor.

## 🛠️ Stack Tecnológico
* **Motor de Base de Datos**: MongoDB.
* **Herramientas de Gestión**: MongoDB Compass (Interfaz Gráfica y Visualizador de Esquemas).
* **Formatos de Datos**: JSON / BSON / GeoJSON.

## 📂 Archivos en esta Carpeta
* `PDF - Emilio Tornos Iniesta - Tasca S5.01.pdf`: Documentación completa del proceso, incluyendo la lógica de las consultas realizadas y las visualizaciones de mapas obtenidas mediante el análisis del esquema.

---
*Analítica de Datos NoSQL con MongoDB - Emilio Tornos*
