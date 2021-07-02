--英语方案
-- local english = require("english")()
-- english_processor = english.processor
-- english_segmentor = english.segmentor
-- english_translator = english.translator
-- english_filter = english.filter
-- english_filter0 = english.filter0

-- 在Rime輸入任意Unicode字符
-- unicode_translator = require("unicode_translator")

-- 在Rime使用計算器
calculator_translator = require("calculator_translator")

-- 以词定字
-- 详见 `lua/select_character.lua`
select_character_processor = require("select_character")

-- 过滤iOS无法显示的字
core = require("core_filter")


function date_translator(input, seg)

    ---月份
    local date_m_tab = {'一','二','三', '四', '五', '六', '七', '八', '九', '十', '十一', '十二' }
    ---日
    local date_d_tab = {'一','二','三', '四', '五', '六', '七', '八', '九', '十', '十一', '十二' , '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十', '二十一', '二十二', '二十三', '二十四', '二十五', '二十六', '二十七', '二十八', '二十九', '三十', '三十一' }

    --- 翻译日期
    if (input == "date" or input == "rq") then


        --- Candidate(type, start, end, text, comment)
        yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))  ---效果：2021年02月25日
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))  ---效果：2021-02-25
        -- yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))  ---效果：2021/02/25
        yield(Candidate("date", seg.start, seg._end,date_m_tab[tonumber(os.date("%m"))].."月"..date_d_tab[tonumber(os.date("%d"))].."日",""))  ---输出效果（英文）：二月二十八日
        -- yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), ""))  ---效果：02-25
        -- yield(Candidate("date", seg.start, seg._end, os.date("%m月%d日"), ""))  ---效果：02月-25日
        -- yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y"), ""))  ---效果：02-25-2021
    end

    --- 翻译春夏秋冬
    if (input == "season" or input == "jj") then
        ---方法1，根据月份数字，输出对应数字的数组内容
        local weakTab = {'春天','春天','春天', '夏天', '夏天', '夏天', '秋天', '秋天', '秋天', '冬天', '冬天', '冬天'}
        local weakTab1 = {'Spring','Spring','Spring', 'Summer', 'Summer', 'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter', 'Winter', 'Winter'}

        yield(Candidate("week", seg.start, seg._end, weakTab[tonumber(os.date("%w")+1)], ""))  ---输出效果：春天
        yield(Candidate("season", seg.start, seg._end, weakTab1[tonumber(os.date("%w")+1)],""))  ---输出效果（英文）：Spring

        -- ---方法2，通过 or 条件 ，判断对应月份属于什么季节
        -- if (os.date("%m") == "01" or os.date("%m") == "02" or os.date("%m") == "03" ) then
        --     weekstr = "春天"
        --     weekstr1 = "Spring"
        -- end
        -- if (os.date("%m") == "04" or os.date("%m") == "05" or os.date("%m") == "06" ) then
        --     weekstr = "夏天"
        --     weekstr1 = "Summer"
        -- end
        -- if (os.date("%m") == "07" or os.date("%m") == "08" or os.date("%m") == "09" ) then
        --     weekstr = "秋天"
        --     weekstr1 = "Autumn"
        -- end
        -- if (os.date("%m") == "10" or os.date("%m") == "11" or os.date("%m") == "12" ) then
        --     weekstr = "冬天"
        --     weekstr1 = "Winter"
        -- end

        -- yield(Candidate("season", seg.start, seg._end, weekstr, ""))  ---效果：春
        -- yield(Candidate("season", seg.start, seg._end, weekstr1,""))  ---效果（英文）：Spring
    end

    --- 翻译时间
    if (input == "time" or input == "sj" or input == "uijm" or input == "now") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), ""))  ---效果：23:52
        -- yield(Candidate("time", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), ""))   ---效果：20210225235334
        -- yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), ""))  ---效果：23:53:58
        -- yield(Candidate("time", seg.start, seg._end, os.date("%H点%M分%S秒"), ""))  ---效果：23:53:58
    end

    -- @JiandanDream
    -- https://github.com/KyleBing/rime-wubi86-jidian/issues/54

    if (input == "week" or input == "xq") then
        ---根据星期的数字，输出对应数字的数组内容
        local weakTab = {'日', '一', '二', '三', '四', '五', '六'}
        local weakTab2 = {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'}
        local weakTab3 = {'日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'}
        local weakTab4 = {'にちようび', 'げつようび', 'かようび', 'すいようび', 'もくようび', 'きんようび', 'どようび'}
        local weakTab5 = weakTab4[tonumber(os.date("%w")+1)]

        yield(Candidate("week", seg.start, seg._end, "星期"..weakTab[tonumber(os.date("%w")+1)], ""))  ---拼接效果：星期四
        yield(Candidate("week", seg.start, seg._end, "周"..weakTab[tonumber(os.date("%w")+1)], ""))  ---拼接效果：周四
        yield(Candidate("week", seg.start, seg._end, weakTab2[tonumber(os.date("%w")+1)], ""))  ---效果（英文）：Sunday
        yield(Candidate("week", seg.start, seg._end, weakTab3[tonumber(os.date("%w")+1)], weakTab5))  ---效果（日文）：日曜日

    end
end

--- 过滤器：候选项重排序，使单字优先
function single_char_first_filter(input)
    local l = {}
    for cand in input:iter() do
        if (utf8.len(cand.text) == 1) then
            yield(cand)
        else
            table.insert(l, cand)
        end
    end
    for cand in ipairs(l) do
        yield(cand)
    end
end