> ### ETL para la carga de *`datasets`* de DENGUE en Argentina.

Desplegamos la infraestructura necesaria para la prueba del proyecto
```sh
docker compose up -d
init.sh
```

Ingresamos a [http://localhost/](http://localhost/) y hay que ingresar con ***`admin/admin`***. Luego creamos la conexión a la base de datos en ***`Settings`***, luego ingresamos en ***SQL Lab***, pegamos la query siguiente. 

##### Cuantos casos hay por grupo etario, por departamento y provincia.

```sql
SELECT provincia.nombre as provincia, departamento.nombre as departamento, grupo_etario , cantidad
FROM dengue 
INNER JOIN departamento ON dengue.departamento_id = departamento.id
INNER JOIN provincia ON departamento.provincia_id = provincia.id;
```

##### Cuantos casos hay por grupo etario, ordenando el resultado de mayo a menor, solo para aquellos grupos en donde se supera los ***`20000`*** casos.

```sql
SELECT d.grupo_etario AS "Grupo Etario", SUM(d.cantidad) AS "Cantidad de Casos"
FROM dengue AS d
GROUP BY grupo_etario
HAVING SUM(d.cantidad) > 20000
ORDER BY "Cantidad de Casos" DESC;
```