# 01 · Employees and Their Departments
**Difficulty:** Easy

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id -> Employee.id [nullable], salary INT, hire_date DATE)
Department(id PK, department_name)
```

## Task
List every employee **who belongs to a department**, together with the name of that department.
Employees without a department must not appear.

## Output columns
| column | meaning |
|---|---|
| `employee_name` | Employee.name |
| `department_name` | Department.department_name |

**Order by** `employee_name` ascending.

## Sample output (first rows)
```
employee_name,department_name
Alice Johnson,Executive
Brian Smith,Engineering
...
```

<details><summary>Hint</summary>

Matching rows from two tables, and you only want rows that match on both sides → `INNER JOIN ... ON`.
</details>
