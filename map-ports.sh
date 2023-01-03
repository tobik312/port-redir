#!/bin/sh

#Config file delimiter
IFS='; ';

echo "Set port's config"
#Load and set port's config from file
grep -v '^#' "./ports" | while read -r src dst type ; do
    if [ "$type" = "tcp" ]; then
        redir ${src} ${dst} & echo "Successfull map TCP - ${src} to ${dst}"
    elif [ "$type" = "udp" ]; then
        uredir ${src} ${dst} & echo "Successfull map UDP - ${src} to ${dst}"
    else
        echo "Invalid port type - ${type}"
    fi
done

#Keep container running
tail -f /dev/null