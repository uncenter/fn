#!/usr/bin/env sh

name="feed"
version="0.4.5"
source="https://raw.githubusercontent.com/uncenter/feed-newsboat/main/feed.sh"
header=$(echo "$name - Newsboat's missing CLI [v$version]\n\nUsage: $name <command>")
script_path="$(which $0)"

if ! command -v newsboat &>/dev/null; then
    echo "Command \`newsboat\` not found, please install it first."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "You can install it with \`brew install newsboat\`."
    fi
    echo "See https://newsboat.org/ for more information."
    exit 1
fi

url_file=$(newsboat -h | grep -o -E "feed URLs:.*" | cut -d ':' -f 2 | sed 's/ //g')
config_file=$(newsboat -h | grep -o -E "configuration:.*" | cut -d ':' -f 2 | sed 's/ //g')

usage() {
    cat <<EOF

$header

Commands: [add, remove, list, edit, configure, launch/start/run, update/upgrade, uninstall, help]
EOF
}

help() {
    cat <<EOF

$header

Commands:
    add <url>       Add a URL.
    remove <url>    Remove a URL.
    list            List all URLs.
    edit            Edit the URL file.
    configure       Edit the Newsboat config file.
    launch/start/run
                    Launch Newsboat.
    update/upgrade  Update feed.
    uninstall       Uninstall feed.
    help            Show this help message.

Any unrecognized commands or options will be passed to Newsboat.

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
    if [[ $(grep "$1" "$url_file") ]]; then
        echo "Feed '$1' already exists."
        exit 1
    fi
    echo "$1" >> "$url_file" && echo "Added feed '$1'."
}

remove() {
    if [ -z "$1" ]; then
        echo "Please specify a feed to remove."
        exit 1
    fi
    if [[ ! $(grep "$1" "$url_file") ]]; then
        echo "Feed '$1' does not exist! Run \`$name list\` to see all feeds."
        exit 1
    fi
    sd "\n$1|${1}\n" "" "$url_file" && echo "Removed feed '$1'."
}

update() {
    echo "Fetching latest version of feed..."
    download="feed-latest-$(date +%s%N).sh"
    curl -fsSL "$source" -o "$download"
    chmod +x "$download"
    latest_version="$(./$download help | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")"
    if [ "$version" == "$latest_version" ] && [ $(cmp --silent $download $script_path) ]; then
        echo "Already up to date."
        rm "$download"
    else
        mv "$download" "$script_path"
        echo "Updated to latest version ($version -> $latest_version)."
    fi
}

uninstall() {
    if [ -f "$script_path" ]; then
        read -r -n 1 -p "Located feed in $(dirname $script_path). Uninstall? [y/N] " REPLY
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$script_path"
            echo "Removed feed."
            return 0
        else
            echo "Removal cancelled."
            return 0
        fi
    fi
    echo "Failed to locate feed in $(dirname $script_path)."
    return 1
}

if [[ -z "$1" ]]; then
    if [[ ! -z "$FEED_NO_ARGS_LAUNCH" && "$FEED_NO_ARGS_LAUNCH" != "0" ]]; then
        command newsboat
        exit $?
    fi
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
        cat "$url_file" || echo "No feeds found."
        ;;
    edit)
        $EDITOR "$url_file" || echo "No editor found. Set the EDITOR environment variable to your preferred editor."
        ;;
    configure)
        $EDITOR "$config_file" || echo "No editor found. Set the EDITOR environment variable to your preferred editor."
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