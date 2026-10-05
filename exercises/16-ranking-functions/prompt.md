# 16 · ROW_NUMBER vs RANK vs DENSE_RANK
**Difficulty:** Medium

## Tables
```
Employee(id PK, name, department_id [nullable], manager_id [nullable], salary INT, hire_date DATE)
```

## Task
Rank **all** employees by salary, highest first, using all three ranking functions side by side.

- `row_num`: `ROW_NUMBER()`. For equal salaries, the lower `id` gets the smaller number.
- `salary_rank`: `RANK()` by salary.
- `dense_salary_rank`: `DENSE_RANK()` by salary.

Once it passes, study the output (expected.csv) around the tied salaries until you can explain every number.

## Output columns
| column | meaning |
|---|---|
| `id` | Employee.id |
| `employee_name` | |
| `salary` | |
| `row_num` | ROW_NUMBER |
| `salary_rank` | RANK |
| `dense_salary_rank` | DENSE_RANK |

**Order by** `salary` descending, then `id` ascending.

## Sample output (first rows)
```
id,employee_name,salary,row_num,salary_rank,dense_salary_rank
1,Alice Johnson,250000,1,1,1
2,Brian Smith,180000,2,2,2
3,Carla Gomez,180000,3,2,2
4,David Lee,165000,4,?,?
...
```
(What are the two `?` values? Decide before you run it.)

<details><summary>Hint</summary>

```sql
ROW_NUMBER() OVER (ORDER BY salary DESC, id)
```
Avoid naming a column `rank`: it is a reserved word in MySQL 8.
</details>
