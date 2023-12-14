local time_tracking = require("time-tracking.core")
local toggl = require("time-tracking.toggl")
local jira = require("time-tracking.jira")

local function whid()
  local buf = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(buf)
  print("Whid opened new")
  print(bufname)
end

return {
  whid = whid,
  test_curl = time_tracking.test_curl,
  fetch_time_entries = toggl.fetch_time_entries,
  book_jira_time_entries = jira.book_jira_time_entries,
}
