--1
SELECT c.company_name, AVG(i.price) AS average_price
FROM company c
JOIN items i ON i.company_id = c.company_id
GROUP BY c.company_name;

--2
SELECT c.company_name, AVG(i.price) AS average_price
FROM company c
JOIN items i ON i.company_id = c.company_id
GROUP BY c.company_name
HAVING AVG(i.price) > (SELECT AVG(price) FROM items);

--3
SELECT item_id, item_name, price, company_id
FROM items
WHERE price > (SELECT AVG(price) FROM items);

--4
SELECT e.emp_id, e.emp_fname, e.emp_lname, d.dept_code
FROM employees e
JOIN departments d ON e.emp_dept = d.dept_code
WHERE d.dept_budget > (SELECT AVG(dept_budget) FROM departments);

--5
SELECT d.dept_code, d.dept_name
FROM departments d
JOIN employees e ON e.emp_dept = d.dept_code
GROUP BY d.dept_code, d.dept_name
HAVING COUNT(e.emp_id) > (
    SELECT COUNT(*) * 1.0 / (SELECT COUNT(*) FROM departments)
    FROM employees);

--6
SELECT i.item_id, i.item_name, i.price, i.company_id
FROM items i
WHERE i.price < (
    SELECT AVG(i2.price)
    FROM items i2
    WHERE i2.company_id = i.company_id);

--7
SELECT d.dept_code, d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
JOIN employees e ON e.emp_dept = d.dept_code
GROUP BY d.dept_code, d.dept_name
HAVING COUNT(e.emp_id) = 1;

--8
SELECT c.company_name, AVG(i.price) AS average_price
FROM company c
JOIN items i ON i.company_id = c.company_id
GROUP BY c.company_name
HAVING AVG(i.price) = (
    SELECT MIN(avg_price)
    FROM (SELECT AVG(price) AS avg_price FROM items GROUP BY company_id) t);

--9
SELECT e.emp_id, e.emp_fname, e.emp_lname, d.dept_code
FROM employees e
JOIN departments d ON e.emp_dept = d.dept_code
WHERE d.dept_budget < (SELECT AVG(dept_budget) FROM departments);



-------------------------------------------------------------------------------------------------
--1
WITH avg_price AS (
    SELECT AVG(price) AS avg_item_price
    FROM items
)
SELECT i.*
FROM items i, avg_price a
WHERE i.price > a.avg_item_price;

--2
WITH item_counts AS (
    SELECT company_id, COUNT(*) AS item_count
    FROM items
    GROUP BY company_id
)
SELECT c.company_name, ic.item_count
FROM company c
JOIN item_counts ic ON ic.company_id = c.company_id;

--3
WITH company_avg AS (
    SELECT company_id, AVG(price) AS average_price
    FROM items
    GROUP BY company_id
)
SELECT c.company_name, ca.average_price
FROM company c
JOIN company_avg ca ON ca.company_id = c.company_id
WHERE ca.average_price > 2000;


--4
WITH emp_dept AS (
    SELECT e.emp_fname, e.emp_lname, d.dept_name
    FROM employees_new e
    JOIN departments_new d ON e.emp_dept = d.dept_code
)
SELECT emp_fname || ' ' || emp_lname AS full_name, dept_name
FROM emp_dept;

--5
WITH avg_budget AS (
    SELECT AVG(dept_budget) AS avg_dept_budget
    FROM departments_new
)
SELECT d.dept_code, d.dept_name, d.dept_budget
FROM departments_new d, avg_budget a
WHERE d.dept_budget > a.avg_dept_budget;

--6
WITH emp_count AS (
    SELECT emp_dept, COUNT(*) AS employee_count
    FROM employees_new
    GROUP BY emp_dept
)
SELECT d.dept_code, d.dept_name, ec.employee_count
FROM departments_new d
JOIN emp_count ec ON ec.emp_dept = d.dept_code
WHERE ec.employee_count > 1;

--7
WITH overall AS (
    SELECT AVG(price) AS overall_avg
    FROM items
),
company_avg AS (
    SELECT company_id, AVG(price) AS average_price
    FROM items
    GROUP BY company_id
)
SELECT c.company_name, ca.average_price
FROM company c
JOIN company_avg ca ON ca.company_id = c.company_id
JOIN overall o ON ca.average_price < o.overall_avg;