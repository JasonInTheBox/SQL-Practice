# 19 · Third-highest salary per department, step by step

## Step 1: rank inside each department
```sql
SELECT name, department_id, salary,
       DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dr
FROM Employee;
```
`PARTITION BY department_id` splits the table into one mini-table per department and ranks each
separately. Engineering's partition:

| name | salary | ROW_NUMBER | RANK | **DENSE_RANK** |
|---|---:|---:|---:|---:|
| Brian | 180000 | 1 | 1 | 1 |
| Grace | 150000 | 2 | 2 | 2 |
| Henry | 150000 | 3 | 2 | 2 |
| Irene | 130000 | 4 | 4 | **3** |
| Jack  | 120000 | 5 | 5 | 4 |
| Karen | 120000 | 6 | 5 | 4 |
| …     |        |   |   |   |

- `DENSE_RANK = 3` → **Irene** ✔ (third distinct salary level)
- `RANK = 3` → nobody (Engineering would vanish) ✘
- `ROW_NUMBER = 3` → Henry, who earns the *2nd* distinct salary ✘

## Step 2: filter outside the window
Window values can't be used in the same query's `WHERE`, so wrap step 1 in a CTE and filter
`WHERE dr = 3`.

## Step 3: join for the department name
`JOIN Department` gives `department_name`. It's an INNER join, so the contractor's NULL partition is dropped.

## Edge cases in the result
- **Finance** `165000, 120000, 85000, 85000` → both Tina and Uma have dr = 3, so two rows.
- **Executive** (1 person) and **HR** (two people tied at 110000) have no third level, so no rows.
