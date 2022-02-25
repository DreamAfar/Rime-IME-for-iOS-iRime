-- input：输入
-- yield：产出
--seg：
--env：

-- translator 的功能是将分好段的输入串翻译为一系列候选项。

-- 欲定义的 translator 包含三个输入参数：
--  - input: 待翻译的字符串
--  - seg: 包含 `start` 和 `_end` 两个属性，分别表示当前串在输入框中的起始和结束位置
--  - env: 可选参数，表示 translator 所处的环境（本例没有体现）

-- translator 的输出是若干候选项。
-- 与通常的函数使用 `return` 返回不同，translator 要求您使用 `yield` 产生候选项。
-- `yield` 每次只能产生一个候选项。有多个候选时，可以多次使用 `yield` 。

--[[ 用 `yield` 产生一个候选项
    候选项的构造函数是 `Candidate`，它有五个参数：
    - type: 字符串，表示候选项的类型
    - start: 候选项对应的输入串的起始位置
    - _end:  候选项对应的输入串的结束位置
    - text:  候选项的文本
    - comment: 候选项的注释
--]]

function get_date(input, seg, env)
    --- 以 show_date 爲開關名或 key_binder 中 toggle 的對象
    on = env.engine.context:get_option("show_date")
    -- 如果on并且input（输入的编码）等于"date"
    if (on and input == "date") then
        --- yield（产出）Candidate(候选字)(type, start, end, text, comment)
        yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), " 日期"))
    end
end

function single_char_first(input, env)
    --- 以 single_char 爲開關名或 key_binder 中 toggle 的對象
    on = env.engine.context:get_option("single_char")

    -- 定义临时局部变量（local）为cache数组
    local cache = {}

    for cand in input:iter() do
        -- 如果on（get_option("single_char")）或候选字的长度等于1（就是单字），就做
        if (not on or utf8.len(cand.text) == 1) then
            -- 原封不打输出
            yield(cand)
        else
            -- 将单字插入到cache数组
            table.insert(cache, cand)
        end
    end
    -- 使用ipairs迭代器，将cache数组循环遍历输出（yield）
    for i, cand in ipairs(cache) do
        yield(cand)
    end
end
