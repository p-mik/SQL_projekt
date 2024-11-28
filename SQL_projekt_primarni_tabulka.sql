

/* PRIMÁRNÍ TABULKA - vytvoření */
CREATE TABLE t_petr_mikulka_project_SQL_primary_final (
    year INT,
    industry_branch_code VARCHAR(255),
    industry_branch_name VARCHAR(255),
    average_salary DECIMAL(10, 2),
    average_salary_all_industries DECIMAL(10, 2),
    category_code VARCHAR(255),
    category_name VARCHAR(255),
    average_price DECIMAL(10, 2)
);


/*Vložení dat*/
INSERT INTO t_petr_mikulka_project_SQL_primary_final (year, industry_branch_code, industry_branch_name, average_salary, average_salary_all_industries, category_code, category_name, average_price)
SELECT
    p.year,
    p.industry_branch_code,
    ib.name AS industry_branch_name, 
    p.average_salary,
    pa.average_salary_all_industries,
    pr.category_code,
    pc.name AS category_name,
    pr.average_price
FROM
    (
        SELECT
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
    ) AS p
LEFT JOIN
    (
        SELECT
            payroll_year AS year,
            AVG(value) AS average_salary_all_industries
        FROM
            czechia_payroll
        WHERE
            payroll_year BETWEEN 2006 AND 2018
            AND value IS NOT NULL
        GROUP BY
            payroll_year
    ) AS pa
ON p.year = pa.year
LEFT JOIN
    (
        SELECT
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
    ) AS pr
ON p.year = pr.year
LEFT JOIN
    czechia_payroll_industry_branch AS ib
ON p.industry_branch_code = ib.code
LEFT JOIN
    czechia_price_category AS pc
ON pr.category_code = pc.code
ORDER BY
    p.year, p.industry_branch_code, pr.category_code;

