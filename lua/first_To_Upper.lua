--- 过滤器：英文首字母大写

local function first_To_Upper_filter(input)
    local l = {}
    -- 使用 `iter()` 遍历所有输入候选项
    for cand in input:iter() do
        -- 判断当前候选内容 `cand.text` 是否是英文
        for s, r in pairs(input) do
        if string.find(cand.text,"(%a+)") ~= nil then
            cand=(string.gsub(cand.text,"^%l",string.upper))
        end
        yield(cand)
        end
    end
      -- 在结果中对应产生一个带注释的候选
      yield(cand)

end

return(first_To_Upper_filter)