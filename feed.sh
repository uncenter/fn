#!/usr/bin/env sh

name="feed"
version="0.3.2"
description="a command wrapper for newsboat"
header=$(echo "$name - $description [version $version]\n\nUsage: $name <command>")

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

Commands: [add, remove, list, edit, config, launch|start|run, help]
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
    config          Edit the newsboat config file.
    launch, start, run
                    Launch newsboat.
    help            Show this help message.

Any unrecognized commands or options will be passed to newsboat.

Examples:
    
    Add a feed URL:
        $ $name add https://example.com/feed.xml

    Remove a feed URL:
        $ $name remove https://example.com/feed.xml
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

list() {
    cat "$NEWSBOAT_URL_FILE" || echo "No feeds found."
}

edit() {
    $EDITOR "$NEWSBOAT_URL_FILE" || echo "No editor found. Set the EDITOR environment variable to your preferred editor."
}

config() {
    $EDITOR "$NEWSBOAT_CONFIG_FILE" || echo "No editor found. Set the EDITOR environment variable to your preferred editor."
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
        list
        ;;
    edit)
        edit
        ;;
    config)
        config
        ;;
    help)
        help
        ;;
    launch|start|run)
        shift
        command newsboat "$@"
        exit $?
        ;;
    *)
        command newsboat "$@"
        exit $?
        ;;
esac
