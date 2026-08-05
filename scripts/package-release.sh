#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION="$(tr -d '[:space:]' < "$PROJECT_DIR/VERSION")"

cd "$PROJECT_DIR"
KIWI_BREAK_NO_OPEN=1 ./构建并运行.command

DIST_DIR="$PROJECT_DIR/dist"
ARCHIVE="$DIST_DIR/Kukuda-v${VERSION}-macOS-universal.zip"
mkdir -p "$DIST_DIR"
ditto -c -k --sequesterRsrc --keepParent \
    "$PROJECT_DIR/build/Kukuda.app" \
    "$ARCHIVE"

shasum -a 256 "$ARCHIVE" > "$ARCHIVE.sha256"
echo "$ARCHIVE"

