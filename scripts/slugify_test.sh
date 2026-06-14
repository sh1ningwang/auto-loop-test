#!/usr/bin/env bash
# Data-driven tests for slugify.sh. Exits non-zero if any case fails.
set -eu

# Resolve the directory of this test so slugify.sh is found regardless of
# the caller's working directory.
dir="$(cd "$(dirname "$0")" && pwd)"
slugify="$dir/slugify.sh"

fail=0
assert_slug() {
  got="$("$slugify" "$1")"
  if [ "$got" = "$2" ]; then
    echo "PASS: '$1' -> '$got'"
  else
    echo "FAIL: '$1' expected '$2' got '$got'" >&2
    fail=1
  fi
}

assert_slug 'Hello World' 'hello-world'
assert_slug '  Foo__Bar!!  ' 'foo-bar'
assert_slug 'already-a-slug' 'already-a-slug'
assert_slug '' ''

exit "$fail"
