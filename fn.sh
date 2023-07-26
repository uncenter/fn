#!/usr/bin/env sh

name="fn"
version="1.1.0"
source="https://raw.githubusercontent.com/uncenter/fn/main/fn.sh"
script_path="$(which $0)"

if ! command -v newsboat &>/dev/null; then
    echo "$name: command \`newsboat\` not found; please install it first (see https://newsboat.org/)"
    exit 1
fi

urls=$(newsboat -h | grep -o -E "feed URLs:.*" | cut -d ':' -f 2 | sed 's/ //g')
configuration=$(newsboat -h | grep -o -E "configuration:.*" | cut -d ':' -f 2 | sed 's/ //g')

# Fix newlines for listing, adding, removing without issues.
# If the last character is not a newline character...
if [[ ! $(tail -c1 "$urls" | wc -l) -gt 0 ]]; then
    # And the file is not empty...
    if [ -s "$urls" ]; then
        # Then add a newline.
        echo "" >> $urls
    fi
fi

usage() {
    echo "usage: [add, remove, list, edit, configure, launch/start/run, update/upgrade, uninstall, help]"
}

help() {
    cat <<EOF
$name - launch, configure, and manage your feeds for Newsboat [v$version]

Usage: $name [command]

Commands:
    add <url>       Add a URL.
    remove <url>    Remove a URL.
    list            List all URLs.
    edit            Edit the URL file.
    configure       Edit the Newsboat config file.
    launch/start/run
                    Launch Newsboat.
    update/upgrade  Update.
    uninstall       Uninstall.
    help            Show this help message.

Any unrecognized commands or options will be passed to Newsboat.

https://github.com/uncenter/fn
EOF
}

add() {
    if [ -z "$1" ]; then
        echo "$name: command add: requires url argument"
        exit 1
    fi
    for url in "$@"; do
        if [[ $url != http://* && $url != https://* ]]; then
            echo "$name: command add: url argument must start with http:// or https://"
            continue
        fi
        if [[ $(grep "^$url$" "$urls") ]]; then
            echo "$name: command add: '$url' already exists in URLs"
            continue
        fi
        echo "$url" >> "$urls" && echo "Added '$url'."
    done
}

remove() {
    if [ -z "$1" ]; then
        echo "$name: command remove: requires url arugment"
        exit 1
    fi
    for url in "$@"; do
        if [[ ! $(grep "^$url$" "$urls") ]]; then
            echo "$name: command remove: '$url' does not exist in URLs"
            continue
        fi
        sd "^$url$\n" "" "$urls" && echo "Removed '$url'."
    done
}

update() {
    echo "Fetching latest version..."
    download="$name-dl-latest-$(date +%s%N).sh"
    curl -fsSL -H "Cache-Control: no-cache" "$source?$(date +%s%N)" -o "$download"
    chmod +x "$download"
    latest_version="$(./$download help | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")"
    if [ "$version" = "$latest_version" ] && cmp --silent $download $script_path; then
        echo "Already up to date."
        rm "$download"
    else
        mv "$download" "$script_path"
        echo "Updated to latest version ($version -> $latest_version)."
    fi
}

uninstall() {
    if [ -f "$script_path" ]; then
        read -r -n 1 -p "Located \`$name\` in $(dirname $script_path). Uninstall? (y/N) " REPLY
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$script_path" && echo "Success."
            return $?
        else
            echo "Aborted."
            return 0
        fi
    fi
    echo "$name: command uninstall: something went wrong"
    return 1
}

if [[ -z "$1" ]]; then
    if [[ ! -z "$FN_NO_ARGS_LAUNCH" && "$FN_NO_ARGS_LAUNCH" != "0" ]]; then
        command newsboat
        exit $?
    fi
    usage
    exit 1
fi

case "$1" in
    add)
        shift
        add $@
        ;;
    remove)
        shift
        remove $@
        ;;
    list)
        if [ -s "$urls" ]; then
            cat "$urls"
            exit $?
        fi
        echo "$name: command list: no URLs found"
        exit 1
        ;;
    edit)
        $EDITOR "$urls"
        ;;
    configure)
        $EDITOR "$configuration"
        ;;
    help)
        help
        ;;
    launch|start|run)
        shift
        command newsboat $@
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