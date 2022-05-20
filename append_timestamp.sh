#!/bin/bash

for var in "$@"
do
  TIMESTAMP=`date -u '+\/\/! *This document was built at %A %B %d, %H:%M.*'`
  sed "0,/^[[:space:]]*$/ s/^[[:space:]]*$/\/\/!\n$TIMESTAMP\n/" $var -i
done