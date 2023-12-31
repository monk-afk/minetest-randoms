# #!/bin/bash
MTROOT="${HOME}/minetest/multicraft"
BACKUPDIR="${HOME}/tmp"
DEBUGBACKDIR="$BACKUPDIR/mt_debugs"
TRASHDIR="${HOME}/trash"

mkdir -p $TRASHDIR
mkdir -p $BACKUPDIR
mkdir -p $DEBUGBACKDIR

while true
	do
	$MTROOT/bin/multicraft --server --world $MTROOT/worlds/world --config $MTROOT/minetest.conf
		echo "WORLD SHUTDOWN COMPLETE"
	DEBUGBACKFIL="debug_`date +%F_%H%M%S`.txt"
	rsync -a $MTROOT/debug.txt $DEBUGBACKDIR/$DEBUGBACKFIL
		echo "Debug backup saved to: $DEBUGBACKDIR/$DEBUGBACKFIL"
	mv $MTROOT/debug.txt $TRASHDIR/$DEBUGBACKFIL
		echo "DONE, RESTARTING MINETEST..."
sleep 1
done
