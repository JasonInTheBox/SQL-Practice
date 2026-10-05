#!/usr/bin/env bash
# Drop every table and reload db/schema.sql + db/seed.sql. answer.sql files are not touched.
source "$(dirname "$0")/common.sh"
assert_db_running
dc exec -T -e PGOPTIONS=--client-min-messages=warning db \
  psql -U practice -d oa -X -q -v ON_ERROR_STOP=1 -f /workspace/db/schema.sql -f /workspace/db/seed.sql \
  && echo "Database reset: schema.sql + seed.sql reloaded."
