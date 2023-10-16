#!/usr/bin/env bash
set -eo pipefail

install_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
source="https://github.com/uncenter/fn/releases/latest/download/fn.sh"
name="fn"

if [ -f "$install_dir/$name" ]; then
    echo "It looks like \`$name\` is already installed (at $install_dir/$name). Run \`$name update\` to update to the latest version."; exit 1
fi
download="$(mktemp)"
curl -fsSL "$source" -o "$download"
chmod +x "$download"
mkdir -p "$install_dir"
mv "$download" "$install_dir/$name"
echo "Installed \`$name\` in $install_dir. Run \`$name help\` for usage."
