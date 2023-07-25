#!/usr/bin/env bash
set -eo pipefail

install_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
source="https://raw.githubusercontent.com/uncenter/fn/main/fn.sh"
name="fn"


if [ -f "$install_dir/$name" ]; then
    echo "It looks like \`$name\` is already installed (at $install_dir/$name). Run \`$name update\` to update to the latest version."
    exit 1
fi
download="$name-dl-$(date +%s%N).sh"
curl -fsSL "$source" -o "$download"
chmod +x "$download"
mkdir -p "$install_dir"
mv "$download" "$install_dir/$name"
if [[ ! ":$PATH:" == *":$install_dir:"* ]]; then
    echo "WARNING: $install_dir is not in your PATH. You will need to add it manually to use \`$name\`.\n\texport PATH=\"\$PATH:$install_dir\""
fi
echo "Installed \`$name\` in $install_dir. Run \`$name help\` for usage."
