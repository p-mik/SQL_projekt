/* 

OTÁZKA 1
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Tabulka obsahuje průměrnou mzdu v jednotlivých oborech za každý rok a procentuální změnu oproti předchozímu roku. 
Je tedy vidět, jestli průměrná mzda v tom kterém oboru klesá nebo stoupá a lze z toho vytvořit graf. 
*/

SELECT
    year,
    industry_branch_code,
    industry_branch_name,
    average_salary,
    LAG(average_salary) OVER (PARTITION BY industry_branch_code ORDER BY year) AS previous_year_salary,
    CASE
        WHEN LAG(average_salary) OVER (PARTITION BY industry_branch_code ORDER BY year) IS NOT NULL THEN 
            (average_salary - LAG(average_salary) OVER (PARTITION BY industry_branch_code ORDER BY year)) / LAG(average_salary) OVER (PARTITION BY industry_branch_code ORDER BY year) * 100
        ELSE
            NULL
    END AS percent_change
FROM
    t_petr_mikulka_project_SQL_primary_final
WHERE
    average_salary IS NOT NULL
GROUP BY
    year, industry_branch_code, average_salary
ORDER BY
    industry_branch_code, year;

/* 

OTÁZKA 2   
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Vzhledem k tomu, že otázka je velice konkrétní a konkretizuje jak produkty tak roky, mezi kterými se má porovnávat, udělal jsem tabulku o 4 řádcích.

Tabulka obsahuje 
*/

SELECT DISTINCT
    p.year,
    p.category_code,
    p.category_name,
    p.average_price,
    s.average_salary_all_industries,
    ROUND(s.average_salary_all_industries / p.average_price, 2) AS units_affordable
FROM
    (
        SELECT
            year,
            category_code,
            category_name,
            average_price
        FROM
            t_petr_mikulka_project_SQL_primary_final
        WHERE
            category_code IN (114201, 111301)
    ) AS p
JOIN
    (
        SELECT
            year,
            average_salary_all_industries
        FROM
            t_petr_mikulka_project_SQL_primary_final
    ) AS s
ON
    p.year = s.year
WHERE
    p.year IN (
        SELECT MIN(year) FROM t_petr_mikulka_project_SQL_primary_final
        UNION
        SELECT MAX(year) FROM t_petr_mikulka_project_SQL_primary_final
    )
ORDER BY
    p.year, p.category_code;
   
   
/* 

OTÁZKA 3   
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

poznámka: Zde si moc nejsem jistý, co v kontextu sledovaného období přesně znamená že potravina zdražuje nejpomaleji. Proto: 
- jsem připravil obecný SELECT, kde je vidět meziroční zdražení u každého produktu
- jsem připravil SELECT, kde je vidět zdražení jednotlivých druhů potravin za celé období 2006 - 2018
- jsem připravil SELECT, kde je za každý rok vidět jen ta potravina, která meziročně zdražila nejméně
*/
   
-- SELECT, kde je vidět meziroční zdražení u každého produktu   
SELECT
    year,
    category_code,
    category_name,
    average_price,
    previous_year_price,
    CASE
        WHEN previous_year_price IS NOT NULL THEN
            ROUND((average_price - previous_year_price) / previous_year_price * 100, 2)
        ELSE
            NULL
    END AS percent_change
FROM (
    SELECT
        year,
        category_code,
        category_name,
        average_price,
        LAG(average_price) OVER (PARTITION BY category_code ORDER BY year) AS previous_year_price
    FROM
        t_petr_mikulka_project_SQL_primary_final
) AS subquery
WHERE
    previous_year_price IS NULL OR average_price <> previous_year_price
ORDER BY
    category_code, year;

-- SELECT, kde je vidět zdražení jednotlivých druhů potravin za celé období 2006 - 2018

