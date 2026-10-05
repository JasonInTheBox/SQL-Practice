# 12 · Duplicate Customer Emails
**Difficulty:** Easy / Medium

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
```

## Task
Find email addresses used by **more than one** customer.

- Compare emails **case-insensitively** (`A@X.com` and `a@x.com` are the same address).
- A NULL email is "unknown" and is **not** a duplicate of another NULL.

## Output columns
| column | meaning |
|---|---|
| `email` | the email address in **lower case** |
| `customer_count` | how many customers use it |

**Order by** `email` ascending.

## Output format
```
email,customer_count
...
```

<details><summary>Hint</summary>

`GROUP BY LOWER(email)` + `HAVING COUNT(*) > 1`. What does `GROUP BY` do with NULLs?
</details>
