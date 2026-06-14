#!/usr/bin/env bash
# Convert an arbitrary string into a URL-safe slug.
#
# set -eu (deliberately NOT pipefail): keep behaviour identical across
# macOS bash 3.2 and Linux. pipefail would surface non-fatal SIGPIPE-style
# states from the pipeline below and is not needed for correctness here.
set -eu

# ${1-} (not ${1:-default}): treat a missing AND an empty first argument
# identically as the empty string, so the script never trips set -u on $1.
input="${1-}"

# LC_ALL=C pins the locale for tr/sed so [:upper:]/[:lower:] and the byte
# ranges behave consistently and predictably regardless of the caller's
# locale (bash 3.2 on macOS handles locale-sensitive classes differently
# from glibc). The transform: lowercase, then collapse every run of
# non-[a-z0-9] characters to a single '-', and strip leading/trailing '-'.
result="$(printf '%s' "$input" | LC_ALL=C tr '[:upper:]' '[:lower:]' | LC_ALL=C sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"

# printf over echo: echo is not portable for arbitrary content (flags,
# backslashes); printf '%s\n' always emits the value plus exactly one
# trailing newline. Empty input therefore yields one empty line, exit 0.
printf '%s\n' "$result"
