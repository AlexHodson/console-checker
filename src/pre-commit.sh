#!/bin/sh

# Redirect output to stderr.
exec 1>&2
# enable user input
exec < /dev/tty

# Test Strings
# consoleregexp='System.out.print'
consoleregexp="console."
# consoleregexp='print'

# Add "-- . ':(exclude)[files]/'" at the end of each 'git diff' command to exclude that particular file/folder
## "-- . ':(exclude)src/'" is used when testing new changes to ignore output commands in this file
if test $(git diff --cached | grep ^+ | grep $consoleregexp | wc -l) != 0
then
  echo -e "\n\033[1m\e[033mOutputs Found\e[39m\033[0m"
  git grep -n -E --cached $consoleregexp $(git diff --cached --name-only  --diff-filter=d)
  echo -e "\n"
  echo "There are some occurrences of '$consoleregexp' at your modification. Please remove them before continuing."
  echo $yn | grep ^[Yy]$
  exit 1;
else
  echo "No Outputs Found In Staged Files"
fi
