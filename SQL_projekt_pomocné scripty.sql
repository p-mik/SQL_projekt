
SELECT DISTINCT YEAR(date_from) AS year -- Unikátní roky z tabulky czechia_price
FROM czechia_price
ORDER BY year;

SELECT DISTINCT payroll_year AS year, industry_branch_code, value -- unikátní roky z tabulky czechia_payroll
FROM czechia_payroll
ORDER BY year;

SELECT DISTINCT YEAR(date_from) AS year -- společné roky mezi tabulkami czechia_price a czechia_payroll
FROM czechia_price
WHERE YEAR(date_from) IN (
    SELECT DISTINCT payroll_year
    FROM czechia_payroll
)
ORDER BY year;


SELECT -- průměrné ceny potravin na roční úrpvni
    YEAR(date_from) AS year,
    category_code,
    AVG(value) AS average_price
FROM
    czechia_price
WHERE
    region_code IS NULL
    AND YEAR(date_from) BETWEEN 2006 AND 2018 
GROUP BY
    YEAR(date_from), category_code
ORDER BY
    year, category_code;
    
  
SELECT -- Mzdy na roční úrovni
    payroll_year AS year,
    industry_branch_code,
    AVG(value) AS average_salary
FROM
    czechia_payroll
WHERE
    payroll_year BETWEEN 2006 AND 2018
    AND value IS NOT NULL
GROUP BY
    payroll_year, industry_branch_code
ORDER BY
    year, industry_branch_code;


SELECT -- Průměrná mzda za všechny obory
    payroll_year AS year,
    AVG(value) AS average_salary_all_industries
FROM
    czechia_payroll
WHERE
    payroll_year BETWEEN 2006 AND 2018 
    AND value IS NOT NULL
GROUP BY
    payroll_year
ORDER BY
    year;
