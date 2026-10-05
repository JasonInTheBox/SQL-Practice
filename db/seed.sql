-- =====================================================================
-- Seed data. Small enough to check by hand, but full of edge cases.
-- Edge cases are called out in comments so you can predict results.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Department
--   Legal (7) and Research (8) have NO employees.
-- ---------------------------------------------------------------------
INSERT INTO Department (id, department_name) VALUES
(1, 'Executive'),
(2, 'Engineering'),
(3, 'Sales'),
(4, 'Marketing'),
(5, 'Finance'),
(6, 'HR'),
(7, 'Legal'),
(8, 'Research');

-- ---------------------------------------------------------------------
-- Employee
--   * Alice (1) has no manager (manager_id NULL).
--   * Wendy (23) is a contractor with NO department (department_id NULL).
--   * Salary ties:
--       180000  Brian & Carla        (company-wide 2nd place tie)
--       150000  Grace & Henry        (Engineering)
--       120000  Jack, Karen, Samuel
--       110000  Frank & Victor       (HR: tie for the TOP salary)
--        95000  Leo & Yusuf
--        90000  Maria & Nathan       (Sales)
--        85000  Tina & Uma           (Finance)
--   * Karen was hired on 2022-12-31 (date-range boundary).
-- ---------------------------------------------------------------------
INSERT INTO Employee (id, name, department_id, manager_id, salary, hire_date) VALUES
(1,  'Alice Johnson', 1,    NULL, 250000, '2015-03-01'),
(2,  'Brian Smith',   2,    1,    180000, '2016-06-15'),
(3,  'Carla Gomez',   3,    1,    180000, '2016-09-01'),
(4,  'David Lee',     5,    1,    165000, '2017-01-10'),
(5,  'Emma Davis',    4,    1,    140000, '2018-02-20'),
(6,  'Frank Wilson',  6,    1,    110000, '2018-05-05'),
(7,  'Grace Kim',     2,    2,    150000, '2019-03-11'),
(8,  'Henry Patel',   2,    2,    150000, '2019-07-22'),
(9,  'Irene Novak',   2,    7,    130000, '2020-01-06'),
(10, 'Jack Brown',    2,    7,    120000, '2021-04-19'),
(11, 'Karen White',   2,    8,    120000, '2022-12-31'),
(12, 'Leo Martinez',  2,    8,     95000, '2023-02-14'),
(13, 'Maria Garcia',  3,    3,     90000, '2019-11-04'),
(14, 'Nathan Young',  3,    3,     90000, '2020-03-16'),
(15, 'Olivia Turner', 3,    13,    75000, '2021-06-01'),
(16, 'Paul Walker',   3,    13,    68000, '2024-01-08'),
(17, 'Quinn Harris',  4,    5,     98000, '2020-09-14'),
(18, 'Rachel Adams',  4,    17,    72000, '2023-05-22'),
(19, 'Samuel Clark',  5,    4,    120000, '2018-10-01'),
(20, 'Tina Lewis',    5,    19,    85000, '2022-03-28'),
(21, 'Uma Rao',       5,    19,    85000, '2024-07-15'),
(22, 'Victor Hall',   6,    6,    110000, '2025-01-13'),
(23, 'Wendy Scott',   NULL, 2,     70000, '2025-06-02'),
(24, 'Yusuf Ali',     2,    7,     95000, '2025-09-01');

-- ---------------------------------------------------------------------
-- Customer
--   * 10 is a second "Ava Thompson" with the SAME email as 1 (exact duplicate).
--   * 11 is a second "Ben Carter" whose email differs from 2 only by case.
--   * 13 and 14 have NULL email (two NULLs are NOT duplicates of each other).
--   * 8, 9, 11, 15 never placed any order.
--   * 14 placed only a cancelled order.
-- ---------------------------------------------------------------------
INSERT INTO Customer (id, name, email, signup_date) VALUES
(1,  'Ava Thompson', 'ava.thompson@example.com', '2025-11-03'),
(2,  'Ben Carter',   'ben.carter@example.com',   '2025-12-10'),
(3,  'Chloe Nguyen', 'chloe.nguyen@example.com', '2026-01-05'),
(4,  'Daniel Kim',   'daniel.kim@example.com',   '2026-01-20'),
(5,  'Ella Brooks',  'ella.brooks@example.com',  '2026-02-02'),
(6,  'Felix Romero', 'felix.romero@example.com', '2026-02-14'),
(7,  'Gina Park',    'gina.park@example.com',    '2026-03-01'),
(8,  'Hugo Silva',   'hugo.silva@example.com',   '2026-03-15'),
(9,  'Isla Murphy',  'isla.murphy@example.com',  '2026-04-04'),
(10, 'Ava Thompson', 'ava.thompson@example.com', '2026-05-10'),
(11, 'Ben Carter',   'Ben.Carter@Example.com',   '2026-05-11'),
(12, 'Kai Morgan',   'kai.morgan@example.com',   '2026-05-22'),
(13, 'Lena Fischer', NULL,                       '2026-06-01'),
(14, 'Mason Reed',   NULL,                       '2026-06-18'),
(15, 'Nora Bell',    'nora.bell@example.com',    '2026-07-07');

