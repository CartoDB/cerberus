#!/bin/bash

URLS=urls.txt
DB=db.sqlite
CHECKS_TABLE_NAME=checks
CREATE_CHECKS_TABLE=<<EOF
CREATE TABLE IF NOT EXISTS
$CHECKS_TABLE_NAME (
  url TEXT NOT NULL,
  last_modified TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (url, last_modified)
);
EOF

create_table () {
  echo $CREATE_TABLE | sqlite3 $DB
}

get_urls () {
  cat $URLS
}

prev_last_modified () {
  url=$1

  echo "
    SELECT * from $CHECKS_TABLE_NAME
    WHERE url = '$url'
    ORDER BY created_at DESC
    LIMIT 1
  " | sqlite3 $DB
}

last_modified () {
  url=$1

  curl -I $1 2>1 | grep Last-Modified
}

check_if_url_changed () {
  url=$1

  prev_last_modified=$(prev_last_modified $url)
  cur_last_modified=$(last_modified $url)

  echo prev: $prev_last_modified
  echo cur: $cur_last_modified
}

create_table
for url in $(get_urls); do
  check_if_url_changed $url
done
