echo 'test 12'

if exists('g:loaded_time_tracking')
    finish
endif
let g:loaded_time_tracking = 1

lua timetracking = require("time-tracking")

" lua global_lua_function()
" lua timetracking.local_lua_function()

" local curl = require('curl')
"
" if !exists('g:__time_tracking_setup_completed')
"     lua require("time_tracking").setup {}
" endif
"
" lua require("time_tracking").init()

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=0 Testi lua timetracking.local_lua_function()
command! -nargs=0 TogglFetch call time_tracking#DefineWord()
command! -nargs=0 FindDate call time_tracking#GetFilenme()
