#!/bin/sh -l

# Will build command of the form:
# mcix asset-analysis query \
#   -assets ./Jobs \
#   -exclude-tag tag-to-exclude \
#   -include-tag tag-to-include \
#   -queries ./Queries \
#   -report compliance.csv \
#   -threads 4

echo "The action mcix/asset-analysis/query is not yet implemented." >> $GITHUB_OUTPUT

status=1
exit "$status"
