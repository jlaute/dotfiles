local function dumpi(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dumpi(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function global_lua_function()
    print "nvim-example-lua-plugin.myluamodule.init global_lua_function: hello"
end

local function unexported_local_function()
    print "nvim-example-lua-plugin.myluamodule.init unexported_local_function: hello"
end

local function local_lua_function()
    buflines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    print("Buflines:", dumpi(buflines))
    for k,v in pairs(buflines) do
        if string.find(v, '@time') then
            print('Found string in this line: ' .. v)
        end
    end
end

return {
    local_lua_function = local_lua_function,
}
