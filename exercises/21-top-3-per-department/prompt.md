# 21 · Top 3 Earners per Department
**Difficulty:** Medium / Hard

## Tables
```
Employee(id PK, name, department_id -> Department.id [nullable], manager_id [nullable], salary INT, hire_date DATE)
Department(id PK, department_name)
```

## Task
For each department, list **at most 3 employees**: the three highest paid.
- If two employees have the same salary, the one with the **earlier `hire_date`** ranks higher
  (and if that also ties, the lower `id`).
- Departments with fewer than 3 employees list everyone they have.
- Employees without a department are ignored.

## Output columns
| column | meaning |
|---|---|
| `department_name` | |
| `employee_name` | |
| `salary` | |
| `position` | 1, 2 or 3 within the department |

**Order by** `department_name` ascending, then `position` ascending.

## Sample output (first rows)
```
department_name,employee_name,salary,position
Engineering,Brian Smith,180000,1
...
```

<details><summary>Hint</summary>

"At most N **people** per group" → `ROW_NUMBER()` (always unique), with the tie-breakers in the window's `ORDER BY`.
Why would `DENSE_RANK() <= 3` be wrong here?
</details>
