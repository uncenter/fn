#!/usr/bin/env sh

get_file() {
    echo $(newsboat -h | grep -o -E "$1:.*" | cut -d ':' -f 2 | sed 's/ //g')
}

urls=$(get_file "feed URLs")
config=$(get_file "configuration")
cache=$(get_file "cache")

mv $urls ./urls.bak
mv $config ./config.bak
mv $cache ./cache.bak

mv ./urls.txt $urls
mv ./config.cfg $config
vhs ./demo.tape
mv $urls ./urls.txt
mv $config ./config.cfg

mv ./urls.bak $urls
mv ./config.bak $config
mv ./cache.bak $cache