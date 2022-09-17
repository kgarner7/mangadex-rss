#!/bin/sh

if [ ! -f /opt/manga/feed/feed.rss ]; then
    /opt/manga/venv/bin/python /opt/manga/main.py
fi

crond -f -d 8 &
lighttpd -D -f lighttpd.conf &

wait -n
echo $?