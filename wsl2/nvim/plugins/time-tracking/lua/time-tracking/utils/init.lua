-- convert seconds to string like 1h 10m 5s
local function format_duration(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remaining_seconds = seconds % 60

    local result = ""

    if hours > 0 then
        result = result .. hours .. "h "
    end

    if minutes > 0 then
        result = result .. minutes .. "m "
    end

    if remaining_seconds > 0 then
        result = result .. remaining_seconds .. "s"
    end

    return result
end

-- convert string like 1h 10m 5s to seconds
local function parse_duration(duration_str)
    print("duration str: " .. duration_str)
    local total_seconds = 0
    for num, unit in duration_str:gmatch("(%d*) ?(%a)") do
        num = tonumber(num) or 0
        if unit == "h" then
            total_seconds = total_seconds + num * 3600
        elseif unit == "m" then
            total_seconds = total_seconds + num * 60
        elseif unit == "s" then
            total_seconds = total_seconds + num
        end
    end

    return total_seconds
end

local function parse_date_from_path(path)
      -- Match the date part of the path in the format 'yyyy/mm/dd'
    local year, month, day = path:match("(%d+)/(%d+)/(%d+)%.md")

    -- Convert the matched values to numbers
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)

    return year, month, day
end

local function get_utc_time(year, month, day)
    -- Define the UTC offset for your local time zone (e.g., UTC+02:00 for Central European Summer Time)
    local utc_offset_hours = 2
    local utc_offset_minutes = 0
    local date_table = {year = year, month = month, day = day}
    local timestamp = os.time(date_table) - (utc_offset_hours * 3600 + utc_offset_minutes * 60)

    return os.date("!%Y-%m-%dT%H:%M:%S.", timestamp) .. "000+0200"
end


local function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

M = {
    format_duration = format_duration,
    parse_duration = parse_duration,
    parse_date_from_path = parse_date_from_path,
    get_utc_time = get_utc_time,
    tprint = tprint,
}

return M