-- ---------------------------------------------------------------------
-- Product
--   4 categories. Tennis Racket (13) has never been sold.
-- ---------------------------------------------------------------------
INSERT INTO Product (id, name, category, price) VALUES
(1,  'Wireless Mouse',        'Electronics',  25.00),
(2,  'Mechanical Keyboard',   'Electronics', 120.00),
(3,  'Monitor 27in',          'Electronics', 300.00),
(4,  'Headphones',            'Electronics', 200.00),
(5,  'SQL Pocket Guide',      'Books',        15.00),
(6,  'Algorithms Textbook',   'Books',        85.00),
(7,  'Mystery Novel',         'Books',        12.00),
(8,  'Coffee Maker',          'Home',         90.00),
(9,  'Desk Lamp',             'Home',         40.00),
(10, 'Throw Blanket',         'Home',         35.00),
(11, 'Yoga Mat',              'Sports',       30.00),
(12, 'Dumbbell Set',          'Sports',      150.00),
(13, 'Tennis Racket',         'Sports',      180.00);

-- ---------------------------------------------------------------------
-- Orders
--   amount = SUM(quantity * price) of the order's items.
--   * Two orders from 2025 (Ava, Ben) -> watch your year filters.
--   * Ben's 2025-12 and 2026-01 orders are consecutive months across a year boundary.
--   * Cancelled orders: 12 (Ben), 28 (Mason), 29 (Chloe's only Q4 order).
--   * Order 32 is pending with a NULL amount and no items.
--   * Same-date orders: 2026-01-10, 2026-03-20, 2026-04-12, 2026-06-02, 2026-10-02.
-- ---------------------------------------------------------------------
INSERT INTO Orders (id, customer_id, amount, order_date, status) VALUES
(1,  1,    85.00, '2025-12-15', 'completed'),
(2,  2,   120.00, '2025-12-20', 'completed'),
(3,  1,    65.00, '2026-01-10', 'completed'),
(4,  2,   300.00, '2026-01-10', 'completed'),
(5,  3,    59.00, '2026-01-18', 'completed'),
(6,  4,   200.00, '2026-02-03', 'completed'),
(7,  1,    90.00, '2026-02-14', 'completed'),
(8,  5,    55.00, '2026-03-02', 'completed'),
(9,  5,    30.00, '2026-03-09', 'completed'),
(10, 5,    40.00, '2026-03-20', 'completed'),
(11, 6,  1035.00, '2026-03-20', 'completed'),
(12, 2,   450.00, '2026-03-28', 'cancelled'),
(13, 1,   380.00, '2026-04-05', 'completed'),
(14, 3,    25.00, '2026-04-12', 'completed'),
(15, 4,   100.00, '2026-04-12', 'completed'),
(16, 2,    80.00, '2026-05-07', 'completed'),
(17, 7,   225.00, '2026-05-15', 'completed'),
(18, 7,    70.00, '2026-06-02', 'completed'),
(19, 12,   12.00, '2026-06-02', 'completed'),
(20, 10,   25.00, '2026-06-20', 'completed'),
(21, 1,   460.00, '2026-07-04', 'completed'),
(22, 4,   150.00, '2026-07-19', 'completed'),
(23, 3,    90.00, '2026-08-01', 'completed'),
(24, 2,   240.00, '2026-08-15', 'completed'),
(25, 7,   162.00, '2026-08-22', 'completed'),
(26, 13,  120.00, '2026-09-03', 'completed'),
(27, 12,  120.00, '2026-09-10', 'completed'),
(28, 14,  315.00, '2026-09-12', 'cancelled'),
(29, 3,    85.00, '2026-10-01', 'cancelled'),
(30, 1,    25.00, '2026-10-02', 'pending'),
(31, 4,    47.00, '2026-10-02', 'completed'),
(32, 6,     NULL, '2026-10-03', 'pending');

-- ---------------------------------------------------------------------
-- OrderItem
-- ---------------------------------------------------------------------
INSERT INTO OrderItem (id, order_id, product_id, quantity) VALUES
(1,  1,  6,  1),
(2,  2,  2,  1),
(3,  3,  1,  2),
(4,  3,  5,  1),
(5,  4,  3,  1),
(6,  5,  7,  2),
(7,  5,  10, 1),
(8,  6,  4,  1),
(9,  7,  8,  1),
(10, 8,  11, 1),
(11, 8,  1,  1),
(12, 9,  5,  2),
(13, 10, 9,  1),
(14, 11, 3,  3),
(15, 11, 2,  1),
(16, 11, 5,  1),
(17, 12, 12, 1),
(18, 12, 3,  1),
(19, 13, 12, 1),
(20, 13, 11, 1),
(21, 13, 4,  1),
(22, 14, 1,  1),
(23, 15, 6,  1),
(24, 15, 5,  1),
(25, 16, 9,  2),
(26, 17, 4,  1),
(27, 17, 1,  1),
(28, 18, 10, 2),
(29, 19, 7,  1),
(30, 20, 1,  1),
(31, 21, 2,  1),
(32, 21, 9,  1),
(33, 21, 3,  1),
(34, 22, 11, 2),
(35, 22, 8,  1),
(36, 23, 8,  1),
(37, 24, 4,  1),
(38, 24, 5,  1),
(39, 24, 1,  1),
(40, 25, 12, 1),
(41, 25, 7,  1),
(42, 26, 2,  1),
(43, 27, 2,  1),
(44, 28, 3,  1),
(45, 28, 5,  1),
(46, 29, 6,  1),
(47, 30, 1,  1),
(48, 31, 7,  1),
(49, 31, 10, 1);
