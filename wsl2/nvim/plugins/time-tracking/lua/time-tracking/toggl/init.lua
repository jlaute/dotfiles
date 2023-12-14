local curl = require("plenary.curl")
local utils = require("time-tracking.utils")
local jira = require("time-tracking.jira")
local uri = 'https://api.track.toggl.com/api/v9/me/time_entries'
local auth = "joerg.lautenschlager@gmail.com:NGyzr8SDk5"

local function insert_content_after_worklog(new_lines)
  -- Get the current buffer
  local buf = vim.api.nvim_get_current_buf()

  -- Search for the line containing "** Worklog"
  local found_line = -1
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    if line:find("** Worklog") then
      found_line = i
      break
    end
  end

  -- Initialize an empty table to store the lines
  local lines_to_insert = {}

  -- Iterate over the table and construct lines
  for key, value in pairs(new_lines) do
    local ticket = value.jira_ticket == nil and "DEVMBMVPCH|TIME" or value.jira_ticket
    table.insert(lines_to_insert, "* [ ] [" .. ticket .. "] " .. value.description)
    table.insert(lines_to_insert, "description")
    table.insert(lines_to_insert, utils.format_duration(value.duration) .. " @time-tracking")
    table.insert(lines_to_insert, "")
  end

  if found_line > 0 then
    -- Insert the new lines after the line
    vim.api.nvim_buf_set_lines(buf, found_line + 1, found_line + 1, false, lines_to_insert)
  else
    print("Line '** Worklog' not found.")
  end
end

local function fetch_time_entries()
  local year, month, day = utils.parse_date_from_path(vim.api.nvim_buf_get_name(0))

  -- exit here when one value is nil
  if not year or not month or not day then
    return
  end

  local start_date = string.format("%d-%02d-%02d", year, month, day)
  local end_date = string.format("%d-%02d-%02d", year, month, day + 1)

  local query = { start_date = start_date, end_date = end_date }
  local response = curl.get(uri, {
    query = query,
    auth = auth,
  })

  local decoded = vim.json.decode(response.body)
  local time_entries = {}
  for key, value in pairs(decoded) do
    if time_entries[value.description] ~= nil then
      time_entries[value.description].duration = time_entries[value.description].duration + value.duration
      goto continue
    end

    time_entries[value.description] = {
      description = value.description,
      duration = value.duration,
      jira_ticket = jira.extract_jira_ticket_number(value.description),
    }

    ::continue::
  end

  insert_content_after_worklog(time_entries)

end

local M = {
  fetch_time_entries = fetch_time_entries,
}

return M
