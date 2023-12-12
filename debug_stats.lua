  -- debug_stats.lua //  monk @ SquareOne
  --     dev_0.02 - Licensed by CC0
  -- traverses the minetest debug.txt for player actions
  -- use cat and grep for keywords, ex:
  -- $ cat debug.txt | egrep " digs | places | joins | leaves | dies at | punched | mobs_ | hp\=10\) punched" | egrep -v "__builtin|worldedit|punched\s\w+\s\"carts:cart" > debug-dump.txt
  -- $ cat debug-dump.txt | sort -t"-" -k2n > debug-sort.txt
local player_digputs = {}
local debugfile = "debug-dump.txt"
local playername = "monk"

local function file_exists(file)
	local f = io.open(file,"rb")
	if f then f:close() end
	return f~=nil
end

if not file_exists(debugfile) then
	return
end

local match = string.match
local gsub = string.gsub
local find = string.find

for line in io.lines(debugfile) do
	local line = gsub(line, " node ", " "):
			gsub("\"", ""):
			gsub(" player ", " "):
			gsub(" LuaEntitySAO ", " "):
			gsub(" at ", " "):
			gsub("%b()%s", "")

	local date, name, action, item = match(
			line, "^([%d-]+%s[%d:]+)"..
				":%s%S+:%s(%S+)"..
				"%s(%S+)"..
				"%s(%S+)"
			)

	if name == playername then
		if not player_digputs[name] then
			player_digputs[name] = {
				dig = {},
				put = {},
				join = 0,
				first = date,
				pvp = {},
				mob_hit = {},
				hitby_mob = {},
				die = {},
			}
		end
		local player = player_digputs[name]
		if item == "joins" then
			player.join = player.join + 1
		end
	
		if action == "places" then
			if not player.put[item] then
				player.put[item] = 0
			end
			player.put[item] = player.put[item] + 1
		end
		
		if action == "digs" then
			if not player.dig[item] then
				player.dig[item] = 0
			end
			player.dig[item] = player.dig[item] + 1
		end
	
		if action == "dies" then
			local item = tostring(gsub(item, "%.", ""))
			if not player.die[date] then
				player.die[date] = item
			end
			player.die[date] = item
		end
	
		if action == "punched" then
			if match(name, "^mobs_.+") then
				if not player.hitby_mob[name] then
					player.hitby_mob[name] = 0
				end
				player.hitby_mob[name] = player.hitby_mob[name] + 1
	
			elseif match(item, "^mobs_.+") then
				if not player.mob_hit[item] then
					player.mob_hit[item] = 0
				end
				player.mob_hit[item] = player.mob_hit[item] + 1
	
			else
				if not player.pvp[item] then
					player.pvp[item] = 0
				end
				player.pvp[item] = player.pvp[item] + 1
			end
		end
	end
end


local tally = 0
for name in pairs(player_digputs) do
	local player = player_digputs[name]

		print(name.." = {")
		print("    first_login = \""..player.first.."\",")
		print("    total_logins = "..player.join..",")

		print("    nodes_digged = {")
	for digs, count in pairs(player.dig) do
		tally = tally + count
		print("        [\""..digs.."\"] = "..count..",")
	end
		print("            total_digged = "..tally..",")
	tally = 0
		print("    },")

		print("    nodes_placed = {")
	for puts, count in pairs(player.put) do
		tally = tally + count
		print("        [\""..puts.."\"] = "..count..",")
	end
		print("            total_placed = "..tally..",")
	tally = 0
		print("    },")

		print("    deaths = {")
	for date, dies in pairs(player.die) do
		tally = tally + 1
		print("        [\""..date.."\"] = "..dies..",")
	end
		print("            total_deaths = "..tally..",")
	tally = 0
		print("    },")

		print("    pvp = {")
	local hits = 0
	for pvped, count in pairs(player.pvp) do
	tally = tally + 1
	hits = hits + count
		print("        [\""..pvped.."\"] = "..count..",")
	end
		print("            players_pvped = "..tally..",")
		print("            punches_landed = "..hits..",")
	hits = 0
	tally = 0
		print("    },")

		print("    mobs = {")
		print("        mobs_hit = {")
		for mob_hit, count in pairs(player.mob_hit) do
		tally = tally + count
		print("            [\""..mob_hit.."\"] = "..count..",")
		end
			print("                mob_hits = "..tally..",")
			print("        },")
	tally = 0

		print("        hits_from_mobs = {")
		for hitby_mob, count in pairs(player.hitby_mob) do
		tally = tally + count
		print("            [\""..hitby_mob.."\"] = "..count..",")
		end
			print("                hits_from_mobs = "..tally..",")
			print("        },")
	tally = 0
			print("    },")
		print("},\n")
end
  -- Example output:
--[[ 
	monk = {
		first_login = "2023-05-28 20:15:33",
		total_logins = 529,
		nodes_digged = {
			["default:dirt"] = 150,
			["bones:bones"] = 2,
				total_digged = 152,
		},
		nodes_placed = {
			["default:dirt"] = 312,
			["default:ice"] = 2,
				total_placed = 315,
		},
		deaths = {
			["2023-07-29 02:00:14"] = (-5,-23,-5),
			["2023-08-06 05:24:04"] = (-2,-53,-2),
				total_deaths = 2,
		},
		pvp = {
			["monk2"] = 349,
				players_pvped = 1,
				punches_landed = 349,
		},
		mobs = {
			mobs_killed = {
				["mobs_monster:dirt_monster"] = 63,
				["mobs_animal:chicken"] = 1,
					mob_kills = 64,
			},
			deathby_mobs = {
				["mobs_animal:kitten"] = 1,
					deathsby_mob = 1,
			},
		},
	},
 ]]
