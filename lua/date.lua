--[[
date_translator: 将 `date` 翻译为当前日期

translator 的功能是将分好段的输入串翻译为一系列候选项。

欲定义的 translator 包含三个输入参数：
 - input: 待翻译的字符串
 - seg: 包含 `start` 和 `_end` 两个属性，分别表示当前串在输入框中的起始和结束位置
 - env: 可选参数，表示 translator 所处的环境（本例没有体现）

translator 的输出是若干候选项。
与通常的函数使用 `return` 返回不同，translator 要求您使用 `yield` 产生候选项。

`yield` 每次只能产生一个候选项。有多个候选时，可以多次使用 `yield` 。

请看如下示例：
--]]
local date_m_tab = {'一','二','三', '四', '五', '六', '七', '八', '九', '十', '十一', '十二' }
---日
local date_d_tab = {'一','二','三', '四', '五', '六', '七', '八', '九', '十', '十一', '十二' , '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十', '二十一', '二十二', '二十三', '二十四', '二十五', '二十六', '二十七', '二十八', '二十九', '三十', '三十一' }

--- 翻译日期
local function translator(input, seg)
   -- 如果输入串为 `date` "rq" 则翻译
   if (input == "date" or input == "rq") then
      --[[ 用 `yield` 产生一个候选项
           候选项的构造函数是 `Candidate`，它有五个参数：
            - type: 字符串，表示候选项的类型
            - start: 候选项对应的输入串的起始位置
            - _end:  候选项对应的输入串的结束位置
            - text:  候选项的文本
            - comment: 候选项的注释
       --]]
      yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), "[日期]"))
      --[[ 用 `yield` 再产生一个候选项
           最终的效果是输入法候选框中出现两个格式不同的当前日期的候选项。
      --]]
      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "[日期]"))
      yield(Candidate("date", seg.start, seg._end, os.date("%d %B %Y"), "[日期]"))
      yield(Candidate("date", seg.start, seg._end, os.date("%B"), "[月份]"))


      --- Candidate(type, start, end, text, comment)
      -- yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))  ---效果：2021年02月25日
      -- yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))  ---效果：2021-02-25
      -- yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))  ---效果：2021/02/25
      -- yield(Candidate("date", seg.start, seg._end,date_m_tab[tonumber(os.date("%m"))].."月"..date_d_tab[tonumber(os.date("%d"))].."日",""))  ---输出效果（英文）：二月二十八日
      -- yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), ""))  ---效果：02-25
      -- yield(Candidate("date", seg.start, seg._end, os.date("%m月%d日"), ""))  ---效果：02月-25日
      -- yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y"), ""))  ---效果：02-25-2021
   end

--- 翻译时间
   if (input == "time" or input == "sj" or input == "uijm" or input == "now") then
      --- Candidate(type, start, end, text, comment)

      yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), "[時間]"))
      yield(Candidate("time", seg.start, seg._end, os.date("%H時%M分%S秒"), "[時間]"))

      -- yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), ""))  ---效果：23:52
      -- yield(Candidate("time", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), ""))   ---效果：20210225235334
      -- yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), ""))  ---效果：23:53:58
      -- yield(Candidate("time", seg.start, seg._end, os.date("%H点%M分%S秒"), ""))  ---效果：23:53:58

   end


   if (input == "week" or input == "xq") then
      ---根据星期的数字，输出对应数字的数组内容
      local weakTab = {'日', '一', '二', '三', '四', '五', '六'}
      local weakTab2 = {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'}
      local weakTab3 = {'日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'}
      local weakTab4 = {'にちようび', 'げつようび', 'かようび', 'すいようび', 'もくようび', 'きんようび', 'どようび'}
      local weakTab5 = weakTab4[tonumber(os.date("%w")+1)]

      yield(Candidate("week", seg.start, seg._end, "星期"..weakTab[tonumber(os.date("%w")+1)], "[星期]"))  ---拼接效果：星期四
      yield(Candidate("week", seg.start, seg._end, "周"..weakTab[tonumber(os.date("%w")+1)], "[星期]"))  ---拼接效果：周四
      yield(Candidate("week", seg.start, seg._end, weakTab2[tonumber(os.date("%w")+1)], "[星期]"))  ---效果（英文）：Sunday
      yield(Candidate("week", seg.start, seg._end, weakTab3[tonumber(os.date("%w")+1)], weakTab5))  ---效果（日文）：日曜日

   end

--- 翻译春夏秋冬
   if (input == "season" or input == "jj") then
      -- ---方法1，根据月份数字，输出对应数字的数组内容
      -- local weakTab = {'春天','春天','春天', '夏天', '夏天', '夏天', '秋天', '秋天', '秋天', '冬天', '冬天', '冬天'}
      -- local weakTab1 = {'Spring','Spring','Spring', 'Summer', 'Summer', 'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter', 'Winter', 'Winter'}

      -- yield(Candidate("date", seg.start, seg._end, weakTab[tonumber(os.date("%w")+1)], "[季节]"))  ---输出效果：春天
      -- yield(Candidate("date", seg.start, seg._end, weakTab1[tonumber(os.date("%w")+1)],"[季节]"))  ---输出效果（英文）：Spring

      ---方法2，通过 or 条件 ，判断对应月份属于什么季节
      if (os.date("%m") == "01" or os.date("%m") == "02" or os.date("%m") == "03" ) then
          weekstr = "春天"
          weekstr1 = "Spring"
      end
      if (os.date("%m") == "04" or os.date("%m") == "05" or os.date("%m") == "06" ) then
          weekstr = "夏天"
          weekstr1 = "Summer"
      end
      if (os.date("%m") == "07" or os.date("%m") == "08" or os.date("%m") == "09" ) then
          weekstr = "秋天"
          weekstr1 = "Autumn"
      end
      if (os.date("%m") == "10" or os.date("%m") == "11" or os.date("%m") == "12" ) then
          weekstr = "冬天"
          weekstr1 = "Winter"
      end

      yield(Candidate("season", seg.start, seg._end, weekstr, "[季节]"))  ---效果：春
      yield(Candidate("season", seg.start, seg._end, weekstr1,"[季节]"))  ---效果（英文）：Spring
   end

end

-- 将上述定义导出
return translator
