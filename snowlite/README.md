## SnowLite

Minetest mod to add falling snow particles

<sup>A fork edited by monk</sup> <sub>(monk.moe @ [SquareOne](https://discord.gg/pE4Tu3cf23))</sub>

<sup>Copyright (c) 2017 paramat, Licensed by MIT</sup>

##
Credits: 

<sup>snowdrift 0.6.4 https://github.com/paramat/snowdrift</sup>

<sup>snowdrift 0.7.0 https://github.com/PiezoU005F/snowdrift</sup>

<sup>snowlite 0.0.2 https://github.com/monk-afk/snowlite</sup>

##
This fork removes everything except the particle spawner.

Replaced `minetest.get_connected_players` with table of online players.

Changed `minetest.register_globalstep` to `minetest.after` loop.

Added admin and player commands to enable or disable snow:

+ toggle snow for player, requires `interact` priv
  - `/snow`
+ toggle snow globally, requires `server` priv
  - `/snow_globe`

##
To do:
- [ ] Admin set particle `amount = ` with command, ex: `/snow_globe 5`, or have the amount vary randomly
