# SQL OA Practice (PostgreSQL + Docker)

27 HackerRank-style SQL exercises with an automatic checker, for the AT&T TDP online assessment
(and any similar SQL screen). Uses a small company / e-commerce database full of edge cases.

```
sql-oa-practice/
├── docker-compose.yml      PostgreSQL 16 in a container
├── CHEATSHEET.md           last-minute pattern review
├── db/schema.sql           tables
├── db/seed.sql             sample data (edge cases commented)
├── exercises/NN-name/
│   ├── prompt.md           the question
│   ├── answer.sql          YOUR query goes here
│   └── expected.csv        the result the checker expects
├── solutions/              official answers (+ .md walkthroughs for hard ones). Don't peek!
└── scripts/                test.ps1, test-all.ps1, reset.ps1, psql.ps1, run.ps1 (+ .sh versions)
```

All commands below are for **PowerShell**, run from the `sql-oa-practice` folder.

---

## 0. One-time setup
1. Install and open **Docker Desktop** (wait until it says *Engine running*).
2. Allow local scripts to run (one time, for your user only):
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
   ```
   If you'd rather not change that, prefix every script with
   `powershell -ExecutionPolicy Bypass -File`, e.g. `powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1 5`.

## 1. Start the database
```powershell
docker compose up -d --wait
```
The first start downloads PostgreSQL (~100 MB) and loads `db/schema.sql` and `db/seed.sql` automatically.
The DB keeps running in the background. Stop it with `docker compose stop`.

## 2. Seed / reset the database
```powershell
.\scripts\reset.ps1
```
Drops all tables and reloads schema + seed. Use it if you ran an `UPDATE`/`DELETE` by accident.
Your `answer.sql` files are not touched.
Full wipe (deletes the container and its data volume, then re-creates it from scratch):
```powershell
docker compose down -v
docker compose up -d --wait
```

## 3. Open PostgreSQL interactively
```powershell
.\scripts\psql.ps1
```
Handy psql commands: `\dt` (list tables) · `\d employee` (describe table) · `\q` (quit).
Look at the data: `SELECT * FROM Employee;`, `SELECT * FROM Orders ORDER BY order_date;`

GUI client instead (DBeaver, pgAdmin, DataGrip, VS Code): host `localhost`, port **5433**,
database `oa`, user `practice`, password `practice`.

## 4. Run arbitrary SQL
```powershell
.\scripts\run.ps1 "SELECT * FROM Department"
.\scripts\run.ps1 -File exercises\05-having-three-orders\answer.sql   # see your answer as a table
```

## 5. Work on one exercise
1. Read `exercises\05-having-three-orders\prompt.md`. The hint is collapsed; open it only if stuck.
2. Write **one** `SELECT` query in `exercises\05-having-three-orders\answer.sql` (in VS Code, Notepad, anything).
3. Tip: run it as a table first with `run.ps1 -File ...` to eyeball it.

## 6. Test one exercise
```powershell
.\scripts\test.ps1 5
```
```
PASS: Exercise 05 (05-having-three-orders)
```
or
```
FAIL: Exercise 05 (05-having-three-orders)
  Hint: expected 6 row(s), received 7.
Expected:
    customer_id,customer_name,order_count
    1,Ava Thompson,6
    ...
Received:
    ...
