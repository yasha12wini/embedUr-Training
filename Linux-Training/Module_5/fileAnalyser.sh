#!/bin/bash


logError() {
local error=$1

echo "$error" >&2
echo "$error" >> errors.log

}

showHelp() {

cat << EOF 
This is the help menu:
OPTIONS:
-d <dir>  Recursively seearch a directory
-k <key>  Keyword to search.
-f <file> file search.
--help    Display help menu.

EOF
}

search(){
local dir=$1
local keyword=$2

for entry in "$dir"/*;do

if [[ -d "$entry" ]];then
search "$entry" "$keyword"
elif [[ -f "$entry" ]];then
 if grep -q "$keyword" <<< "$(cat "$entry")";then
  echo "$keyword present in file: $entry"
fi
fi
done
}

while getopts "d:f:k:" option; do
case $option in
d) DIRECTORY="$OPTARG" ;;
k) KEYWORD="$OPTARG" ;;
f) FILE="$OPTARG";;
*) showHelp; exit 1 ;;

esac
done



if [[ "$1" == "--help" ]];then
showHelp
exit 1
fi

if [[ -z "$KEYWORD" ]] || [[ ! "$KEYWORD" =~ ^[A-Za-z0-9]+$ ]]
then
logError "The keyword $KEYWORD isnt valid"
exit 1 
fi

if [[ -n "$DIRECTORY" ]]; then
if [[ -d "$DIRECTORY" ]]; then
search "$DIRECTORY" "$KEYWORD"
else
logError "The directory $DIRECTORY doesnt exist"
fi

elif [[ -n "$FILE" ]];then
if [[ -f "$FILE" ]];then
search "$FILE" "$KEYWORD"
else
logError "The file name doesnt exist $FILE"
fi
else
logError "Missing arguments. Parameters provided: $@" 
showHelp
exit 1
fi

echo "The process has been completed with an exit code of: $?"
