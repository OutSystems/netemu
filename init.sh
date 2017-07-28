#!/bin/sh

set -e

MYDIR="$(dirname "$(readlink -f "$0")")"
LOGFILE="$MYDIR/lastoutput"

cd "$MYDIR"
rm -f "$LOGFILE"

# attempt to fetch the latest version
if git >/dev/null 2>&1; then
    if [ ! \
        "$(git rev-parse master)" = \
        "$(git rev-parse "master@{u}")"
    ]; then
        git pull --rebase --stat origin master && \
        {
            cd "$MYDIR/tc-server" && npm install
        } || true;
    fi
fi >>"$LOGFILE" 2>&1

# start the server
( cd "$MYDIR/tc-server" && nohup setsid ~/bin/node app.js & )