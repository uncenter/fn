#!/usr/bin/env sh

name="feed"
version="0.4.1"
source_url="https://raw.githubusercontent.com/uncenter/feed-newsboat/main/feed.sh"
description="newsboat's missing cli"
header=$(echo "$name - $description [version $version]\n\nUsage: $name <command>")
feed_location="$(which feed)"

if ! command -v newsboat &>/dev/null; then
    echo "Command \`newsboat\` not found, please install it first."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "You can install it with \`brew install newsboat\`."
    fi
    echo "See https://newsboat.org/ for more information."
    exit 1
fi

NEWSBOAT_URL_FILE=$(newsboat -h | grep -o -E 'feed URLs:.*' | cut -d ':' -f 2 | sed 's/ //g')
NEWSBOAT_CONFIG_FILE=$(newsboat -h | grep -o -E 'configuration:.*' | cut -d ':' -f 2 | sed 's/ //g')
NEWSBOAT_CACHE_FILE=$(newsboat -h | grep -o -E 'cache:.*' | cut -d ':' -f 2 | sed 's/ //g')

usage() {
    cat <<EOF

$header

Commands: [add, remove, list, edit, config[ure], launch/start/run, update/upgrade, uninstall, help]
EOF
}

help() {
    cat <<EOF

$header

Commands:
    add <url>       Add a feed URL.
    remove <url>    Remove a feed URL.
    list            List all feed URLs.
    edit            Edit the feed URL file.
    config[ure]     Edit the newsboat config file.
    launch/start/run
                    Launch newsboat.
    update/upgrade  Update feed.
    uninstall       Uninstall feed.
    help            Show this help message.

Any unrecognized commands or options will be passed to newsboat.

https://github.com/uncenter/feed-newsboat
EOF
}

add() {
    if [ -z "$1" ]; then
        echo "Please specify a feed to add."
        exit 1
    fi
    if [[ $1 != http://* && $1 != https://* ]]; then
        echo "Please specify a valid feed URL (must start with http:// or https://)."
        exit 1
    fi
    if [[ $(grep "$1" "$NEWSBOAT_URL_FILE") ]]; then
        echo "Feed $1 already exists."
        exit 1
    fi
    echo "Adding feed "$1"..."
    echo "$1" >> "$NEWSBOAT_URL_FILE"
}

remove() {
    if [ -z "$1" ]; then
        echo "Please specify a feed to remove."
        exit 1
    fi
    if [[ ! $(grep "$1" "$NEWSBOAT_URL_FILE") ]]; then
        echo "Feed $1 does not exist. Run \`$name list\` to see all feeds."
        exit 1
    fi
    echo "Removing feed "$1"..."
    sd "\n$1|${1}\n" "" "$NEWSBOAT_URL_FILE"
}

update() {
    echo "Fetching latest version of feed..."
    feed_download="feed-latest-$(date +%s%N).sh"
    curl -fsSL "$source_url" -o "$feed_download"
    chmod +x "$feed_download"
    latest_version="$(./$feed_download help | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")"
    if [ "$version" == "$latest_version" ]; then
        echo "Already up to date."
        rm "$feed_download"
        return 0
    else
        echo "Updating to latest version... ($version -> $latest_version)"
    fi
    mv "$feed_download" "$feed_location"
}

uninstall() {
    if [ -f "$feed_location" ]; then
        read -r -n 1 -p "Located feed in $(dirname $feed_location). Uninstall? [y/N] " REPLY
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$feed_location"
            echo "Removed feed."
            return 0
        else
            echo "Removal cancelled."
            return 0
        fi
    fi
    echo "Failed to locate feed in $(dirname $feed_location)."
    return 1
}

if [[ -z "$1" ]]; then
    usage
    exit 1
fi

case "$1" in
    add)
        add "$2"
        ;;
    remove)
        remove "$2"
        ;;
    list)
        cat "$NEWSBOAT_URL_FILE" || echo "No feeds found."
        ;;
    edit)
        $EDITOR "$NEWSBOAT_URL_FILE" || echo "No editor found. Set the EDITOR environment variable to your preferred editor."
        ;;
    config|configure)
        $EDITOR "$NEWSBOAT_CONFIG_FILE" || echo "No editor found. Set the EDITOR environment variable to your preferred editor."
        ;;
    help)
        help
        ;;
    launch|start|run)
        shift
        command newsboat "$@"
        exit $?
        ;;
    update|upgrade)
        update
        exit $?
        ;;
    uninstall)
        uninstall
        exit $?
        ;;
    *)
        command newsboat "$@"
        exit $?
        ;;
esac