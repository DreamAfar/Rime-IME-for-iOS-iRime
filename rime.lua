--[[
librime-lua 样例

调用方法：
在配方文件中作如下修改：
```
  engine:
    ...
    translators:
      ...
      - lua_translator@lua_function3
      - lua_translator@lua_function4
      ...
    filters:
      ...
      - lua_filter@lua_function1
      - lua_filter@lua_function2
      ...
```

其中各 `lua_function` 为在本文件所定义变量名。
--]] --[[
本文件的后面是若干个例子，按照由简单到复杂的顺序示例了 librime-lua 的用法。
每个例子都被组织在 `lua` 目录下的单独文件中，打开对应文件可看到实现和注解。

各例可使用 `require` 引入。
如：
```
  foo = require("bar")
```
可认为是载入 `lua/bar.lua` 中的例子，并起名为 `foo`。
配方文件中的引用方法为：`...@foo`。

--]]

-- local english = require("english")()
-- english_processor = english.processor
-- english_segmentor = english.segmentor
-- english_translator = english.translator
-- english_filter = english.filter
-- english_filter0 = english.filter0

-- local M= require("melt")
-- get_date = M.getdate
-- jpcharset_filter = M.jpcharsetfilter
-- long_word_filter = M.longwordfilter
-- autocap_filter =M.autocapfilter
-- oo_processor = M.ooprocessor
-- oo_filter =M.oofilter

-- table_tran= require("table_translator")
-- easy_en_cn_translator: 候选
-- 详见 `lua/easy_en_cn.lua`

-- en_cn = require("en_cn_filter")

local en_cn = require("en_cn_mix")()
en_cn_processor = en_cn.processor
-- en_cn_mix_segmentor = en_cn_mix.segmentor
-- en_cn_mix_translator = en_cn.translator
en_cn_filter = en_cn.filter

history_processor = require('history')

--
-- user_dictionary = require("user_dictionary")
user_dictionary = require("user_dictionary2")

-- iRime嵌入式编码显示首选
preedit_preview = require("preedit_preview")

-- iRime九宫格方案编码提示lua
preedit_filter = require("preedit")

-- 在Rime輸入任意Unicode字符
-- unicode_translator = require("unicode_translator")

-- 在Rime使用計算器
calculator_translator = require("calculator_translator")

-- 以词定字
-- 详见 `lua/select_character.lua`
select_character_processor = require("select_character")

-- 过滤iOS无法显示的字
core = require("core_filter")

-- easy_en_enhance_filter: 连续输入增强
-- 详见 `lua/easy_en.lua`
local easy_en = require("easy_en")
easy_en_enhance_filter = easy_en.enhance_filter

-- single_char_filter: 候选项英文首字母大写
-- 详见 `lua/single_char.lua`
-- first_To_Upper_filter = require("first_to_upper")

-- single_char_filter: 候选项重排序，使单字优先
-- 详见 `lua/single_char.lua`
single_char_filter = require("single_char")

-- charset_filter: 滤除含 CJK 扩展汉字的候选项
-- charset_comment_filter: 为候选项加上其所属字符集的注释
-- 详见 `lua/charset.lua`
local charset = require("charset")
charset_filter = charset.filter
charset_comment_filter = charset.comment_filter

-- reverse_lookup_filter: 依地球拼音为候选项加上带调拼音的注释
-- 详见 `lua/reverse.lua`
reverse_lookup_filter = require("reverse")

-- date_translator: 将 `date` 翻译为当前日期
-- 详见 `lua/date.lua`:
date_translator = require("date")

-- time_translator: 将 `time` 翻译为当前时间
-- 详见 `lua/time.lua`
-- time_translator = require("time")

-- number_translator: 将 `/` + 阿拉伯数字 翻译为大小写汉字
-- 详见 `lua/number.lua`
number_translator = require("number")

-- number_translator: 将 `/` + 阿拉伯数字 翻译为大小写汉字
-- 详见 `lua/number.lua`
-- week_translator = require("week")

-- use wildcard to search code 使用通配符搜索代码
expand_translator = require("expand_translator")

-- III. processors:

-- switch_processor: 通过选择自定义的候选项来切换开关（以简繁切换和下一方案为例）
-- 详见 `lua/switch.lua`
switch_processor = require("switch")

-- 不使用连续输入增强
-- 你可以在 easy_en.custom.yaml 的 patch 节点中添加选项以关闭连续输入增强功能。

-- patch:
--   engine/filters:
--     - uniquifier
-- 在某些系统上，若不按照类似上述方式手动关闭连续输入增强，即使没有引入 lua 脚本也会导致 easy_en 无法正常使用。

-- date_translator: 将 `date` 翻译为当前日期
-- 详见 `lua/date.lua`:
xkdate_translator = require("xkdate")

-- time_translator: 将 `time` 翻译为当前时间
-- 详见 `lua/time.lua`
xktime_translator = require("xktime")

-- xkjd6_filter: 单字模式 & 630 即 ss 词组提示
--- 修改自 @懒散 TsFreddie https://github.com/TsFreddie/jdc_lambda/blob/master/rime/lua/xkjdc_sbb_hint.lua
-- 可由 schema 的 danzi_mode 与 wxw_hint 开关控制
-- 详见 `lua/xkjd6_filter.lua`
xkjd6_filter = require("xkjd6_filter")

-- 顶功处理器
topup_processor = require("for_topup")

-- 声笔笔简码提示 | 顶功提示 | 补全处理
hint_filter = require("for_hint")

-- number_translator: 将 `=` + 阿拉伯数字 翻译为大小写汉字
-- 详见 `lua/number.lua`
number_translator = require("xnumber")

-- 用 ' 作为次选键
smart_2 = require("smart_2")
