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

local function is_cjk(code)
  for i, charset in ipairs(charsets) do
    if ((code >= charset.first) and (code <= charset.last)) then
      return true
    end
  end
  return false
end

local function should_yield(text, option, coredb)
  local should_yield = true
  if option then
    for i in utf8.codes(text) do
      local code = utf8.codepoint(text, i)
      if is_cjk(code) then
        charset = coredb:lookup(utf8.char(code))
        if charset == "" then
          should_yield = false
          break
        end
      end
    end
  end
  return should_yield
end

local function filter(input, env)
  on = env.engine.context:get_option("extended_char")
  for cand in input:iter() do
    if should_yield(cand.text, on, env.coredb) then
      yield(cand)
    end
  end
end

local function init(env)
  -- 当此组件被载入时，打开反查库，并存入 `coredb` 中
  env.coredb = ReverseDb("build/core.reverse.bin")
end

return { init = init, func = filter }
