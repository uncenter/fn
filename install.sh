#!/usr/bin/env bash
set -eo pipefail

install_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
source="https://raw.githubusercontent.com/uncenter/feed-newsboat/main/feed.sh"


if [ -f "$install_dir/feed" ]; then
    echo "It looks like Feed is already installed (at $install_dir/feed). Run \`feed update\` to update to the latest version."
    exit 1
fi
echo "Fetching latest version of Feed..."
download="feed-dl-$(date +%s%N).sh"
curl -fsSL "$source" -o "$download"
chmod +x "$download"
mkdir -p "$install_dir"
mv "$download" "$install_dir/feed"
if [[ ! ":$PATH:" == *":$install_dir:"* ]]; then
    echo "WARNING: $install_dir is not in your PATH. You will need to add it manually to use Feed.\n\texport PATH=\"\$PATH:$install_dir\""
fi
echo "Installed Feed in $install_dir. Run \`feed help\` for usage."
