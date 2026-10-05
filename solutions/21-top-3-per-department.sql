-- 21 - Top N per group: exactly 3 (or fewer) employees per department
--
-- ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC, hire_date, id)
--   PARTITION BY department_id: numbering restarts at 1 in each department.
--   ORDER BY salary DESC: best paid first.
--   hire_date, id: deterministic tie-breakers. Two people with the same salary
--     must still get DIFFERENT numbers; the earlier hire wins, then lower id.
--
-- Why ROW_NUMBER here and not RANK/DENSE_RANK?
--   The prompt asks for at most 3 PEOPLE per department.
--   DENSE_RANK <= 3 would return "everyone in the top 3 salary levels", which can be
--   more than 3 people (Finance would return 4: David, Samuel, Tina, Uma).
--
-- Cost intuition: the DB sorts each partition once (O(n log n) overall), then
-- the outer WHERE keeps <= 3 rows per partition.
WITH ranked AS (
    SELECT
        e.*,
        ROW_NUMBER() OVER (
            PARTITION BY e.department_id
            ORDER BY e.salary DESC, e.hire_date, e.id
        ) AS position
    FROM Employee e
    WHERE e.department_id IS NOT NULL
)
SELECT
    d.department_name,
    r.name AS employee_name,
    r.salary,
    r.position
FROM ranked r
JOIN Department d ON d.id = r.department_id
WHERE r.position <= 3
ORDER BY d.department_name, r.position;
