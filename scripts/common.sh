#!/usr/bin/env bash
# Shared helpers for the bash scripts (macOS/Linux/WSL/Git Bash). Sourced, not run directly.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Stop Git Bash on Windows from rewriting /workspace/... into C:/Program Files/Git/workspace/...
export MSYS_NO_PATHCONV=1

# Run compose from the project folder (instead of -f <path>) so no host path needs converting.
dc() { (cd "$ROOT" && docker compose "$@"); }

psql_exec() { dc exec -T db psql -U practice -d oa -X -q -v ON_ERROR_STOP=1 "$@"; }

assert_db_running() {
  if ! dc exec -T db pg_isready -U practice -d oa >/dev/null 2>&1; then
    echo "The database is not running. Start it first:  docker compose up -d --wait" >&2
    exit 2
  fi
}

exercise_dir() {  # exercise_dir 5  ->  /path/exercises/05-xxx
  local prefix d
  prefix=$(printf '%02d-' "$((10#$1))")
  for d in "$ROOT"/exercises/"$prefix"*/; do
    [ -d "$d" ] && { echo "${d%/}"; return 0; }
  done
  echo "No exercise folder starting with '$prefix'" >&2
  return 1
}

sql_is_empty() {  # true if the file has only comments/whitespace
  [ -z "$(sed -e 's/--.*$//' "$1" | tr -d '[:space:]')" ]
}

clean() { tr -d '\r' | sed -e 's/[[:space:]]*$//' | grep -v '^$'; }

# test_exercise <number> <use_solution 0|1> <brief 0|1>; prints PASS/FAIL/SKIP line, returns 0/1/2
test_exercise() {
  local n=$1 use_solution=$2 brief=$3 dir name label local_file container
  dir=$(exercise_dir "$n") || return 1
  name=$(basename "$dir")
  label="Exercise $(printf '%02d' "$((10#$n))") ($name)"
  if [ "$use_solution" = 1 ]; then
    local_file="$ROOT/solutions/$name.sql"; container="/workspace/solutions/$name.sql"
    label="$label [official solution]"
  else
    local_file="$dir/answer.sql"; container="/workspace/exercises/$name/answer.sql"
  fi

  if sql_is_empty "$local_file"; then
    echo "SKIP: $label - no query written yet"; return 2
  fi

  local out status expected
  out=$(psql_exec --csv -f "$container" 2>&1); status=$?
  expected=$(clean < "$dir/expected.csv")
  out=$(printf '%s\n' "$out" | clean)

  if [ $status -ne 0 ]; then
    echo "FAIL: $label"
    [ "$brief" = 1 ] || { echo "Your query raised an error:"; printf '%s\n' "$out" | sed 's/^/    /'; }
    return 1
  fi

  local exp_rows got_rows
  exp_rows=$(printf '%s\n' "$expected" | tail -n +2)
  got_rows=$(printf '%s\n' "$out" | tail -n +2)
  if [ -n "$out" ] && [ "$exp_rows" = "$got_rows" ]; then
    echo "PASS: $label"
    return 0
  fi

  echo "FAIL: $label"
  if [ "$brief" != 1 ]; then
    if [ -z "$out" ]; then
      echo "  Your query produced no output at all."
    elif [ "$(printf '%s\n' "$exp_rows" | sort)" = "$(printf '%s\n' "$got_rows" | sort)" ]; then
      echo "  Hint: right rows, WRONG ORDER. Check your ORDER BY against prompt.md."
    fi
    echo "Expected:"; printf '%s\n' "$expected" | sed 's/^/    /'
    echo "Received:"; printf '%s\n' "$out" | sed 's/^/    /'
  fi
  return 1
}
