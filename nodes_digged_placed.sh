#!/bin/bash
# Gets the nodes digged and placed from the debug.txt, then calculates the player/global percentage ratio
echo "Count player nodes digged and placed in debug log"

echo "Enter Player name (leave empty to skip):"
read PLAYERNAME

echo "Counting global digged..."
GLOBALPLACED="`cat debug.txt | grep -a -E "\]:\s[a-zA-Z0-9_-]+\splaces\snode\s" | wc -l`"
echo "Counting global placed..."
GLOBALDIGGED="`cat debug.txt | grep -a -E "\]:\s[a-zA-Z0-9_-]+\sdigs\s" | wc -l`"
echo "Getting node counts for: $PLAYERNAME..."

if [[ -z "$PLAYERNAME" ]]; then
echo "World totals"
echo "Digged: $GLOBALDIGGED"
echo "Placed: $GLOBALPLACED"
	exit
else

PLAYERPLACED=`cat debug.txt | grep -a -E "\]:\s$PLAYERNAME\splaces\snode\s" | wc -l`
PLACEDRATIO=`lua -e "print(string.format(\"%.4f\",($PLAYERPLACED/$GLOBALPLACED)*100))"`

PLAYERDIGGED=`cat debug.txt | grep -a -E "\]:\s$PLAYERNAME\sdigs\s" | wc -l`
DIGGEDRATIO=`lua -e "print(string.format(\"%.4f\",($PLAYERDIGGED/$GLOBALDIGGED)*100))"`

echo "$PLAYERNAME totals / World totals = (%)"
echo "Digged: $PLAYERDIGGED / $GLOBALDIGGED = ($DIGGEDRATIO%)"
echo "Placed: $PLAYERPLACED / $GLOBALPLACED = ($PLACEDRATIO%)"

fi
exit 0
