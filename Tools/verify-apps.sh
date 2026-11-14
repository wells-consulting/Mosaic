#!/bin/bash
#
# Mosaic – Michael's SwiftUI Toolkit
# Copyright 2025-2026 Wells Consulting.
#
# Builds and tests every app that links this package. One app compiling doesn't
# prove the other still does, and this package is consumed by more than one.
#
#   Tools/verify-apps.sh
#
# The app checkouts are expected beside this one. Each builds in its own derived
# data under the system's temporary directory, so it never contends with Xcode's,
# and each step's log is kept beside it. Exits non-zero when either app fails.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCES="$(cd "$ROOT/.." && pwd)"
OUT="${TMPDIR:-/tmp}/mosaic-verify-apps"
DESTINATION="platform=macOS"
FAILED=0

verify() {
    local name="$1"
    local project="$2"
    local scheme="$3"

    if [ ! -d "$project" ]; then
        echo "skip   $name — no checkout at $project"
        return
    fi

    mkdir -p "$OUT"
    printf '%-12s test … ' "$name"

    if xcodebuild test \
        -project "$project" \
        -scheme "$scheme" \
        -destination "$DESTINATION" \
        -derivedDataPath "$OUT/$name" \
        >"$OUT/$name.log" 2>&1; then
        local summary
        summary="$(grep -oE "Test run with [0-9]+ tests" "$OUT/$name.log" | tail -1)"
        if [ -z "$summary" ]; then
            local count
            count="$(grep -c "passed on '" "$OUT/$name.log")"
            summary="$count tests"
        fi
        echo "ok${summary:+ ($summary)}"
    else
        echo "FAILED — see $OUT/$name.log"
        FAILED=1
    fi
}

verify the app "$SOURCES/the app/the app.xcodeproj" the app
verify the app "$SOURCES/the app/the app.xcodeproj" the app

if [ "$FAILED" -ne 0 ]; then
    echo "FAIL  one of the apps doesn't build against this package"
    exit 1
fi

echo "ok    every app builds and passes"
