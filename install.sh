#!/usr/bin/env bash

install_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
artifact_url="https://raw.githubusercontent.com/uncenter/feed-newsboat/main/feed.sh"

remove() {
    location="${1:-$install_dir}"
    if [ -f "$location/feed" ]; then
        read -r -n 1 -p "Located feed in $location. Confirm removal? [y/N] " REPLY
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$location/feed"
            echo "Removed feed."
            return 0
        else
            echo "Removal cancelled."
            return 0
        fi
    fi
    echo "Failed to locate feed in $location."
    return 1
}

install() {
    location="${1:-$install_dir}"
    if [ -f "$location/feed" ]; then
        echo "It looks like feed is already installed (at $location/feed). Run \`feed update\` to update to the latest version."
        return 1
    fi
    echo "Fetching latest version of feed..."
    feed_download="feed-latest-$(date +%s%N).sh"
    curl -fsSL "$artifact_url" -o "$feed_download"
    chmod +x "$feed_download"
    mkdir -p "$location"
    mv "$feed_download" "$location/feed"
    if [[ ! ":$PATH:" == *":$location:"* ]]; then
        echo "WARNING: $location is not in your PATH. You will need to add it manually to use feed.\n\texport PATH=\"\$PATH:$location\""
    fi
    echo "Installed feed in $location. Run \`feed help\` for usage."
}

update() {
    location="${1:-$install_dir}"
    if [ ! -f "$location/feed" ]; then
        echo "It looks like feed is not installed (at $location/feed)."
        return 1
    fi
    echo "Fetching latest version of feed..."

    feed_download="feed-latest-$(date +%s%N).sh"
    current_version="$(feed help | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")"
    curl -fsSL "$artifact_url" -o "$feed_download"
    chmod +x "$feed_download"
    latest_version="$(./$feed_download help | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")"
    if [ "$current_version" == "$latest_version" ]; then
        echo "Already up to date."
        rm "$feed_download"
        return 0
    else
        echo "Updating to latest version... ($current_version -> $latest_version)"
    fi
    mkdir -p "$location"
    mv "$feed_download" "$location/feed"
    if [[ ! ":$PATH:" == *":$location:"* ]]; then
        echo "WARNING: $location is not in your PATH. You will need to add it manually to use feed.\n\texport PATH=\"\$PATH:$location\""
    fi
}

case "$1" in
    update|upgrade)
        update
        exit $?
        ;;
    uninstall|remove)
        remove
        exit $?
        ;;
    install)
        install
        exit $?
        ;;
    *)
        if [[ -z "$1" ]]; then
            echo "Usage: $0 [install|update|remove]"
            exit 1
        fi
        ;;
esac

read -r -n 1 -p "Do you want to [i]nstall feed, [u]pdate feed, [r]emove feed, or [e]xit? " REPLY
echo
if [[ $REPLY =~ ^[Ii]$ ]]; then
    install
elif [[ $REPLY =~ ^[Uu]$ ]]; then
    update
elif [[ $REPLY =~ ^[Rr]$ ]]; then
    remove
else
    echo "Installation cancelled."
    exit 0
fi