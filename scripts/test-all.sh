#!/usr/bin/env bash
# Usage: ./scripts/test-all.sh [--solutions] [--detailed]
source "$(dirname "$0")/common.sh"
assert_db_running
use_solution=0; brief=1
for arg in "$@"; do
  case $arg in --solutions) use_solution=1 ;; --detailed) brief=0 ;; esac
done
pass=0; fail=0; skip=0
for d in "$ROOT"/exercises/[0-9][0-9]-*/; do
  n=$(basename "$d" | cut -c1-2)
  test_exercise "$n" "$use_solution" "$brief"
  case $? in 0) pass=$((pass+1)) ;; 2) skip=$((skip+1)) ;; *) fail=$((fail+1)) ;; esac
done
echo
echo "$pass passed, $fail failed, $skip not attempted (of $((pass+fail+skip)))"
[ $fail -eq 0 ]
