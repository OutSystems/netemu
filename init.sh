#!/bin/sh

set -e

MYDIR="$(dirname "$(readlink -f "$0")")"
LOGFILE="$MYDIR/lastoutput"

rm -f "$LOGFILE"

# attempt to fetch the latest version
{
    git && git pull --rebase --stat origin master || true
} >>"$LOGFILE" 2>&1

# start the server
( cd "$MYDIR/tc-server" && nohup setsid ~/bin/node app.js & )