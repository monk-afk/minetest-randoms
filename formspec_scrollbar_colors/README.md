# ColorSelect
A mod for Minetest adding a color select formspec which may be used as an API

Created by monk
[SquareOne](https://discord.gg/pE4Tu3cf23) @ monk.moe:30023

Copyright (c) 2023
Licensed under CC0, no rights reserved

## Version

- 0.1 - Initial release

## Usage

open colorselect formspec

	/colorselect

## Additional Info

In version 0.1, the player's selected colors are are applied
to the colorselect formspec. Saved between logins, but not through server reboots.

Version 0.1 may be modified to work with other mods, such as factions, to color
themes, player nametage, chat colors, etc.

The slidebars are rate-limited to prevent the server from processing
the many scrollbar events sent by the client, and also disallows dragginb the slider.
