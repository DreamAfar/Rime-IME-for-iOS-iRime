local charsets = {
  { first = 0x4E00, last = 0x9FFF }, -- basic
  { first = 0x3400, last = 0x4DBF }, -- ExtA
  { first = 0x20000, last = 0x2A6DF }, -- ExtB
  { first = 0x2A700, last = 0x2B73F }, -- ExtC
  { first = 0x2B740, last = 0x2B81F }, -- ExtD
  { first = 0x2B820, last = 0x2CEAF }, -- ExtE
  { first = 0x2CEB0, last = 0x2EBEF }, -- ExtF
  { first = 0x30000, last = 0x3134F }, -- ExtG
  { first = 0xF900, last = 0xFAFF }, -- Compatible
  { first = 0x2F800, last = 0x2FA1F }, -- Compatible Suplementary
  { first = 0x2F00, last = 0x2FD5 }, 
  { first = 0x2E80, last = 0x2EF3 }, 
  { first = 0x31C0, last = 0x31E3 }, 
  { first = 0x3005, last = 0x30FF }, 
  { first = 0xE000, last = 0xF8FF }, 
  { first = 0xF0000, last = 0xFFFFD }, 
  { first = 0x100000, last = 0x10FFFD }, 
}

--定义判断字符集方法
local function is_cjk(code)
  --使用ipairs迭代器遍历字符集
  for i, charset in ipairs(charsets) do
    --如果code：大于等于charsets字符集 且 小于等于charsets字符集，就返回true
    if ((code >= charset.first) and (code <= charset.last)) then
      return true
    end
  end
  return false
end


--定义should_yield方法，参数为：text, option, coredb
local function should_yield(text, option, coredb)
  --定义should_yield变量
  local should_yield = true
  --如果过滤字符开关打开为：true
  if option then
    --
    for i in utf8.codes(text) do

      local code = utf8.codepoint(text, i)--以整数形式返回 s 中 从位置 i 到 j 间（包括两端） 所有字符的编号。
      --调用判断字符集方法判断
      if is_cjk(code) then
        --coredb反查库中查找，并赋值给：charset
        charset = coredb:lookup(utf8.char(code))
        
        --如果charsets等于空：“”（说明core词库文件里面没有这个字），那么就返回false
        if charset == "" then
          -- should_yield值=false
          should_yield = false
          break
        end
      end
    end
  end
  return should_yield --返回should_yield值
end


--[[ 从 `env` 中拿到拼音的反查库 `pydb`。
`env` 是一个表，默认的属性有（本例没有使用）：
  - engine: 输入法引擎对象
  - name_space: 当前组件的实例名
`env` 还可以添加其他的属性，如本例的 `pydb`。
--]]
local function filter(input, env)
  --过滤字符集的开关
  on = env.engine.context:get_option("extended_char")--获取过滤字符集的开关状态：true  or  false
  --
  for cand in input:iter() do
    --调用should_yield方法，传递参数（cand.text, on, env.coredb），如果都为：true
    if should_yield(cand.text, on, env.coredb) then
      yield(cand)
    end
  end
end


--[[当需要在 `env` 中加入非默认的属性时，可以定义一个 init 函数对其初始化。--]]
local function init(env)
  -- 当此组件被载入时，打开反查库，并存入 `coredb` 中
  env.coredb = ReverseDb("build/core.reverse.bin") --ReverseDb("反查库bin文件的路径")
end



--[[ 导出带环境初始化的组件。
需要两个属性：
 - init: 指向初始化函数
 - func: 指向实际函数
--]]
return { init = init, func = filter }
