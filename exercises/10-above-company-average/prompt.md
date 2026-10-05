# 10 · Employees Paid Above the Company Average
**Difficulty:** Easy / Medium

## Tables
```
Employee(id PK, name, department_id [nullable], manager_id [nullable], salary INT, hire_date DATE)
```

## Task
List employees whose salary is **strictly greater** than the average salary of **all** employees in the company.

## Output columns
| column | meaning |
|---|---|
| `employee_name` | |
| `salary` | |

**Order by** `salary` descending, then `employee_name` ascending.

## Sample output (first row)
```
employee_name,salary
Alice Johnson,250000
...
```

<details><summary>Hint</summary>

You can't write `WHERE salary > AVG(salary)`. Compute the average in a **scalar subquery** `(SELECT AVG(...) FROM ...)`.
</details>
