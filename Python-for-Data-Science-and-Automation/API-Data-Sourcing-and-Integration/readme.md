# API Data Sourcing and Integration 🌐

Este proyecto forma parte del **Sprint 12** del itinerario de Data Analytics. El objetivo principal es demostrar la capacidad de interactuar con servicios externos mediante **APIs REST**, procesar datos complejos en formato **JSON** y convertirlos en activos útiles mediante **Pandas**.

## 🚀 Contenido del Proyecto

### Nivel 1: Fundamentos HTTP
Uso de la API de laboratorio *JSONPlaceholder* para realizar operaciones CRUD completas:
- **GET**: Consulta de recursos (posts, users, todos).
- **POST/PATCH**: Creación y modificación de registros ficticios.
- **DELETE**: Eliminación de recursos y gestión de códigos de estado (200, 201, 404).

### Nivel 2: Consumo de APIs Reales
Implementación de una consulta a la **SWAPI (Star Wars API)**:
- Filtrado dinámico mediante parámetros en la URL.
- Transformación de datos anidados en una tabla estructurada de Pandas.

### Nivel 3: Open Data Barcelona (Sourcing de datos públicos)
Extracción avanzada utilizando la API del Ayuntamiento de Barcelona:
- Búsqueda y localización de datasets mediante `package_search`.
- Recuperación masiva de registros (WiFi Público) usando `datastore_search`.
- Exportación final de los datos limpios a un archivo `.csv`.

## 🛠️ Tecnologías utilizadas
* **Python 3.x**
* **Requests**: Para la gestión de peticiones HTTP.
* **Pandas**: Para la estructuración y limpieza de datos.
* **JSON**: Para el parseo de respuestas de servidor.

---
*Realizado por Emilio Tornos - Sprint 12*
