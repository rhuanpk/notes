#!/bin/bash

# replaces spaces with tabs when used at the beginning of the line indentation

usage() {
cat >&2 << EOF
Usage:
	$0
After use, cleanup non-necessary backuped files:
	git clean -f *~
Or
	rm -iv *~
EOF
}

[ "$1" = '-h' -o "$1" = '--help' ] && { usage; exit 1; }

sed -Ei~ 's/^  +/\t/g' *.md
