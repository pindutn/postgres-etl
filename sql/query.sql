-- Consulta 1: Casos por grupo etario, departamento y provincia
SELECT
    provincia.nombre AS provincia,
    departamento.nombre AS departamento,
    grupo_etario,
    cantidad
FROM
    dengue
    INNER JOIN departamento ON dengue.departamento_id = departamento.id
    INNER JOIN provincia ON departamento.provincia_id = provincia.id;

-- Consulta 2: Casos por grupo etario con más de 20,000 casos

SELECT d.grupo_etario AS "Grupo Etario", SUM(d.cantidad) AS "Cantidad de Casos"
FROM dengue AS d
GROUP BY
    grupo_etario
HAVING
    SUM(d.cantidad) > 20000
ORDER BY "Cantidad de Casos" DESC;