# Cerberus

Keep track of when a URL changes in S3.

### Installation

The only prerequisite is sqlite3.

### Usage

Put the urls you want to track in `urls.txt`.  Then run

    ./cerberus.sh

All urls that have changed since the last run will be echo'd to STDOUT.

If you want constant tracking, instead use:

    ./watch.sh

By default, polling of all URLs is done every second.  It can be changed with

    ./watch.sh <seconds between polls>

All URLs are polled, in order, sequentially.

If you want to trigger activity based off of changed URLs, use a named pipe as
follows:

    mkfifo pipe
    ./watch.sh > pipe &
    cat pipe | process_input

Where `process_input` is a script that handles each URL as it is passed in.

### Data

All data is stored in sqlite in `db.sqlite`.  An entry is kept for each time a
URL changes.
