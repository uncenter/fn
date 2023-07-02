#!/usr/bin/env zsh

version="0.1.0"

NEWSBOAT_URL_FILE=$(newsboat -h | grep -o -E 'feed URLs:.*' | cut -d ':' -f 2 | sed 's/ //g')
NEWSBOAT_CONFIG_FILE=$(newsboat -h | grep -o -E 'configuration:.*' | cut -d ':' -f 2 | sed 's/ //g')
NEWSBOAT_CACHE_FILE=$(newsboat -h | grep -o -E 'cache:.*' | cut -d ':' -f 2 | sed 's/ //g')


if ! command -v newsboat &>/dev/null; then
    echo "Command \`newsboat\` not found, please install it first."
    exit 1
fi

usage() {
    cat <<EOF

feed - a minimal command wrapper for newsboat [version $version]

Usage: feed <command> [options]

Commands:
    add     Add a feed URL
    remove  Remove a feed URL
    list    List all feed URLs
    edit    Edit feed URLs
    config  Edit newsboat config

Options:
    -h, --help

Examples:
    
        Add a feed URL:
            $ feed add https://example.com/feed.xml
    
        Remove a feed URL:
            $ feed remove https://example.com/feed.xml
    
        Get help for a specific command:
            $ feed help add
EOF
}

add() {
    if [ -z "$1" ]; then
        echo "Please specify a feed to add."
        exit 1
    fi
    if [[ $1 != http://* && $1 != https://* ]]; then
        echo "Please specify a valid feed URL."
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
    echo "Removing feed "$1"..."
    sd "\n$1|${1}\n" "" "$NEWSBOAT_URL_FILE"
}

list() {
    cat "$NEWSBOAT_URL_FILE"
}

edit() {
    $EDITOR "$NEWSBOAT_URL_FILE"
}

config() {
    $EDITOR "$NEWSBOAT_CONFIG_FILE"
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
    *)
        command newsboat "$@"
        exit 0
        ;;
esac
