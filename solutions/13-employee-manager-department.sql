-- 13 - Three-way join: employee, manager, department, salary
--
-- Joins, all LEFT so that NO employee is lost:
--   LEFT JOIN Employee m   (self join) -> manager's name. Alice has no manager -> NULL.
--   LEFT JOIN Department d             -> department name. Wendy has no department -> NULL.
-- If either join were INNER, Alice or Wendy would silently disappear.
-- Rule of thumb: once you need "all rows from X", every join hanging off X
-- that might not match must be a LEFT JOIN.
--
-- No GROUP BY: still one row per employee.
SELECT
    e.name            AS employee_name,
    m.name            AS manager_name,
    d.department_name AS department_name,
    e.salary
FROM Employee e
LEFT JOIN Employee   m ON e.manager_id    = m.id
LEFT JOIN Department d ON e.department_id = d.id
ORDER BY e.salary DESC, e.name;
