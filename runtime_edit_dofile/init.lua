local MP = minetest.get_modpath(minetest.get_current_modname())

minetest.register_chatcommand("dofile", {
    description = "modify Lua file during runtime",
    privs = { server = true },
    func = function(name)
        local get_file = dofile(MP .. "/dofile.lua")
        get_file():run_script(name)
    end
})