SELECT
    category_code,
    category_name,
    MAX(CASE WHEN year = 2006 THEN average_price ELSE NULL END) AS price_2006,
    MAX(CASE WHEN year = 2018 THEN average_price ELSE NULL END) AS price_2018,
    CASE
        WHEN MAX(CASE WHEN year = 2006 THEN average_price ELSE NULL END) IS NOT NULL
             AND MAX(CASE WHEN year = 2018 THEN average_price ELSE NULL END) IS NOT NULL
        THEN
            ROUND(
                (MAX(CASE WHEN year = 2018 THEN average_price ELSE NULL END) - MAX(CASE WHEN year = 2006 THEN average_price ELSE NULL END)) 
                / MAX(CASE WHEN year = 2006 THEN average_price ELSE NULL END) * 100,
                2
            )
        ELSE
            NULL
    END AS percent_change_2006_to_2018
FROM
    t_petr_mikulka_project_SQL_primary_final
GROUP BY
    category_code, category_name
ORDER BY
    percent_change_2006_to_2018 ASC;

-- SELECT, kde je za každý rok vidět jen ta potravina, která meziročně zdražila nejméně

WITH price_changes AS (
    SELECT
        year,
        category_code,
        category_name,
        average_price,
        LAG(average_price) OVER (PARTITION BY category_code ORDER BY year) AS previous_year_price,
        CASE
            WHEN LAG(average_price) OVER (PARTITION BY category_code ORDER BY year) IS NOT NULL THEN
                ROUND((average_price - LAG(average_price) OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_price) OVER (PARTITION BY category_code ORDER BY year) * 100, 2)
            ELSE
                NULL
        END AS percent_change
    FROM
        t_petr_mikulka_project_SQL_primary_final
    WHERE
        year BETWEEN 2006 AND 2018 
)
SELECT DISTINCT
    year,
    category_code,
    category_name,
    previous_year_price,
    average_price,
    percent_change
FROM (
    SELECT
        year,
        category_code,
        category_name,
        previous_year_price,
        average_price,
        percent_change,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY percent_change ASC) AS rn
    FROM
        price_changes
    WHERE
        year BETWEEN 2007 AND 2018 -- 2006 nelze porovnat s předchozím rokem, proto ho nezahrnuju
        AND percent_change IS NOT NULL
) AS ranked_changes
WHERE
    rn = 1
ORDER BY
    year;
    
   
/* 

OTÁZKA 4  
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

V tabulce se vypočítává průměrná cena všech potravin v daném roce a průměrná mzda.
Pak se obojí porovná oproti předchozímu roku, čímž se vypočítá procentuální změna. 
Nakonec se porovná změna cen se změnou mezd a vypočítá se rozdíl, podle kterého je také tabulka řazena. 
*/
   
   
WITH price_changes AS (
    SELECT
        year,
        AVG(average_price) AS avg_price_year,
        LAG(AVG(average_price)) OVER (ORDER BY year) AS previous_year_price
    FROM
        t_petr_mikulka_project_SQL_primary_final
    GROUP BY
        year
),
payroll_changes AS (
    SELECT
        year,
        AVG(average_salary_all_industries) AS avg_salary_year,
        LAG(AVG(average_salary_all_industries)) OVER (ORDER BY year) AS previous_year_salary
    FROM
        t_petr_mikulka_project_SQL_primary_final
    GROUP BY
        year
)
SELECT
    p.year,
    p.avg_price_year,
    p.previous_year_price,
    y.avg_salary_year,
    y.previous_year_salary,
    ROUND((p.avg_price_year - p.previous_year_price) / p.previous_year_price * 100, 2) AS percent_change_price,
    ROUND((y.avg_salary_year - y.previous_year_salary) / y.previous_year_salary * 100, 2) AS percent_change_salary,
    ROUND(
        ROUND((p.avg_price_year - p.previous_year_price) / p.previous_year_price * 100, 2) - 
        ROUND((y.avg_salary_year - y.previous_year_salary) / y.previous_year_salary * 100, 2), 
        2
    ) AS difference_in_growth
