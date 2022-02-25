--[[
datetime_translator: 将 `ors` 翻译为当前日期
--]]
local function translator(input, seg)
   if (input == "ors") then
      yield(Candidate("ors", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), ""))
   end
end

return translator
