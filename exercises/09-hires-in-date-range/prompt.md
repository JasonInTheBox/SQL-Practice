# 09 · Employees Hired in a Date Range
**Difficulty:** Easy / Medium

## Tables
```
Employee(id PK, name, department_id [nullable], manager_id [nullable], salary INT, hire_date DATE)
```

## Task
List employees hired between **2020-01-01 and 2022-12-31, inclusive** of both dates.

## Output columns
| column | meaning |
|---|---|
| `employee_name` | |
| `hire_date` | format `YYYY-MM-DD` (the default) |

**Order by** `hire_date` ascending, then `employee_name` ascending.

## Sample output (first row)
```
employee_name,hire_date
Irene Novak,2020-01-06
...
```

<details><summary>Hint</summary>

`BETWEEN a AND b` includes both ends. Alternative that's safe for timestamps too:
`hire_date >= '2020-01-01' AND hire_date < '2023-01-01'`.
</details>
