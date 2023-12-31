#!/bin/bash
# Gets the player kills from debug.txt
# Kills counted are: player hits another player, giving damage and reading 0 hp in log, followed by the death of the hit player
# 
echo "Find player kills in debug log"

echo "Enter Player name (leave empty to skip):"
read PLAYERNAME

DATAFOLDER="./killfiles"
KILLFILE="killgrep_`date +%b-%d-%Y_%s`.txt"

if [[ -z "$PLAYERNAME" ]]; then
	echo "Finding all kills in logfile..."
	PLAYERNAME="[a-zA-Z0-9_-]+"
	KILLFOLDER="$DATAFOLDER"
	mkdir -p $KILLFOLDER
else
	echo "Searching debug logs for: $PLAYERNAME..."
	KILLFOLDER="$DATAFOLDER/$PLAYERNAME"
	mkdir -p $KILLFOLDER
fi

	{
	cat ./debug.txt | grep -A 1 -E "$PLAYERNAME\s.+\spunched\s.+hp=0.+" | grep -B 1 -E ".+dies" |
	sed -E "s/:\s\w+\[\w+\]://" | sed -E "s/id=[0-9]+,\s//g" > $KILLFOLDER/$KILLFILE
	}

echo "Created file $KILLFOLDER/$KILLFILE"

while true; do
    read -p "Do you wish to print the output? " yn
    case $yn in
        [Yy]* ) echo "--" ; cat $KILLFOLDER/$KILLFILE ; break;;
        [Nn]* ) exit;;
        * ) exit;;
    esac
done
# 
# Output example:
# --
# 2023-06-05 12:23:02 player monk2 (hp=20) punched player monk (hp=0), damage=1
# 2023-06-05 12:23:02 monk dies at (2,1,-300). Bones placed
