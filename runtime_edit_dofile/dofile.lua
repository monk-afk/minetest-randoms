local now = os.time()

local function get_file()
    return {
    run_script = function(self, name)

        local player = minetest.get_player_by_name(name)

        local pos = player:get_pos()

            print(dump(pos))

        minetest.chat_send_player(name, "Edit me!")

            print(now)

    end,
}
end
return get_file
