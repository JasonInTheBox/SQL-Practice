# 02 · Employee and Manager Names
**Difficulty:** Easy

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id -> Employee.id [nullable], salary INT, hire_date DATE)
```
`manager_id` holds the `id` of another row in the **same** table.

## Task
Display **every** employee with the name of their manager.
An employee who has no manager must still appear, with an empty (NULL) manager name.

## Output columns
| column | meaning |
|---|---|
| `employee_name` | the employee |
| `manager_name` | the manager's name, or NULL |

**Order by** `employee_name` ascending.

## Sample output (first rows)
```
employee_name,manager_name
Alice Johnson,
Brian Smith,Alice Johnson
...
```

<details><summary>Hint</summary>

Join the table to itself with two aliases (`e` for employee, `m` for manager).
Think about which join type keeps the employee who has `manager_id = NULL`.
</details>
