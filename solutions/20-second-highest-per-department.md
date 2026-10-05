# 20 · Second-highest salary for every department, step by step

## Why it's harder than #19
#19 returns only departments that *have* a 3rd salary. Here **every** department must appear
exactly once, with NULL where the value doesn't exist. That's a "rank, then LEFT JOIN back" pattern.

## Step 1 · `ranked`: DENSE_RANK per department
```
department  salary  dr
Engineering 180000  1
Engineering 150000  2   <- Grace
Engineering 150000  2   <- Henry   (two rows with dr = 2!)
...
HR          110000  1   <- Frank
HR          110000  1   <- Victor  (no dr = 2 in HR at all)
```
`WHERE department_id IS NOT NULL` drops Wendy; otherwise she'd form a "NULL department" partition.

## Step 2 · `second`: one row per department
`SELECT DISTINCT department_id, salary FROM ranked WHERE dr = 2`.
Without DISTINCT, Engineering has two rows (Grace & Henry), and after the join it would appear twice.

## Step 3 · start from Department, LEFT JOIN `second`
`Department` has all 8 departments. LEFT JOIN keeps each one; those with no row in `second`
(Executive, HR, Legal, Research) get NULL.

## Alternative without window functions
```sql
SELECT d.department_name,
       (SELECT MAX(e.salary)
        FROM Employee e
        WHERE e.department_id = d.id
          AND e.salary < (SELECT MAX(x.salary) FROM Employee x WHERE x.department_id = d.id)
       ) AS second_highest_salary
FROM Department d
ORDER BY d.department_name;
```
"Second highest = the largest salary that is smaller than the maximum." A correlated scalar
subquery returns NULL when nothing qualifies, which handles the edge cases for free. It runs
once per department; fine for small data, but the window version scales better.
