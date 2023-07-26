#!/usr/bin/env sh

get_file() {
    echo $(newsboat -h | grep -o -E "$1:.*" | cut -d ':' -f 2 | sed 's/ //g')
}

urls=$(get_file "feed URLs")
configuration=$(get_file "configuration")
cache=$(get_file "cache")

mv $urls ./urls.bak
mv $configuration ./config.bak
mv $cache ./cache.bak

mv ./urls.txt $urls
vhs ./demo.tape
mv $urls ./urls.txt

mv ./urls.bak $urls
mv ./config.bak $configuration
mv ./cache.bak $cache