# 04 · Salary Statistics per Department
**Difficulty:** Easy

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id [nullable], salary INT, hire_date DATE)
Department(id PK, department_name)
```

## Task
For each department **that has at least one employee**, report:
the number of employees, the average salary, the lowest salary, the highest salary, and the total payroll.
Employees without a department are ignored.

## Output columns
| column | meaning |
|---|---|
| `department_name` | |
| `employee_count` | number of employees |
| `avg_salary` | average salary **rounded to 2 decimals** |
| `min_salary` | lowest salary |
| `max_salary` | highest salary |
| `total_salary` | sum of salaries |

**Order by** `department_name` ascending.

## Sample output (first row)
```
department_name,employee_count,avg_salary,min_salary,max_salary,total_salary
Engineering,8,130000.00,95000,180000,1040000
...
```

<details><summary>Hint</summary>

One output row per department → `GROUP BY`. Every column in `SELECT` must be grouped or aggregated.
`ROUND(AVG(x), 2)`.
</details>
