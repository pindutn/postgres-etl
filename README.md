# **ETL para la carga de *`datasets`* de DENGUE en Argentina**

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Apache Superset](https://img.shields.io/badge/Apache_Superset-FF5733?style=for-the-badge&logo=apache-superset&logoColor=white)
![pgAdmin](https://img.shields.io/badge/pgAdmin-316192?style=for-the-badge&logo=postgresql&logoColor=white)

## **Descarga de Datasets**

Los datasets utilizados en este proyecto pueden descargarse desde el portal oficial de datos abiertos del gobierno de Argentina:  
[https://datos.gob.ar/dataset](https://datos.gob.ar/dataset)

Este portal proporciona información pública en formatos reutilizables, incluyendo datos relacionados con casos de dengue en Argentina.

## **Resumen del Tutorial**

Este tutorial guía al usuario a través de los pasos necesarios para desplegar una infraestructura ETL utilizando Docker, PostgreSQL, Apache Superset y pgAdmin. Se incluyen instrucciones detalladas para:

1. Levantar los servicios con Docker.
2. Configurar la conexión a la base de datos en Apache Superset.
3. Ejecutar consultas SQL para analizar los datos de casos de dengue.
4. Crear gráficos y tableros interactivos para la visualización de datos.

## **Palabras Clave**

- Docker
- PostgreSQL
- Apache Superset
- pgAdmin
- ETL
- Visualización de Datos

## **Mantenido Por**

**PINDU**

## **Descargo de Responsabilidad**

El código proporcionado se ofrece "tal cual", sin garantía de ningún tipo, expresa o implícita. En ningún caso los autores o titulares de derechos de autor serán responsables de cualquier reclamo, daño u otra responsabilidad.


## **Descripción del Proyecto**

Este proyecto implementa un proceso ETL (Extract, Transform, Load) para la carga y análisis de datos relacionados con casos de dengue en Argentina. Utiliza herramientas modernas como Docker, PostgreSQL, Apache Superset y pgAdmin para facilitar la gestión, análisis y visualización de datos.

El objetivo principal es proporcionar una solución escalable y reproducible para analizar datos de dengue por grupo etario, departamento y provincia, permitiendo la creación de tableros interactivos y gráficos personalizados.

## **Características Principales**

- **Infraestructura Contenerizada:** Uso de Docker para simplificar la configuración y despliegue.
- **Base de Datos Relacional:** PostgreSQL para almacenar y gestionar los datos.
- **Visualización de Datos:** Apache Superset para crear gráficos y tableros interactivos.
- **Gestión de Base de Datos:** pgAdmin para administrar y consultar la base de datos.

## **Requisitos Previos**

Antes de comenzar, asegúrate de tener instalados los siguientes componentes:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- Navegador web para acceder a Apache Superset y pgAdmin.

## **Servicios Definidos en Docker Compose**

El archivo `docker-compose.yml` define los siguientes servicios:

1. **Base de Datos (PostgreSQL):**
   - Imagen: `postgres:alpine`
   - Puertos: `5432:5432`
   - Volúmenes:
     - `postgres-db:/var/lib/postgresql/data` (almacenamiento persistente de datos)
     - `./scripts:/docker-entrypoint-initdb.d` (scripts de inicialización)
     - `./datos:/datos` (directorio para datos adicionales)
   - Variables de entorno:
     - Configuradas en el archivo `.env.db`
   - Healthcheck:
     - Comando: `pg_isready`
     - Intervalo: 10 segundos
     - Retries: 5

2. **Apache Superset:**
   - Imagen: `apache/superset:4.0.0`
   - Puertos: `8088:8088`
   - Dependencias:
     - Depende del servicio `db` y espera a que esté saludable.
   - Variables de entorno:
     - Configuradas en el archivo `.env.db`

3. **pgAdmin:**
   - Imagen: `dpage/pgadmin4`
   - Puertos: `5050:80`
   - Dependencias:
     - Depende del servicio `db` y espera a que esté saludable.
   - Variables de entorno:
     - Configuradas en el archivo `.env.db`

## **Instrucciones de Configuración**

1. **Clonar el repositorio:**
   ```sh
   git clone <URL_DEL_REPOSITORIO>
   cd postgres-etl
   ```

2. **Configurar el archivo `.env.db`:**
   Crea un archivo `.env.db` en la raíz del proyecto con las siguientes variables de entorno:
   ```env
    #Definimos cada variable
    DATABASE_HOST=db
    DATABASE_PORT=5432
    DATABASE_NAME=postgres
    DATABASE_USER=postgres
    DATABASE_PASSWORD=postgres
    POSTGRES_INITDB_ARGS="--auth-host=scram-sha-256 --auth-local=trust"
    # Configuracion para inicializar postgres
    POSTGRES_PASSWORD=${DATABASE_PASSWORD}
    PGUSER=${DATABASE_USER}
    # Configuracion para inicializar pgadmin
    PGADMIN_DEFAULT_EMAIL=postgres@postgresql.com
    PGADMIN_DEFAULT_PASSWORD=${DATABASE_PASSWORD}
    # Configuracion para inicializar superset
    SUPERSET_SECRET_KEY=your_secret_key_here
   ```

3. **Levantar los servicios:**
   Ejecuta los siguientes comandos para iniciar los contenedores:
   ```sh
   docker compose up -d
   . init.sh
   ```

4. **Acceso a las herramientas:**
   - **Apache Superset:** [http://localhost:8088/](http://localhost:8088/)  
     Credenciales predeterminadas: ***`admin/admin`***
   - **pgAdmin:** [http://localhost:5050/](http://localhost:5050/)  
     Configura la conexión a PostgreSQL utilizando las credenciales definidas en el archivo `.env.db`.

## **Uso del Proyecto**

### **1. Configuración de la Base de Datos**

Accede a Apache Superset y crea una conexión a la base de datos PostgreSQL en la sección ***`Settings`***. Asegúrate de que la conexión sea exitosa antes de proceder.

### **2. Consultas SQL**

#### **Consulta 1: Casos por grupo etario, departamento y provincia**
Esta consulta permite analizar los casos de dengue agrupados por grupo etario, departamento y provincia.

```sql
SELECT provincia.nombre AS provincia, 
       departamento.nombre AS departamento, 
       grupo_etario, 
       cantidad
FROM dengue 
INNER JOIN departamento ON dengue.departamento_id = departamento.id
INNER JOIN provincia ON departamento.provincia_id = provincia.id;
```

#### **Consulta 2: Casos por grupo etario con más de 20,000 casos**
Esta consulta filtra los grupos etarios con más de 20,000 casos y ordena los resultados de mayor a menor.

```sql
SELECT d.grupo_etario AS "Grupo Etario", 
       SUM(d.cantidad) AS "Cantidad de Casos"
FROM dengue AS d
GROUP BY grupo_etario
HAVING SUM(d.cantidad) > 20000
ORDER BY "Cantidad de Casos" DESC;
```

### **3. Creación de Gráficos y Tableros**

1. Ejecuta las consultas en ***`SQL Lab`*** de Apache Superset.
2. Haz clic en el botón ***`CREATE CHART`*** para crear gráficos interactivos.
3. Configura el tipo de gráfico y las dimensiones necesarias.
4. Guarda el gráfico en un tablero con el botón ***`SAVE`***.

## **Estructura del Proyecto**

```
postgres-etl/
├── docker-compose.yml       # Configuración de Docker Compose
├── init.sh                  # Script de inicialización
├── data/                    # Carpeta para almacenar datasets
├── sql/                     # Consultas SQL predefinidas
└── README.md                # Documentación del proyecto
```

