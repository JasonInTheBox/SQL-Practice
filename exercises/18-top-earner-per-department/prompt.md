# 18 · Highest-Paid Employee in Each Department
**Difficulty:** Medium

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id [nullable], salary INT, hire_date DATE)
Department(id PK, department_name)
```

## Task
For each department, find the employee(s) with the **highest salary** in that department.
If several employees **tie** for the highest salary, return **all** of them.
Employees without a department are ignored; departments without employees produce no rows.

## Output columns
| column | meaning |
|---|---|
| `department_name` | |
| `employee_name` | |
| `salary` | |

**Order by** `department_name` ascending, then `employee_name` ascending.

## Output format
```
department_name,employee_name,salary
...
```

<details><summary>Hint</summary>

"One ranking per department" → window function with `PARTITION BY department_id`.
Which ranking function keeps ties at position 1? You must filter the rank in an outer query (CTE),
not in the same `WHERE`.
</details>
