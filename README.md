> ### ETL para la carga de *`datasets`* de DENGUE en Argentina.

Desplegamos la infraestructura necesaria para la prueba del proyecto, con los siguientes comandos.
```sh
docker compose up -d
init.sh
```

Ingresamos a [http://localhost/](http://localhost/) con las credenciales ***`admin/admin`***. Luego creamos la conexión a la base de datos en ***`Settings`***, e ingresamos en ***`SQL Lab`***, donde pegamos la query siguiente para comenzar a utilizar los tableros. 

>##### Cuantos casos hay por grupo etario, por departamento y provincia.

```sql
SELECT provincia.nombre as provincia, departamento.nombre as departamento, grupo_etario , cantidad
FROM dengue 
INNER JOIN departamento ON dengue.departamento_id = departamento.id
INNER JOIN provincia ON departamento.provincia_id = provincia.id;
```
Una vez ejecutada la query, podemos crear un gráfico con el botón ***`CREATE CHART`***, y después de configurar lo necesario como el tipo y las dimensiones a utilizar, lo gravamos con ***`SAVE`*** en un tablero.

La siguiente query puede ejecutarse en ***`SQL Lab`*** o directamente en la consola del PostgreSQL.
>##### Cuantos casos hay por grupo etario, ordenando el resultado de mayo a menor, solo para aquellos grupos en donde se supera los ***`20000`*** casos.

```sql
SELECT d.grupo_etario AS "Grupo Etario", SUM(d.cantidad) AS "Cantidad de Casos"
FROM dengue AS d
GROUP BY grupo_etario
HAVING SUM(d.cantidad) > 20000
ORDER BY "Cantidad de Casos" DESC;
```