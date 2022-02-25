function week_translator(input, seg)
   -- if (input == "week") then
   --    if (os.date("%w") == "0") then
   --       weekstr = "日"
   --    end
   --    if (os.date("%w") == "1") then
   --       weekstr = "一"
   --    end
   --    if (os.date("%w") == "2") then
   --       weekstr = "二"
   --    end
   --    if (os.date("%w") == "3") then
   --       weekstr = "三"
   --    end
   --    if (os.date("%w") == "4") then
   --       weekstr = "四"
   --    end
   --    if (os.date("%w") == "5") then
   --       weekstr = "五"
   --    end
   --    if (os.date("%w") == "6") then
   --       weekstr = "六"
   --    end
   --    yield(Candidate("qsj", seg.start, seg._end, " 星期"..weekstr, "[星期]"))
   --    yield(Candidate("date", seg.start, seg._end, os.date("%A"), "[星期]"))
   -- end

--     -- @JiandanDream
--     -- https://github.com/KyleBing/rime-wubi86-jidian/issues/54

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
end
return week_translator
