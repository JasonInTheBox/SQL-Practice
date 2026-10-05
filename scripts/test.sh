#!/usr/bin/env bash
# Usage: ./scripts/test.sh 5            (your answer)
#        ./scripts/test.sh 5 --solution (official solution)
source "$(dirname "$0")/common.sh"
[ -n "$1" ] || { echo "usage: $0 <exercise-number> [--solution]"; exit 2; }
assert_db_running
use_solution=0; [ "$2" = "--solution" ] && use_solution=1
test_exercise "$1" "$use_solution" 0
[ $? -eq 0 ]
