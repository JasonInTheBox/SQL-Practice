# 03 · Department Head-Count (Including Empty Departments)
**Difficulty:** Easy

## Tables
```
Department(id PK, department_name)
Employee(id PK, name, department_id -> Department.id [nullable], manager_id [nullable], salary INT, hire_date DATE)
```

## Task
For **every** department, report how many employees it has.
Departments with no employees must appear with a count of **0**.

## Output columns
| column | meaning |
|---|---|
| `department_name` | |
| `employee_count` | number of employees in the department (0 if none) |

**Order by** `employee_count` descending, then `department_name` ascending.

## Sample output (first rows)
```
department_name,employee_count
Engineering,8
...
```

<details><summary>Hint</summary>

"Every department, even with no match" → the department table goes on the **left** of a `LEFT JOIN`.
Be careful: `COUNT(*)` and `COUNT(some_column)` behave differently on NULL-padded rows.
</details>
