#!/usr/bin/env bash
# Interactive psql prompt inside the container. \q to quit.
source "$(dirname "$0")/common.sh"
assert_db_running
dc exec db psql -U practice -d oa
