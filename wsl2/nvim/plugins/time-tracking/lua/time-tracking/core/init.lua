local curl = require("plenary.curl")
local utils = require("time-tracking.utils")
local jira = require("time-tracking.jira")
local uri = 'https://api.track.toggl.com/api/v9/me/time_entries'

local M = {}

local function test_curl()
  local auth = "joerg.lautenschlager@gmail.com:NGyzr8SDk5"
  local query = { start_date = "2023-10-27", end_date = "2023-10-27" }
  local response = curl.get(uri, {
    query = query,
    auth = auth,
  })
  -- local resp = curl.get("https://httpbin.org/get")
  local decoded = vim.json.decode(response.body)
  print(response.status)
  print(response.body)
  print(decoded.origin)
  for key, value in pairs(decoded) do
    print("Description:", value.description)
    print("Duration:", utils.format_duration(value.duration))
    print("Jira ticket:", jira.extract_jira_ticket_number(value.description))
  end
end

M = {
  test_curl = test_curl,
}

return M
