#!/usr/bin/env sh

get_file() {
    echo $(newsboat -h | grep -o -E "$1:.*" | cut -d ':' -f 2 | sed 's/ //g')
}

dir=$(dirname $0)

urls=$(get_file "feed URLs")
config=$(get_file "configuration")
cache=$(get_file "cache")

mv $urls $dir/urls.bak
mv $config $dir/config.bak
mv $cache $dir/cache.bak

mv $dir/urls.txt $urls
mv $dir/config.cfg $config
vhs $dir/demo.tape
mv $urls $dir/urls.txt
mv $config $dir/config.cfg

mv $dir/urls.bak $urls
mv $dir/config.bak $config
mv $dir/cache.bak $cache