/*SEKUNdární tabulka*/
CREATE TABLE t_petr_mikulka_project_SQL_secondary_final AS
SELECT
    c.*,  -- Všechny sloupce z tabulky countries
    e.year,
    e.GDP,
    e.population AS economy_population,
    e.gini,
    e.taxes,
    e.fertility,
    e.mortaliy_under5
FROM
    economies AS e
JOIN
    countries AS c
ON
    e.country = c.country
WHERE
    e.year BETWEEN 2006 AND 2018
    AND c.continent = 'Europe';
