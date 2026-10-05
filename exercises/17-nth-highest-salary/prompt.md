# 17 · Second and Third Highest Salary
**Difficulty:** Medium

## Tables
```
Employee(id PK, name, department_id [nullable], manager_id [nullable], salary INT, hire_date DATE)
```

## Task
Return **one row** with three values computed over the whole company:

1. `second_highest_distinct`: the second-highest **distinct** salary.
2. `third_highest_distinct`: the third-highest **distinct** salary.
3. `third_row_salary`: the salary of the employee in **3rd position** when everybody is sorted
   by salary descending (duplicates counted, so this may equal an earlier salary).

If one of these didn't exist, it should be NULL. In this data all three exist.

Example: salaries `100, 90, 90, 80` → second distinct `90`, third distinct `80`, third row `90`.

## Output columns
`second_highest_distinct,third_highest_distinct,third_row_salary` (exactly one row)

<details><summary>Hint</summary>

"Nth highest **distinct**" → `DENSE_RANK() = N`. "Nth row" → `ROW_NUMBER() = N`.
Put the ranks in a CTE, then collapse to a single row, e.g. `MAX(CASE WHEN dr = 2 THEN salary END)`.
Also try the `LIMIT 1 OFFSET N-1` style.
</details>
