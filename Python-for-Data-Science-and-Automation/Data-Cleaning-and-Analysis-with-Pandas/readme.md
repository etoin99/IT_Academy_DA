# Data Cleaning and Analysis with Pandas 🐼

Este repositorio contiene el trabajo realizado durante el **Sprint 10** del itinerario de **Data Analytics**. El proyecto se centra en la resolución de problemas comunes en el mundo del análisis: la limpieza de datos "sucios", la manipulación de matrices y la ingeniería de variables temporales.

## 🚀 Retos Resueltos en este Sprint

### 1. Limpieza de Datos de Nóminas y Encuestas
A partir de un dataset de trabajadores (`sprint10.xlsx`), realicé un proceso de limpieza profunda:
* **Tratamiento de Moneda**: Conversión de salarios en formato texto (ej: "1.253 €") a valores numéricos `float` mediante limpieza de símbolos y separadores de miles.
* **Gestión de Nulos**: Identificación y tratamiento de valores vacíos en campos críticos como DNI o número de hijos.
* **Mapeo de Categorías**: Transformación de variables binarias (0/1) a etiquetas descriptivas para mejorar la legibilidad del análisis.

### 2. Ingeniería de Variables (Feature Engineering)
* **Cálculo de Edad**: Reconstrucción de fechas de nacimiento a partir de tres columnas independientes (Día, Mes, Año) utilizando `pd.to_datetime`.
* **Cálculo de Antigüedad**: Implementación de lógica temporal para determinar la edad de los encuestados en el momento actual.

### 3. Análisis de Matrices de Distancia
Utilizando la matriz de distancias entre ciudades españolas (`matriu_distancies`):
* **Optimización de Rutas**: Creación de una función lógica para calcular la ruta más corta empezando desde una ciudad específica.
* **Búsqueda de Proximidad**: Identificación de los puntos geográficos más cercanos mediante la manipulación de índices y valores mínimos en matrices de correlación/distancia.


### 4. Agregación Estadística
* Creación de resúmenes informativos agrupando por **Grupo Profesional** para comparar salarios medios, máximos y mínimos, permitiendo identificar brechas o tendencias salariales.

## 🛠️ Stack Tecnológico
* **Python 3.x**
* **Pandas**: Motor principal para la manipulación de DataFrames.
* **NumPy**: Soporte para operaciones matriciales y gestión de valores `NaN`.
* **Matplotlib / Seaborn**: Visualización de las distribuciones obtenidas tras la limpieza.

---
*Realizado por Emilio Tornos - Sprint 10*
