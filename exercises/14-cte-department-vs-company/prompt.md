# 14 · Departments Above the Company Average
**Difficulty:** Medium

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id [nullable], salary INT, hire_date DATE)
Department(id PK, department_name)
```

## Task
Find departments whose **average salary** is greater than the **company-wide average salary**.
The company-wide average is over **all** employees (including anyone without a department).

**Practice requirement:** write it with at least one CTE (`WITH ... AS (...)`).
**Bonus:** rewrite it without a CTE using `HAVING` and a scalar subquery.

## Output columns
| column | meaning |
|---|---|
| `department_name` | |
| `avg_salary` | department average, **rounded to 2 decimals** |

**Order by** `avg_salary` descending.

## Output format
```
department_name,avg_salary
...
```

<details><summary>Hint</summary>

CTE 1: the company average (one row). CTE 2: average per department.
Then compare them (a `CROSS JOIN` against a one-row CTE is a common trick).
</details>
