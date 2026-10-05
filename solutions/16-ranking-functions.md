# 16 · ROW_NUMBER vs RANK vs DENSE_RANK, worked

Top of the company, sorted by salary DESC (ties broken by id for ROW_NUMBER):

| id | name | salary | ROW_NUMBER | RANK | DENSE_RANK |
|---:|---|---:|---:|---:|---:|
| 1 | Alice | 250000 | 1 | 1 | 1 |
| 2 | Brian | 180000 | 2 | **2** | **2** |
| 3 | Carla | 180000 | 3 | **2** | **2** |
| 4 | David | 165000 | 4 | **4** | **3** |
| 7 | Grace | 150000 | 5 | 5 | 4 |
| 8 | Henry | 150000 | 6 | 5 | 4 |
| 5 | Emma  | 140000 | 7 | 7 | 5 |

## The rules
- **ROW_NUMBER** counts rows: 1, 2, 3, 4 … It's always unique, even for ties.
  Which tied row gets the lower number depends on the `ORDER BY` inside `OVER()`. With no
  tie-breaker it's arbitrary, so always add one (here `id`).
- **RANK** works like a race: two runners tied for 2nd both get 2, and the next runner is **4th**
  (rank = 1 + number of rows strictly ahead of you). There is no rank 3.
- **DENSE_RANK** is like RANK but never skips: the next value after 2, 2 is **3**.
  So `DENSE_RANK = N` ⇔ "the Nth highest **distinct** value".

## Which one do I need?
| Question | Function |
|---|---|
| "Nth highest **distinct** salary" | `DENSE_RANK() = N` |
| "Top N **people**" (exactly N rows per group) | `ROW_NUMBER() <= N` |
| "Highest-paid employee(s), include ties" | `RANK() = 1` or `DENSE_RANK() = 1` (same result for rank 1) |
| "Position in a leaderboard with gaps" (like sports) | `RANK()` |

## Evaluation order (why you need a CTE to filter)
`FROM → WHERE → GROUP BY → HAVING → window functions → SELECT → ORDER BY → LIMIT`

Window functions run **after** WHERE, so `WHERE DENSE_RANK() OVER (...) = 3` is illegal.
Compute the rank in a CTE or subquery, then filter on it outside.
