local Time = {}
-- is_dark
function Time.is_dark()
  local hour = tonumber(os.date "%H")
  return hour < 7 or hour > 18
end

-- is_light
function Time.is_light()
  return not Time.is_dark()
end

return Time
