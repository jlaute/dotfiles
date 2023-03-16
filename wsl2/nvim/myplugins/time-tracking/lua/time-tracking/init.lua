function global_lua_function()
    print "nvim-example-lua-plugin.myluamodule.init global_lua_function: hello"
end

local function unexported_local_function()
    print "nvim-example-lua-plugin.myluamodule.init unexported_local_function: hello"
end

local function local_lua_function()
    print "nvim-example-lua-plugin.myluamodule.init local_lua_function: hello"
end

return {
    local_lua_function = local_lua_function,
}
