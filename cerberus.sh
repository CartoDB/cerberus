#!/bin/bash

URLS=urls.txt
DB=db.sqlite
CHECKS_TABLE_NAME=checks
CREATE_CHECKS_TABLE="
CREATE TABLE IF NOT EXISTS
$CHECKS_TABLE_NAME (
  url TEXT NOT NULL,
  last_modified TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (url, last_modified)
);"

create_table () {
  echo $CREATE_CHECKS_TABLE | sqlite3 $DB
}

get_urls () {
  cat $URLS
}

last_modified () {
  url=$1

  echo $(curl -sI $url | grep Last-Modified | tr -d '\r')
}

check_if_url_changed () {
  url=$1

  last_modified=$(last_modified $url | xargs)

  echo "
    INSERT INTO $CHECKS_TABLE_NAME
    (url, last_modified)
    VALUES ('$url', '$last_modified');
  " | sqlite3 $DB 2>/dev/null &&
    echo "$url"
}

create_table
for url in $(get_urls); do
  check_if_url_changed "$url"
done
