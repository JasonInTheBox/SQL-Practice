-- 03 - LEFT JOIN + COUNT: head-count for EVERY department (including empty ones)
--
-- JOIN: Department is on the LEFT, so every department survives.
--   Legal and Research have no employees -> one row each with all e.* columns NULL.
-- GROUP BY d.id, d.department_name: collapse to one row per department.
-- COUNT(e.id) vs COUNT(*):
--   COUNT(*)    counts rows -> the NULL-padded row of Legal counts as 1 (WRONG).
--   COUNT(e.id) counts non-NULL values -> Legal gets 0 (RIGHT).
-- Wendy (department_id NULL) never matches a department, so she is not counted.
SELECT
    d.department_name,
    COUNT(e.id) AS employee_count
FROM Department d
LEFT JOIN Employee e
  ON e.department_id = d.id
GROUP BY d.id, d.department_name
ORDER BY employee_count DESC, d.department_name;
