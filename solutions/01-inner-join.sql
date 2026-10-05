-- 01 - INNER JOIN: employee name + department name
--
-- JOIN: INNER JOIN keeps only pairs where e.department_id = d.id matches.
--   * Wendy Scott (department_id NULL) has no match -> she disappears.
--     NULL = anything is never TRUE, so NULL keys never join.
--   * Legal / Research have no employees -> they disappear too.
-- No GROUP BY: one output row per (employee, department) pair, no aggregation.
-- Processing intuition: the DB builds a hash table on the small Department table
-- and probes it once per Employee row -> roughly O(employees + departments).
SELECT
    e.name            AS employee_name,
    d.department_name AS department_name
FROM Employee e
JOIN Department d                -- "JOIN" means "INNER JOIN"
  ON e.department_id = d.id
ORDER BY e.name;
