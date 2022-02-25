-- 获取用户目录
local function getCurrentDir()
    function sum(a, b) return a + b end
    local info = debug.getinfo(sum)
    local path = info.source
    path = string.sub(path, 2, -1) -- 去掉开头的"@"
    path = string.match(path, "^(.*[\\/])") -- 捕获目录路径
    local spacer = string.match(path, "[\\/]")
    path = string.gsub(path, '[\\/]', spacer) .. ".." .. spacer
    return path
end

-- 词尾输入--保存词条到英文用户词库
local function filter(input, env)

    local context = env.engine.context
    -- local input_len = string.len(env.engine.context.input)--输入的编码长度
    -- local english_rvdb = ReverseDb("build/Qiao_cn_en2.reverse.bin") -- 英文反查词典
    local english_rvdb = ReverseDb("build/melt_eng.reverse.bin") -- 英文反查词典
    local py_rvdb = ReverseDb("build/Qiao.extended.reverse.bin") -- 拼音反查词典

    local en_cand = {} -- 英文词组
    local en_cn_cand = {} -- 英文+中文词组

    -- local context = env.engine.context
    -- local composition = context.composition
    -- local segment = composition:back()
    -- local candidate_count = segment.menu:candidate_count() -- 候选项数量
    -- local selected_candidate=segment:get_selected_candidate() -- 焦点项
    -- local cand=segment:get_candidate_at(index).text -- 获取指定项 从 0 起

    for cand in input:iter() do

        local input_len = string.len(context.input) -- 输入的编码长度
        local text = cand.text -- 候选的单词
        local commit = env.engine.context:get_commit_text() -- 输入的编码
        local code_text = english_rvdb:lookup(cand.text) -- 英文候选单词的编码
        local code_text2 = py_rvdb:lookup(cand.text) -- 中文候选单词的全拼编码

        local leng = utf8.len(code_text) -- 编码的长度
        local leng2 = utf8.len(code_text2) -- 编码的长度

        -- if (string.sub(input, -1) == ";") then
        --     local inpu = string.gsub(input, "[;]+$", "") -- 移除;;后的输入编码
        --     local inpu2 = string.gsub(inpu, "[a-z]+[;]", "")
        --     local lower = string.lower(inpu) -- 转换大写字母为小写
        --     if (string.len(inpu) > 1 and string.sub(input, 1, 1) ~= ";") then
        --         if (string.sub(input, -2) == ";;") then

        --             ppath = getCurrentDir() .. "Qiao_en.dict.yaml"
        --             -- ppath = getCurrentDir() .. "custom_phrase_en.txt"

        --             local file = io.open(ppath, "a") -- "a" 追加写入模式。
        --             file:write("\n" .. inpu .. "\t" .. lower .. "\t100")
        --             file:close()
        --             yield(Candidate("pin", seg.start, seg._end, inpu, " 已保存"))
        --         else
        --             yield(
        --                 Candidate("pin", seg.start, seg._end, inpu, " -保存"))
        --         end
        --     end
        -- end

        -- if (input_len > 1 and commit ~= code_text) then -- 过滤掉候选词和编码长度不相等的词
            if (input_len > 1 and utf8.len(text) == utf8.len(commit)) then -- 过滤掉候选词和编码长度不相等的词
            -- if (input_len > 1) then -- 首碼不使用反查，编码2位以上的

            table.insert(en_cand, (Candidate("en", cand.start, cand._end,
                                             commit, "[en]")))
        end

        table.insert(en_cn_cand, cand)
    end

    for i, cand in ipairs(en_cand) do yield(cand) end

    -- 输出英文+中文候选词
    for i, cand in ipairs(en_cn_cand) do yield(cand) end
end
return {init = init, func = filter}
