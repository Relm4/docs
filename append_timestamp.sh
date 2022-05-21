#!/bin/bash

for var in "$@"
do
  TIMESTAMP=`date -u '+\/\/! *This document was built at %A %B %d, %H:%M UTC.'`
  sed "0,/^[[:space:]]*$/ s/^[[:space:]]*$/\/\/!\n$TIMESTAMP\n/" $var -i
done