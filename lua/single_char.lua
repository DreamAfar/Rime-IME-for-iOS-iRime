--[[
single_char_filter: 候选项重排序，使单字优先
--]]

--候选项重排序，使候选字与输入编码一致的优先

local function filter(input, env)
   local l = {}

   for cand in input:iter() do
      local commit = env.engine.context:get_commit_text()--输入的编码

      if (string.lower(cand.text) == commit) then --如果候选字的转小写后 等于输入的编码
      yield(cand)
      else
     table.insert(l, cand) --将当前候选 cand 插入 l 数组中
      end
   end

   for i, cand in ipairs(l) do
      yield(cand)
   end
end



--候选项重排序，使单字优先

--[[
local function filter(input)
    local l = {}
    for cand in input:iter() do
       if (utf8.len(cand.text) == 1) then
      yield(cand)
       else
      table.insert(l, cand)
       end
    end
    for i, cand in ipairs(l) do
       yield(cand)
    end
 end

--]]

 return filter