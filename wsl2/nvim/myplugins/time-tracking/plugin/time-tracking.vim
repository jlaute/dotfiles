echo 'test 12'

if exists('g:loaded_time_tracking')
    finish
endif
let g:loaded_time_tracking = 1

echo 'asdf'
lua timetracking = require("time-tracking")

echo 'LOADED1212'

lua global_lua_function()

" local curl = require('curl')
"
" if !exists('g:__time_tracking_setup_completed')
"     lua require("time_tracking").setup {}
" endif
"
" lua require("time_tracking").init()

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=0 TogglFetch call time_tracking#DefineWord()
command! -nargs=0 FindDate call time_tracking#GetFilenme()
