-- 02 - SELF JOIN: employee name + manager name
--
-- JOIN: the same table appears twice with two aliases.
--   e = the employee row, m = the row describing e's manager.
--   e.manager_id points at m.id.
-- LEFT JOIN (not INNER) so Alice, who has manager_id NULL, is still returned;
-- her manager_name comes back NULL. With an INNER JOIN she would vanish.
-- No GROUP BY / WHERE needed: one row per employee.
SELECT
    e.name AS employee_name,
    m.name AS manager_name
FROM Employee e
LEFT JOIN Employee m
  ON e.manager_id = m.id
ORDER BY e.name;
