#!/bin/bash

set -e

for var in "$@"
do
  TEXT=" " # Will be used to announce deprecation warning of the docs

  # Escape text
  printf -v TEXT "%q" "$TEXT"
  TEXT=${TEXT#\$\'}
  TEXT=${TEXT%\'}
  TEXT=`echo "${TEXT//\//\\\/}"`

  FIRST_WORD=`awk '{print $1; exit}' $var`

  # Only edit files that have a doc comment (//!) at the start.
  if [[ "//!" == $FIRST_WORD ]]; then
    # Find the first free line after "//!" comments and insert the text there
    sed "0,/^[[:space:]]*$/ s/^[[:space:]]*$/$TEXT\n/" $var -i
  fi
done