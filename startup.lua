#!/bin/bash
MTROOT="${HOME}/minetest"
BACKUPDIR="${HOME}/backups"
DEBUGBACKDIR="$BACKUPDIR/debugs"
TRASHDIR="${HOME}/trash"

mkdir -p $TRASHDIR
mkdir -p $BACKUPDIR
mkdir -p $DEBUGBACKDIR

while true
	do
	$MTROOT/bin/minetest --server --world $MTROOT/worlds/worldname --config $MTROOT/minetest.conf
		echo "Minetest stopped. Backing up debug.txt..."
	DEBUGBACKFIL="debug_`date +%F_%H%M%S`.txt"
	rsync -a $MTROOT/debug.txt $DEBUGBACKDIR/$DEBUGBACKFIL
		echo "Debug backup saved to: $DEBUGBACKDIR/$DEBUGBACKFIL"
	mv $MTROOT/debug.txt $TRASHDIR/$DEBUGBACKFIL
		echo "Done. Restarting Minetest..."
sleep 1
done
