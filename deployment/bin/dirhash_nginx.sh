#!/bin/bash
#
# This script calculates the MD5 checksum on a directory
#

# Exit if any of the intermediate steps fail
set -e

# Extract "DIRECTORY" argument from the input into
# DIRECTORY shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
# eval "$(jq -r '@sh "DIRECTORY=\(.directory)"')"

DIRECTORY1=`realpath "$(pwd)/../../public"`
DIRECTORY2=`realpath "$(pwd)/../../src"`
DIRECTORY3=`realpath "$(pwd)/../../.env*"`

# Placeholder for whatever data-fetching logic your script implements
CHECKSUM=`find ${DIRECTORY1} -type f -not -path "*/deployment/*"  -not -path "*/.git/*" | LC_ALL=C sort | xargs shasum -a 256 | awk '{ n=split ($2, tokens, /\//); print $1 " " tokens[n]} ' |  shasum -a 256 | awk '{ print $1 }'`
CHECKSUM2=`find ${DIRECTORY2} -type f -not -path "*/deployment/*"  -not -path "*/.git/*" | LC_ALL=C sort | xargs shasum -a 256 | awk '{ n=split ($2, tokens, /\//); print $1 " " tokens[n]} ' |  shasum -a 256 | awk '{ print $1 }'`
CHECKSUM3=`find ${DIRECTORY3} -type f -not -path "*/deployment/*"  -not -path "*/.git/*" | LC_ALL=C sort | xargs shasum -a 256 | awk '{ n=split ($2, tokens, /\//); print $1 " " tokens[n]} ' |  shasum -a 256 | awk '{ print $1 }'`

CHECKSUM=`echo $CHECKSUM $CHECKSUM2 $CHECKSUM3 | shasum -a 256 | awk '{ print $1 }'`

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg checksum "$CHECKSUM" '{"checksum":$checksum}'