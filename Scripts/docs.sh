#!/bin/bash
#
# Mosaic – Michael's SwiftUI Toolkit
# Copyright 2025-2026 Wells Consulting.
#
# Builds the DocC guides for iOS and macOS. A warning from this repo fails the
# run. Warnings from Motley are ignored until its documentation release is
# clean; at that point this script can pass --warnings-as-errors instead.
#
#   Scripts/docs.sh

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${TMPDIR:-/tmp}/mosaic-docs"
FAILED=0

build() {
    local platform="$1"
    local destination="$2"
    local derived_data="$OUT/$platform"
    local log="$OUT/$platform.log"

    mkdir -p "$OUT"
    rm -rf "$derived_data"

    if ! xcodebuild docbuild \
        -scheme Mosaic \
        -destination "$destination" \
        -derivedDataPath "$derived_data" \
        -quiet >"$log" 2>&1; then
        echo "FAIL  $platform docs did not build"
        grep -E "error:" "$log" | head -20
        FAILED=1
        return
    fi

    local own
    own="$(grep -E "warning:|error:" "$log" |
        grep -v "SourcePackages/checkouts/Motley" |
        sort -u)"

    if [ -n "$own" ]; then
        echo "FAIL  $platform docs have warnings from this repo"
        printf '%s\n' "$own" | head -20
        FAILED=1
    else
        echo "ok    $platform docs"
    fi
}

cd "$ROOT" || exit 1

build ios "generic/platform=iOS"
build macos "generic/platform=macOS"

if [ "$FAILED" -ne 0 ]; then
    exit 1
fi
