#/bin/bash
echo "Inicializamos el usuario de superset"
docker compose exec -it superset superset fab create-admin \
              --username admin \
              --firstname Superset \
              --lastname Admin \
              --email admin@superset.com \
              --password admin
echo "Migramos la base de datos"
docker compose exec -it superset superset db upgrade
echo "Seteamos los Roles"
docker compose exec -it superset superset init