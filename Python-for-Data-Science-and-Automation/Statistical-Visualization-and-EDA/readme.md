# Statistical Visualization and EDA 📊

Este proyecto representa la culminación del **Sprint 11** del itinerario de **Análisis de Datos**. En él, he desarrollado un flujo de trabajo completo (*End-to-End*) que integra la extracción de datos desde bases de datos relacionales, el análisis estadístico profundo en Python y la visualización interactiva en Power BI.

## 🎯 Objetivos y Logros

### 1. Conexión y Extracción de Datos (SQL to Python)
En lugar de trabajar con archivos estáticos, implementé una conexión dinámica con **MySQL Workbench** utilizando `SQLAlchemy`. Esto permite:
* Automatizar la carga de tablas ('users', 'transactions', 'companies').
* Garantizar la integridad de los datos desde la fuente original.

### 2. Análisis Exploratorio de Datos (EDA)
Realicé un estudio estadístico detallado para entender la naturaleza de la información antes de visualizarla:
* **Limpieza y Transformación**: Tratamiento de valores nulos, eliminación de duplicados y tipado correcto de variables.
* **Ingeniería de Variables**: Cruce de tablas (*merging*) para obtener una visión 360º del comportamiento del usuario y sus transacciones.
* **Detección de Outliers**: Uso de técnicas estadísticas para identificar valores atípicos que podrían sesgar el análisis.

### 3. Visualización Estadística Avanzada
Utilizando **Seaborn** y **Matplotlib**, diseñé visualizaciones que responden a preguntas de negocio:
* **Mapas de Calor (Heatmaps)**: Para analizar la correlación entre variables numéricas.
* **Gráficos de Densidad (KDE) e Histogramas**: Para observar la distribución de los importes de las transacciones.
* **Boxplots**: Para comparar la dispersión de gastos por continentes y categorías.


### 4. Integración con Power BI
El análisis culmina con la exportación de los datos procesados hacia **Power BI**, donde:
* Se integraron visualizaciones nativas con el procesamiento avanzado realizado en Python.
* Se diseñó un dashboard dinámico ('.pbix') para facilitar la toma de decisiones basada en datos.

## 🛠️ Stack Tecnológico
* **Base de Datos**: MySQL Workbench.
* **Lenguaje**: Python 3.x.
* **Librerías Clave**: Pandas, SQLAlchemy, Seaborn, Matplotlib.
* **Business Intelligence**: Power BI Desktop.

## 📂 Archivos en esta Carpeta
* 'Tasca S11.01...ipynb': El núcleo del análisis, desde la conexión SQL hasta la generación de gráficos estadísticos.
* 'Tasca S11.01...pbix': El informe final interactivo que consume los datos procesados en Python.

---
*Análisis Estadístico e Integración de BI - Emilio Tornos*
