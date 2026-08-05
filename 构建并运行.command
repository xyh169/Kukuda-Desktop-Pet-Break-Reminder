#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

MODULE_CACHE="$SCRIPT_DIR/.build/module-cache"
mkdir -p "$MODULE_CACHE"

# Pick the first installed SDK that this Swift compiler can actually import.
# This also handles Macs where Command Line Tools were updated in two stages.
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

ARCH_BINARIES=()
for BUILD_ARCH in arm64 x86_64; do
    ARCH_BINARY="$SCRIPT_DIR/.build/Kukuda-$BUILD_ARCH"
    CLANG_MODULE_CACHE_PATH="$MODULE_CACHE" swiftc \
        -sdk "$SDK_PATH" \
        -target "$BUILD_ARCH-apple-macosx13.0" \
        -parse-as-library \
        "$SCRIPT_DIR"/Sources/KiwiBreak/*.swift \
        -o "$ARCH_BINARY" \
        -framework AppKit \
        -framework ServiceManagement
    ARCH_BINARIES+=("$ARCH_BINARY")
done

lipo -create "${ARCH_BINARIES[@]}" -output "$SCRIPT_DIR/.build/Kukuda"

APP_DIR="$SCRIPT_DIR/build/Kukuda.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"
cp "$SCRIPT_DIR/.build/Kukuda" "$MACOS_DIR/Kukuda"
cp "$SCRIPT_DIR/Assets/Kukuda.icns" "$RESOURCES_DIR/Kukuda.icns"
cp "$SCRIPT_DIR/Info.plist" "$CONTENTS_DIR/Info.plist"
chmod +x "$MACOS_DIR/Kukuda"
codesign --force --deep --sign - "$APP_DIR"

if [[ "${KIWI_BREAK_NO_OPEN:-0}" != "1" ]]; then
    open "$APP_DIR"
fi
