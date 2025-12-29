#!/usr/bin/env -S bash -euo pipefail

for var in "$@"
do
  echo -e "#![feature(doc_cfg)]\n$(cat $var)" > $var
done
