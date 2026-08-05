#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

MODULE_CACHE="$SCRIPT_DIR/.build/module-cache"
mkdir -p "$MODULE_CACHE"

SDK_PATH=""
SDK_CANDIDATES=(/Library/Developer/CommandLineTools/SDKs/MacOSX*.sdk(N))
for candidate in "${SDK_CANDIDATES[@]}"; do
    if printf 'import Foundation\n' | CLANG_MODULE_CACHE_PATH="$MODULE_CACHE" \
        swiftc -sdk "$candidate" -typecheck - >/dev/null 2>&1; then
        SDK_PATH="$candidate"
        break
    fi
done

if [[ -z "$SDK_PATH" ]]; then
    SDK_PATH="$(xcrun --sdk macosx --show-sdk-path)"
fi

BUILD_ARCH="$(uname -m)"
CLANG_MODULE_CACHE_PATH="$MODULE_CACHE" swiftc \
    -sdk "$SDK_PATH" \
    -target "$BUILD_ARCH-apple-macosx13.0" \
    -parse-as-library \
    Sources/KiwiBreak/BreakSessionState.swift \
    Sources/KiwiBreak/ReminderMessages.swift \
    Tests/ManualTests.swift \
    -o .build/KukudaLogicTests

.build/KukudaLogicTests