```
How checking works:
- Your query's rows are compared to `expected.csv` **exactly, including order**.
  Every prompt says how to `ORDER BY`. If your rows are right but the order is wrong, the checker says so.
- Column **values** must match; column **names** are only reported as a note (like HackerRank).
- Numbers must be formatted the same way: use `ROUND(x, 2)` when the prompt says so.

## 7. Test all exercises
```powershell
.\scripts\test-all.ps1              # one line per exercise; untouched ones show SKIP
.\scripts\test-all.ps1 -Detailed    # also show Expected/Received for failures
.\scripts\test-all.ps1 -Solutions   # sanity-check the official solutions (should be 27/27)
```

## 8. View a solution (only after you've tried!)
Open `solutions\05-having-three-orders.sql`. Every solution is commented: what each JOIN does, why
GROUP BY / WHERE / HAVING is used, what each window function and PARTITION BY means, and the traps.
Hard exercises also have a step-by-step `solutions\NN-name.md`.
Run the official solution through the checker with `.\scripts\test.ps1 5 -Solution`.

---

## Exercise list & recommended order
Do them in numeric order. Each one builds on the previous ones.

| # | Exercise | Level | Core skill |
|---|---|---|---|
| 01 | inner-join | Easy | INNER JOIN |
| 02 | self-join-manager | Easy | self join (employee + manager) |
| 03 | left-join-headcount | Easy | LEFT JOIN + COUNT(col) |
| 04 | group-by-department-stats | Easy | COUNT/SUM/AVG/MIN/MAX |
| 05 | having-three-orders | Easy | HAVING |
| 06 | where-vs-having-spenders | Easy/Med | WHERE vs HAVING (> $1,000) |
| 07 | never-ordered-left-join | Easy/Med | rows with no match (LEFT JOIN … IS NULL) |
| 08 | never-ordered-not-exists | Easy/Med | NOT EXISTS |
| 09 | hires-in-date-range | Easy/Med | date range |
| 10 | above-company-average | Easy/Med | scalar subquery |
| 11 | exists-category-buyers | Easy/Med | EXISTS / IN across 3 tables |
| 12 | duplicate-emails | Easy/Med | duplicates, NULL handling |
| 13 | employee-manager-department | Medium | 3-way join (name, manager, dept, salary) |
| 14 | cte-department-vs-company | Medium | CTE, dept avg > company avg |
| 15 | monthly-revenue | Medium | date grouping |
| 16 | ranking-functions | Medium | ROW_NUMBER vs RANK vs DENSE_RANK |
| 17 | nth-highest-salary | Medium | 2nd / 3rd highest (distinct vs not) |
| 18 | top-earner-per-department | Medium | top 1 per group with ties |
| 19 | third-highest-per-department | Medium | Nth highest per group |
| 20 | second-highest-per-department | Med/Hard | rank + LEFT JOIN back, NULLs |
| 21 | top-3-per-department | Med/Hard | top N per group (ROW_NUMBER) |
| 22 | products-unique-customers | Med/Hard | COUNT(DISTINCT) + HAVING |
| 23 | every-quarter-2026 | Hard | "in every X" |
| 24 | top-spender-each-month | Hard | aggregate then rank, NULL sorting |
| 25 | consecutive-months | Hard | LAG / date arithmetic |
| 26 | customers-every-category | Hard | 4-table join, relational division |
| 27 | top-product-per-category | Hard | JOIN + GROUP BY + CTE + window |

**Suggested schedule:** Day 1: 01–08. Day 2: 09–15. Day 3: 16–21 (the window-function core).
Day 4: 22–27. Then re-do everything you failed, timed at **~15 minutes per question**
(the OA gives you 60 minutes for 2 coding + 1 SQL question).
To redo an exercise, clear its `answer.sql` back to just comments.

## Schema
```
Department(id, department_name)
Employee(id, name, department_id -> Department, manager_id -> Employee, salary, hire_date)
Customer(id, name, email, signup_date)
Orders(id, customer_id -> Customer, amount, order_date, status)   status: completed | pending | cancelled
Product(id, name, category, price)                                 categories: Electronics, Books, Home, Sports
OrderItem(id, order_id -> Orders, product_id -> Product, quantity)
```
Table names are case-insensitive (`Employee` = `employee`), as long as you don't put them in double quotes.
The seed has: an employee with no manager, a contractor with no department, many salary ties, two
departments with no employees, customers with no orders, duplicate and case-variant emails, NULL emails,
a NULL order amount, cancelled and pending orders, orders in 2025 and 2026 across all quarters, and
several same-day orders.

## PostgreSQL vs MySQL (HackerRank may use either)
| Need | PostgreSQL | MySQL |
|---|---|---|
| month text | `TO_CHAR(d,'YYYY-MM')` | `DATE_FORMAT(d,'%Y-%m')` |
| quarter | `EXTRACT(QUARTER FROM d)` | `QUARTER(d)` |
| month start | `DATE_TRUNC('month', d)` | `DATE_FORMAT(d,'%Y-%m-01')` |
| add interval | `d + INTERVAL '1 month'` | `DATE_ADD(d, INTERVAL 1 MONTH)` |
| NULL order in DESC | NULLs first | NULLs last |
| string concat | `a \|\| b` | `CONCAT(a, b)` |
| case-insensitive compare | `LOWER(a) = LOWER(b)` / `ILIKE` | default collation is already case-insensitive |
| window functions | yes | MySQL 8+ only |

## Bash (WSL / Git Bash / macOS)
`./scripts/test.sh 5`, `./scripts/test.sh 5 --solution`, `./scripts/test-all.sh [--solutions] [--detailed]`,
`./scripts/reset.sh`, `./scripts/psql.sh`.

## Troubleshooting
- **"The database is not running"**: open Docker Desktop, then `docker compose up -d --wait`.
- **"running scripts is disabled on this system"**: see step 0.2.
- **Port 5433 already in use**: change `"5433:5432"` in `docker-compose.yml` (only matters for GUI clients).
- **Your query errors**: the checker prints PostgreSQL's error message with a line number.
- **Only one statement per answer.sql**: the checker compares *all* output, so extra `SELECT`s break the comparison.
