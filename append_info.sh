#!/bin/bash

set -e

for var in "$@"
do
  TIMESTAMP=`date -u '+*This document was built at %A %B %d, %H:%M UTC.*'`
  CARGO_TOML=`echo $var | sed "s/src\/lib.rs/Cargo.toml/"`
  CRATE=`grep ^name $CARGO_TOML | head -1 | sed 's/name\s*=\s*"//' | sed 's/"//'`

  if [[ $STABLE == 1 ]]; then
    BOOK_LINK="stable"
    LINK="Version: **\`stable\`**. Visit the docs of the **upcoming version** [here](/docs/next/$CRATE)."
  else
    BOOK_LINK="next"
    LINK="Version: **\`nightly\`**. Visit the **stable docs** [here](/docs/stable/$CRATE)."
  fi

  LINKS="[GitHub](https://github.com/Relm4/relm4) | [Website](https://relm4.org) | [Book](https://relm4.org/book/$BOOK_LINK) | [Blog](https://relm4.org/blog)"

  TEXT="//!
//! $LINK
//!
//! $TIMESTAMP
//!
//! $LINKS"

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