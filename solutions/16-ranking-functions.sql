-- 16 - ROW_NUMBER vs RANK vs DENSE_RANK, side by side
--      (see 16-ranking-functions.md for a worked table)
--
-- All three are WINDOW functions: they compute a value for every row while
-- looking at other rows, WITHOUT collapsing rows the way GROUP BY does.
-- OVER (ORDER BY salary DESC) = "rank the whole table by salary, highest first".
-- There is no PARTITION BY here, so the whole table is one window.
--
--   ROW_NUMBER()  1,2,3,4,5 ...  always unique. Ties broken by the extra
--                                ORDER BY key (id) -- otherwise arbitrary!
--   RANK()        1,2,2,4 ...    ties share a rank, then it SKIPS (like sports).
--   DENSE_RANK()  1,2,2,3 ...    ties share a rank, NO gaps.
--                                -> DENSE_RANK = N means "Nth distinct value".
--
-- Window functions are evaluated after WHERE/GROUP BY/HAVING, so you can't filter
-- on them in the same query's WHERE -- wrap in a CTE/subquery first (see 17+).
SELECT
    id,
    name AS employee_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC, id) AS row_num,
    RANK()       OVER (ORDER BY salary DESC)     AS salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC)     AS dense_salary_rank
FROM Employee
ORDER BY salary DESC, id;
