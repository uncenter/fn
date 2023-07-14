#!/usr/bin/env bash
set -eo pipefail

install_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
script_url="https://raw.githubusercontent.com/uncenter/feed-newsboat/main/feed.sh"


if [ -f "$install_dir/feed" ]; then
    echo "It looks like feed is already installed (at $install_dir/feed). Run \`feed update\` to update to the latest version."
    exit 1
fi
echo "Fetching latest version of feed..."
feed_download="feed-latest-$(date +%s%N).sh"
curl -fsSL "$script_url" -o "$feed_download"
chmod +x "$feed_download"
mkdir -p "$install_dir"
mv "$feed_download" "$install_dir/feed"
if [[ ! ":$PATH:" == *":$install_dir:"* ]]; then
    echo "WARNING: $install_dir is not in your PATH. You will need to add it manually to use feed.\n\texport PATH=\"\$PATH:$install_dir\""
fi
echo "Installed feed in $install_dir. Run \`feed help\` for usage."
