# 20 · Second-Highest Salary for Every Department
**Difficulty:** Medium / Hard

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id [nullable], salary INT, hire_date DATE)
Department(id PK, department_name)
```

## Task
For **every** department (including departments with no employees), report the **second-highest distinct salary**.
If a department has no second-highest distinct salary, report NULL.

Each department appears **exactly once**.

## Output columns
| column | meaning |
|---|---|
| `department_name` | |
| `second_highest_salary` | NULL if it doesn't exist |

**Order by** `department_name` ascending.

## Output format
```
department_name,second_highest_salary
...
```

<details><summary>Hint</summary>

1. Rank salaries per department with `DENSE_RANK`.
2. Keep rank 2. Several people can share that salary, so how do you avoid duplicates?
3. Start from `Department` and `LEFT JOIN` the result so every department survives.
</details>
