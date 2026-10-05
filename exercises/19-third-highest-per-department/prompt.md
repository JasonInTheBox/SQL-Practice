# 19 · Third-Highest Salary Within Each Department
**Difficulty:** Medium

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id [nullable], salary INT, hire_date DATE)
Department(id PK, department_name)
```

## Task
For each department, find the employee(s) earning the **third-highest distinct salary** in that department.

- "Distinct" means equal salaries count as one level: in a department with salaries
  `200, 150, 150, 120`, the third-highest distinct salary is `120`.
- If several employees earn that salary, return all of them.
- Departments with fewer than three distinct salaries produce **no** rows.
- Employees without a department are ignored.

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

`DENSE_RANK() OVER (PARTITION BY ... ORDER BY salary DESC) = 3`.
Try `RANK()` and `ROW_NUMBER()` too and watch Engineering's result change.
</details>
