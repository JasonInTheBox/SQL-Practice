-- =====================================================================
-- Schema for the SQL OA practice database.
--
-- Table names are written in PascalCase to match HackerRank-style prompts.
-- PostgreSQL folds unquoted identifiers to lower case, so
--   Employee, employee, EMPLOYEE   all refer to the same table.
-- (Just never wrap them in double quotes, e.g. "Employee".)
-- =====================================================================

DROP TABLE IF EXISTS OrderItem CASCADE;
DROP TABLE IF EXISTS Orders     CASCADE;
DROP TABLE IF EXISTS Product    CASCADE;
DROP TABLE IF EXISTS Customer   CASCADE;
DROP TABLE IF EXISTS Employee   CASCADE;
DROP TABLE IF EXISTS Department CASCADE;

CREATE TABLE Department (
    id              INTEGER PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
    id            INTEGER PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    department_id INTEGER REFERENCES Department(id),   -- NULL = contractor, no department
    manager_id    INTEGER REFERENCES Employee(id),     -- NULL = no manager (the CEO)
    salary        INTEGER NOT NULL,
    hire_date     DATE    NOT NULL
);

CREATE TABLE Customer (
    id          INTEGER PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    email       VARCHAR(100),                          -- may be NULL
    signup_date DATE NOT NULL
);

CREATE TABLE Orders (
    id          INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES Customer(id),
    amount      NUMERIC(10,2),                         -- NULL = not yet priced
    order_date  DATE NOT NULL,
    status      VARCHAR(20) NOT NULL                   -- completed | pending | cancelled
);

CREATE TABLE Product (
    id       INTEGER PRIMARY KEY,
    name     VARCHAR(50) NOT NULL,
    category VARCHAR(30) NOT NULL,
    price    NUMERIC(10,2) NOT NULL
);

CREATE TABLE OrderItem (
    id         INTEGER PRIMARY KEY,
    order_id   INTEGER NOT NULL REFERENCES Orders(id),
    product_id INTEGER NOT NULL REFERENCES Product(id),
    quantity   INTEGER NOT NULL
);
