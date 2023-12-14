local curl = require("plenary.curl")
local utils = require("time-tracking.utils")
local uri = "https://webweit.atlassian.net/rest/api/2/issue/"
local auth = "j.lautenschlager@webweit.de:ATATT3xFfGF0gOU85dwF3zauzBzU6bVcSqB3OPXV7Wl4bWB8G52fgcz4o5o1ZADcc4ZF3zYRDk_tLpQIY7jltCaR33vWJ1seN4LEoTcX3yTkVruPvjn4e5j0UKxCEU-0-LumAZgLH5oolP8SZ6w7X01Wuj-SB3vH2sWMQ-FWd5XzTlBeGTNiGiI=4C33AB3D"

local function extract_jira_ticket_number(input_str)
  local pattern = "%w+%-[%d]+"
  local ticket_number = input_str:match(pattern)
  return ticket_number
end

local function get_all_time_trackings()
  local buf = vim.api.nvim_get_current_buf()

  local pattern = "%w+%-[%d]+"
  local time_pattern = "([^@]+) @time%-tracking"

  local tickets = {}

  local last_ticket_number = nil
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    local ticket_number = line:match(pattern)
    if ticket_number then
      tickets[ticket_number] = {ticket_line = i, description = nil}
      last_ticket_number = ticket_number
      goto continue
    end

    if last_ticket_number == nil then
      goto continue
    end

    local time = line:match(time_pattern)
    if time then
      tickets[last_ticket_number].time = time
      tickets[last_ticket_number].time_line = i
      last_ticket_number = nil
      goto continue
    end

    if tickets[last_ticket_number].description == nil then
      tickets[last_ticket_number].description = line
    else
      tickets[last_ticket_number].description = tickets[last_ticket_number].description .. "\n" .. line
    end

    ::continue::
  end

  return tickets
end

local function book_jira_time_entries()
  local time_trackings = get_all_time_trackings()
  local year, month, day = utils.parse_date_from_path(vim.api.nvim_buf_get_name(0))
  local utc_time = utils.get_utc_time(year, month, day)

  print(vim.inspect(time_trackings))

  for key, val in pairs(time_trackings) do  -- Table iteration.
    print(uri .. key .. '/worklog')
    print("time: " .. val.time)
    print("seconds: " .. utils.parse_duration(val.time))
    print(val.description)
    print(utc_time)
    local json = {
      timeSpentSeconds = utils.parse_duration(val.time),
      comment = val.description,
      started = utc_time,
    }
    local response = curl.post(uri .. key .. '/worklog', {
      body = vim.fn.json_encode(json),
      auth = auth,
      headers = {
        content_type = "application/json",
      }
    })

    print("Status: " .. response.status)
    print("Body: " .. response.body)
  end
end

local M = {
  book_jira_time_entries = book_jira_time_entries,
  extract_jira_ticket_number = extract_jira_ticket_number,
}

return M
