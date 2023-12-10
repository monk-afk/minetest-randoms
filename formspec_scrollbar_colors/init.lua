-- ColorSelect, a color select formspec for Minetest
-- Written by: monk, from SquareOne (monk.moe:30023)
-- License: CC0
persist = {}
local context = {}
local ratelimit = {}


local function hex(r, g, b, a)
	return string.format("#%02X%02X%02X%02X", r, g, b, a)
end

local function rgba(hex)
    hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	local a = tonumber(hex:sub(7, 8), 16)
	return r, g, b, a
end


local formspec = function(name,save)
	local hex = "#1FACE0FF"

	if persist[name] then
		hex = persist[name]
	end

	if context[name] then
		hex = context[name]
	end

	local r, g, b, a = rgba(hex)

	local form = "size[7.1,6.5]".."no_prepend[]"..
		"bgcolor[#1F1F1F"..hex:sub(8, 9)..";both]"..
		"style_type[button;bgcolor="..hex..";font=bold]"..
		"style[exit;bgcolor="..hex..";font=bold;textcolor=red]"..
		"style_type[label;font=bold]"..
		"box[-0.1,-0.10;7.1,0.77;"..hex.."]"..
		"box[-0.1,5.925;7.1,0.77;"..hex.."]"..
		"button_exit[6.352,-0.051;0.8,0.8;exit;X]"..
		"button[5.15,-0.051;1.3,0.8;save;Save]"..
		"button[1.75,5.98;1.9,0.8;darker;< Darker]"..
		"button[3.75,5.98;1.9,0.8;lighter;Lighter >]"..
		"label[1.25,0.025;Color Select]"..
		"label[0.25,0.9;rgba("..r..", "..g..", "..b..", "..a..")]"..
		"label[4.55,0.9;"..hex.."]"..
		"label[0.00,1.7;R:]".."box[0.45,1.7;6.4,0.74;#FF0000FF]"..
		"label[0.00,2.8;G:]".."box[0.45,2.7;6.4,0.74;#00FF00FF]"..
		"label[0.00,3.9;B:]".."box[0.45,3.8;6.4,0.74;#0000FFFF]"..
		"label[0.00,5.0;A:]".."box[0.45,4.9;6.4,0.74;"..hex.."]"..
		"scrollbaroptions[arrows=show;min=0;max=255;smallstep=16;largestep=32]"..
		"scrollbar[0.45,1.7;6.41,0.75;horizontal;red;"..r.."]"..
		"scrollbar[0.45,2.7;6.41,0.75;horizontal;green;"..g.."]"..
		"scrollbar[0.45,3.8;6.41,0.75;horizontal;blue;"..b.."]"..
		"scrollbar[0.45,4.9;6.41,0.75;horizontal;alpha;"..a.."]"

	if save then
		form = form.."label[4,0.025;Saved!]"
	end

	return minetest.show_formspec(name, "colorselect:main", form)
end


local function select(name, colors, save)
	local hex = hex(colors.red, colors.green, colors.blue, colors.alpha)

	if hex then
		context[name] = hex
	end

	if save then
		persist[name] = hex
		context[name] = nil
	end

	return formspec(name, save)
end


local function color(name,fields)
		if not (fields.red and fields.green and
				fields.blue and fields.alpha) then
			return
		end

	local colors = {
		red = minetest.explode_scrollbar_event(fields.red),
		green = minetest.explode_scrollbar_event(fields.green),
		blue = minetest.explode_scrollbar_event(fields.blue),
		alpha = minetest.explode_scrollbar_event(fields.alpha),
		}

	local limit = function(v)
			 if v <= 0 then
				v =  0 end
			 if v >= 255 then
				v =  255 end
		 return v
	end

	for key, color in pairs(colors) do
		if color.type ~= "CHG" and color.type ~= "VAL" then
			return
		end

		color = tonumber(color.value) or 0

		if key ~= "alpha" then
			if fields.lighter then
				color = color + 16
			elseif fields.darker then
				color = color - 16
			end
		end

		color = limit(color)

		colors[key] = color

	end

	if fields.save then
		return select(name, colors, true)
	end

	select(name, colors)
end


minetest.register_on_player_receive_fields(function(player, form, fields)
	if not player then return end

	if form ~= "colorselect:main" then
		return
	end

	local name = player and player:get_player_name()

	if fields.quit or fields.exit then
		if context[name] then
			context[name] = nil
		end

		return
	end

	if fields.red and fields.green and fields.blue and not ratelimit[name] then
		ratelimit[name] = {kill = minetest.after(1, function()
			ratelimit[name] = nil
			end)
		}

		color(name,fields)

		return ratelimit[name].kill
	end
end)


minetest.register_on_leaveplayer(function(player)
	local name = player and player:get_player_name()

	if context[name] then
		context[name] = nil
	end
end)


minetest.register_chatcommand("colorselect", {
    description = "Color Select Formspec",
    privs = {interact = true},
    func = function(name)
		formspec(name)
    end
})
