#!/opt/local/bin/bash

echo converting \"$1\" to \"$2\"
sed 's/n(\["Extension exception:.*e\.message\])/""/' "$1" > "$2"

