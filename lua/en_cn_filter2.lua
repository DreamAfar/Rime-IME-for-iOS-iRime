--[[

filter 的功能是对 translator 翻译而来的候选项做修饰，
如：去除不想要的候选、为候选加注释、候选项重排序等。

欲定义的 filter 包含两个输入参数：
 - input: 候选项列表
 - env: 可选参数，表示 filter 所处的环境（本例没有体现）

translator 的功能是将分好段的输入串翻译为一系列候选项。

欲定义的 translator 包含三个输入参数：
 - input: 待翻译的字符串
 - seg: 包含 `start` 和 `_end` 两个属性，分别表示当前串在输入框中的起始和结束位置
 - env: 可选参数，表示 translator 所处的环境（本例没有体现）

translator 的输出是若干候选项。
与通常的函数使用 `return` 返回不同，translator 要求您使用 `yield` 产生候选项。

`yield` 每次只能产生一个候选项。有多个候选时，可以多次使用 `yield` 。

用 `yield` 产生一个候选项
   候选项的构造函数是 `Candidate`，它有五个参数：
   - type: 字符串，表示候选项的类型
   - start: 候选项对应的输入串的起始位置
   - _end:  候选项对应的输入串的结束位置
   - text:  候选项的文本
   - comment: 候选项的注释
--- Candidate(type, start, end, text, comment)

修改候选的注释 `cand.comment`
   因复杂类型候选项的注释不能被直接修改，
   因此使用 `get_genuine()` 得到其对应真实的候选项


cand.text：候选词
english_rvdb:lookup(cand.text)：当前反查单词的编码

--]]
   --[[ 从 `env` 中拿到Qiao_cn_en2的反查库 `endb`。
      `env` 是一个表，默认的属性有（本例没有使用）：
         - engine: 输入法引擎对象
         - name_space: 当前组件的实例名
      `env` 还可以添加其他的属性，如本例的 `endb`。
   --]]
   -- local english_rvdb = english_rvdb--输入（反查单词）的编码



-- local context = env.engine.context

-- local composition = context.composition
-- local segment = composition:back()
-- local candidate_count = segment.menu:candidate_count() -- 候选项数量

-- local selected_candidate=segment:get_selected_candidate() -- 焦点项

-- local cand=segment:get_candidate_at(index).text -- 获取指定项 从0起


local function reverse_lookup_filter(input, env)

   local en_cand={}--英文词组
   local en_cn_cand={}--英文+中文词组

   local leng = 0
   local length = 0
   for cand in input:iter() do
      local text = cand.text
      -- local commit = env.engine.context:get_commit_text()

      local word_text = cand.text--反查单词
      local code_text = english_rvdb:lookup(cand.text)--输入（反查单词）的编码
      local leng = utf8.len(code_text)--编码的长度

      -- if(leng > 1 and utf8.len(word_text)== utf8.len(code_text)) then  --过滤掉候选词和编码长度不相等的词
      if(leng > 1 ) then--首碼不使用反查，编码2位以上的
      length = leng
      
         -- local c=(Candidate("en", 0, cand._end, code_text, "[en]"))
         local c=(Candidate("en", cand.start, cand._end, text, "[en]"))
         -- local c=(Candidate("en", cand.start, cand._end, text, "[en]"))
         table.insert(en_cn_cand, c)
      end
      table.insert(en_cn_cand, cand)
   end

   --输出英文+中文候选词
   for i, cand in ipairs(en_cn_cand) do
      yield(cand)
   end
end


--[[
如下，filter 除 `input` 外，可以有第二个参数 `env`。
--]]

local function filter(input, env)

   local context = env.engine.context
   -- local input_len = string.len(env.engine.context.input)--输入的编码长度
   local input_len = string.len(context.input)--输入的编码长度
   local english_rvdb = ReverseDb("build/Qiao_cn_en2.reverse.bin")--英文反查词典
   local py_rvdb = ReverseDb("build/Qiao.extended.reverse.bin")--拼音反查词典

   local leng = 0
   local length = 0
   local en_cand={}--英文词组
   local en_cn_cand={}--英文+中文词组
   -- local composition = context.composition
   -- local segment = composition:back()
   -- local candidate_count = segment.menu:candidate_count() -- 候选项数量

   for cand in input:iter() do
      local text = cand.text
      -- local commit = env.engine.context:get_commit_text()
      local selected_candidate=cand:get_selected_candidate() -- 焦点项

      -- local cand=segment:get_candidate_at(index).text -- 获取指定项 从0起
      local word_text = cand.text--反查单词
      local code_text = english_rvdb:lookup(cand.text)--输入（反查单词）的编码
      local leng = utf8.len(code_text)--编码的长度

      -- if(leng > 1 and utf8.len(word_text)== utf8.len(code_text)) then  --过滤掉候选词和编码长度不相等的词
      if(leng > 1 ) then--首碼不使用反查，编码2位以上的
      --    length = leng
      
      --    -- local c=(Candidate("en", 0, cand._end, code_text, "[en]"))
         local c=(Candidate("en", cand.start, cand._end, selected_candidate, "[en]"))
         -- local c=(Candidate("en", cand.start, cand._end, text, "[en]"))
         table.insert(en_cn_cand, c)
      end
      table.insert(en_cn_cand, cand)
   end

   --输出英文+中文候选词
   for i, cand in ipairs(en_cn_cand) do
      yield(cand)
   end


   -- reverse_lookup_filter(input, env.english_rvdb)
end


--[[
当需要在 `env` 中加入非默认的属性时，可以定义一个 init 函数对其初始化。
--]]
local function init(env)
   -- 当此组件被载入时，打开反查库，并存入 `english_db` 中
   -- env.english_rvdb = ReverseDb("build/Qiao_cn_en2.reverse.bin")--英文反查词典
   -- env.py_rvdb = ReverseDb("build/Qiao.extended.reverse.bin")--拼音反查词典
end

--[[ 导出带环境初始化的组件。
需要两个属性：
- init: 指向初始化函数
- func: 指向实际函数
--]]
return { init = init, func = filter}