-- 12 - Duplicates: emails used by more than one customer (case-insensitive)
--
-- LOWER(email): 'Ben.Carter@Example.com' and 'ben.carter@example.com' are the same
--   mailbox, so normalise before grouping.
-- WHERE email IS NOT NULL: GROUP BY puts all NULLs into ONE group, so Lena and
--   Mason (both NULL) would look like a "duplicate" of 2. NULL means "unknown",
--   not "equal", so remove them first (row filter -> WHERE).
-- GROUP BY LOWER(email): one group per distinct normalised email.
-- HAVING COUNT(*) > 1: keep only groups with more than one customer (group filter).
--
-- MySQL note: with its default case-insensitive collation MySQL already treats the
-- two Ben emails as equal; LOWER() makes the intent explicit and portable.
SELECT
    LOWER(email) AS email,
    COUNT(*)     AS customer_count
FROM Customer
WHERE email IS NOT NULL
GROUP BY LOWER(email)
HAVING COUNT(*) > 1
ORDER BY email;
