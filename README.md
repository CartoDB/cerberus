# Cerberus

Keep track of when a URL changes in S3.

### Installation

The only prerequisite is sqlite3.

### Usage

Put the urls you want to track in `urls.txt`.  Then run

  ./cerberus.sh

All urls that have changed since the last run will be echo'd to STDOUT.
