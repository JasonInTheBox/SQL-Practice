-- 09 - Date range filter: employees hired 2020-01-01 .. 2022-12-31 (inclusive)
--
-- WHERE = row filter; no aggregation involved.
-- BETWEEN is inclusive on both ends, which is exactly right for DATE columns.
--   Karen White was hired on 2022-12-31 -> included.
-- Safer habit (works for DATE *and* TIMESTAMP columns):
--   WHERE hire_date >= DATE '2020-01-01' AND hire_date < DATE '2023-01-01'
-- With a TIMESTAMP column, BETWEEN ... '2022-12-31' would miss '2022-12-31 10:30'.
--
-- MySQL: identical; date literals can be written simply as '2020-01-01'.
SELECT
    name AS employee_name,
    hire_date
FROM Employee
WHERE hire_date BETWEEN DATE '2020-01-01' AND DATE '2022-12-31'
ORDER BY hire_date, name;
