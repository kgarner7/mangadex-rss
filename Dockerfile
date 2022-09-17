FROM python:3-alpine

#Print all logs without buffering it.
ENV PYTHONUNBUFFERED 1

#This port will be used by lighttpd
EXPOSE 8000

# Environment variables that should not change
ENV feed_file="/opt/manga/feed/feed.rss"

# Environment variables that can be changed
ENV language="en"
ENV fetch_limit="20"

VOLUME /opt/manga/feed

#Create app dir and install requirements.
WORKDIR /opt/manga

COPY cronjobs/root /etc/crontabs/root
COPY entrypoint.sh lighttpd.conf main.py requirements.txt ./

RUN apk add lighttpd && \
    python -m venv venv && \
    /opt/manga/venv/bin/python -m pip install --upgrade pip && \
    venv/bin/pip install -r requirements.txt --no-cache-dir

HEALTHCHECK --interval=5m --start-period=60s \
    CMD wget --spider localhost:8000/feed.rss

ENTRYPOINT ./entrypoint.sh