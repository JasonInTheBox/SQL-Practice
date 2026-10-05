# 13 · Employee Report: Manager, Department, Salary
**Difficulty:** Medium

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id -> Employee.id [nullable], salary INT, hire_date DATE)
Department(id PK, department_name)
```

## Task
Produce a report of **every** employee with their manager's name, their department's name and their salary.
- The employee with no manager must appear (manager name NULL).
- The employee with no department must appear (department name NULL).

## Output columns
| column | meaning |
|---|---|
| `employee_name` | |
| `manager_name` | NULL if none |
| `department_name` | NULL if none |
| `salary` | |

**Order by** `salary` descending, then `employee_name` ascending.

## Sample output (first rows)
```
employee_name,manager_name,department_name,salary
Alice Johnson,,Executive,250000
Brian Smith,Alice Johnson,Engineering,180000
...
```

<details><summary>Hint</summary>

Two joins hanging off `Employee e`: one to `Employee m`, one to `Department d`.
Count your rows: there are 24 employees, so the result must have 24 rows.
</details>
