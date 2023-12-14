" in plugin/whid.vim
if exists('g:loaded_time_tracking') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

" command to run our plugin
command! Whid lua require('time-tracking').whid()
command! Time lua require('time-tracking').test_curl()
command! TogglFetch lua require('time-tracking').fetch_time_entries()
command! Jira lua require('time-tracking').book_jira_time_entries()

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_time_tracking = 1
