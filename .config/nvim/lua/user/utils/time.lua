local Time = {}
-- is_dark
-- @param sunrise number sunrise time in hours default 7
-- @param sunset number sunset time in hours default 18
-- @return boolean
function Time.is_dark(sunrise, sunset)
  sunrise = sunrise or 7
  sunset = sunset or 18

  local hour = tonumber(os.date "%H")
  return hour < sunrise or hour > sunset
end

-- is_light
-- @param sunrise number sunrise time in hours default 7
-- @param sunset number sunset time in hours default 18
function Time.is_light(sunrise, sunset)
  return not Time.is_dark(sunrise, sunset)
end

return Time