FROM
    price_changes AS p
JOIN
    payroll_changes AS y
ON
    p.year = y.year
WHERE
    p.previous_year_price IS NOT NULL
    AND y.previous_year_salary IS NOT NULL
ORDER BY
    difference_in_growth DESC;
    
/* 

OTÁZKA 5   
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

V tabulce je na jednom řádku změna GDP a pak změna průměrné mzdy a průměrných cen a to jak oproti loňskému roku, tak oproti následujícímu roku. 

*/

WITH hdp_changes AS (
    SELECT
        year,
        GDP,
        LAG(GDP) OVER (ORDER BY year) AS previous_year_GDP,
        CASE
            WHEN LAG(GDP) OVER (ORDER BY year) IS NOT NULL THEN
                ROUND((GDP - LAG(GDP) OVER (ORDER BY year)) / LAG(GDP) OVER (ORDER BY year) * 100, 2)
            ELSE
                NULL
        END AS percent_change_GDP
    FROM
        t_petr_mikulka_project_SQL_secondary_final
    WHERE
        country = 'Czech republic'
        AND year BETWEEN 2006 AND 2018
),
payroll_changes AS (
    SELECT
        year,
        AVG(average_salary_all_industries) AS avg_salary_year,
        LAG(AVG(average_salary_all_industries)) OVER (ORDER BY year) AS previous_year_salary,
        LEAD(AVG(average_salary_all_industries)) OVER (ORDER BY year) AS next_year_salary,
        ROUND((AVG(average_salary_all_industries) - LAG(AVG(average_salary_all_industries)) OVER (ORDER BY year)) / LAG(AVG(average_salary_all_industries)) OVER (ORDER BY year) * 100, 2) AS percent_change_salary,
        CASE
            WHEN LEAD(AVG(average_salary_all_industries)) OVER (ORDER BY year) IS NOT NULL THEN
                ROUND((LEAD(AVG(average_salary_all_industries)) OVER (ORDER BY year) - AVG(average_salary_all_industries)) / AVG(average_salary_all_industries) * 100, 2)
            ELSE
                NULL
        END AS percent_change_next_salary
    FROM
        t_petr_mikulka_project_SQL_primary_final
    GROUP BY
        year
),
price_changes AS (
    SELECT
        year,
        AVG(average_price) AS avg_price_year,
        LAG(AVG(average_price)) OVER (ORDER BY year) AS previous_year_price,
        LEAD(AVG(average_price)) OVER (ORDER BY year) AS next_year_price,
        ROUND((AVG(average_price) - LAG(AVG(average_price)) OVER (ORDER BY year)) / LAG(AVG(average_price)) OVER (ORDER BY year) * 100, 2) AS percent_change_price,
        CASE
            WHEN LEAD(AVG(average_price)) OVER (ORDER BY year) IS NOT NULL THEN
                ROUND((LEAD(AVG(average_price)) OVER (ORDER BY year) - AVG(average_price)) / AVG(average_price) * 100, 2)
            ELSE
                NULL
        END AS percent_change_next_price
    FROM
        t_petr_mikulka_project_SQL_primary_final
    GROUP BY
        year
)
SELECT
    h.year,
    h.GDP,
    h.previous_year_GDP,
    h.percent_change_GDP,
    p.avg_salary_year,
    p.previous_year_salary,
    p.percent_change_salary,
    p.next_year_salary,
    p.percent_change_next_salary,
    c.avg_price_year,
    c.previous_year_price,
    c.percent_change_price,
    c.next_year_price,
    c.percent_change_next_price
FROM
    hdp_changes AS h
LEFT JOIN
    payroll_changes AS p ON h.year = p.year
LEFT JOIN
    price_changes AS c ON h.year = c.year
WHERE
    h.year BETWEEN 2007 AND 2018
ORDER BY
    h.year;