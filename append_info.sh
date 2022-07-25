#!/bin/bash

set -e

for var in "$@"
do
  TIMESTAMP=`date -u '+*This document was built at %A %B %d, %H:%M UTC.*'`
  CARGO_TOML=`echo $var | sed "s/src\/lib.rs/Cargo.toml/"`
  CRATE=`grep ^name $CARGO_TOML | sed 's/name\s*=\s*"//' | sed 's/"//'`

  if [[ $STABLE == 1 ]]; then
    BOOK_LINK="stable"
    LINK="[Docs of the **upcoming version**](/docs/next/$CRATE)"
  else
    BOOK_LINK="next"
    LINK="[**Stable docs**](/docs/stable/$CRATE)"
  fi

  LINKS="[GitHub](https://github.com/Relm4/relm4) | [Website](https://relm4.org) | [Book](https://relm4.org/book/$BOOK_LINK) | [Blog](https://relm4.org/blog)"

  TEXT="//!
//! $LINK
//!
//! $TIMESTAMP
//!
//! $LINKS"

  # Escape text
  TEXT=`printf "%q" "$TEXT" | sed "s/$'//"`
  TEXT=`echo "${TEXT//\//\\\/}"`

  # Find the first free line after "//!" comments and insert the text there
  sed "0,/^[[:space:]]*$/ s/^[[:space:]]*$/$TEXT\n/" $var -i
done