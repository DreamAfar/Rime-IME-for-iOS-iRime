-- Rime Script >https://github.com/baopaau/rime-lua-collection/blob/master/calculator_translator.lua
-- 簡易計算器（執行任何Lua表達式）
--
-- 格式：=<exp>
-- Lambda語法糖：\<arg>.<exp>|
--
-- 例子：
-- =1+1 輸出 2
-- =floor(9^(8/7)*cos(deg(6))) 輸出 -3
-- =e^pi>pi^e 輸出 true
-- =max({1,7,2}) 輸出 7
-- =map({1,2,3},\x.x^2|) 輸出 {1, 4, 9}
-- =map(range(-5,5),\x.x*pi/4|,deriv(sin)) 輸出 {-0.7071, -1, -0.7071, 0, 0.7071, 1, 0.7071, 0, -0.7071, -1}
-- =$(range(-5,5,0.01))(map,\x.-60*x^2-16*x+20|)(max)() 輸出 21.066
-- =test(\x.trunc(sin(x),1e-3)==trunc(deriv(cos)(x),1e-3)|,range(-2,2,0.1)) 輸出 true
--
-- 函数名 	描述 	格式 	结果
-- pi 	圆周率 	=pi 	3.1415926535898
-- abs 	取绝对值 	=abs(-2012) 	2012
-- ceil 	向上取整 	=ceil(9.1) 	10
-- floor 	向下取整 	=floor(9.9) 	9
-- max 	取参数最大值 	=max(2,4,6,8) 	8
-- min 	取参数最小值 	=min(2,4,6,8) 	2
-- pow 	计算x的y次幂 	=pow(2,16) 	65536
-- sqrt 	开平方 	=sqrt(65536) 	256
-- mod 	取模 	=mod(65535,2) 	1
-- modf 	取整数和小数部分 	=modf(20.12) 	20   0.12
-- randomseed 	设随机数种子 	=randomseed(os.time()) 	　
-- random 	取随机数 	=random(5,90) 	5~90
-- rad 	角度转弧度 	=rad(180) 	3.1415926535898
-- deg 	弧度转角度 	=deg(=pi) 	180
-- exp 	e的x次方 	=exp(4) 	54.598150033144
-- log 	计算x的自然对数 	=log(54.598150033144) 	4
-- log10 	计算10为底，x的对数 	=log10(1000) 	3
-- frexp 	将参数拆成x * (2 ^ y)的形式 	=frexp(160) 	0.625    8
-- ldexp 	计算x * (2 ^ y) 	=ldexp(0.625,8) 	160
-- sin 	正弦 	=sin(rad(30)) 	0.5
-- cos 	余弦 	=cos(rad(60)) 	0.5
-- tan 	正切 	=tan(rad(45)) 	1
-- asin 	反正弦 	=deg(asin(0.5)) 	30
-- acos 	反余弦 	=deg(acos(0.5)) 	60
-- atan 	反正切 	=deg(atan(1)) 	45
-- ————————————————



-- 安装：
-- - 將本文件保存至 <rime>/lua/
-- - 在 <rime>/rime.lua 新增一行：
--   `calculator_translator = require("calculator_translator")`
-- - 在 <rime>/<schema>.schema.yaml 新增：
--   `engine/translators/@next: lua_translator@calculator_translator`
--   `recognizer/patterns/expression: "^=.*$"`
-- 註：
-- - <rime> 替換爲RIME的共享目錄
-- - <schema> 替換爲自己的方案ID
-- - 如目錄／文件不存在，請自行創建

-- 定義全局函數、常數（注意命名空間污染）
cos = math.cos
sin = math.sin
tan = math.tan
acos = math.acos
asin = math.asin
atan = math.atan
rad = math.rad
deg = math.deg

abs = math.abs
floor = math.floor
ceil = math.ceil
mod = math.fmod

trunc = function (x, dc)
  if dc == nil then
    return math.modf(x)
  end
  return x - mod(x, dc)
end

round = function (x, dc)
  dc = dc or 1
  local dif = mod(x, dc)
  if abs(dif) > dc / 2 then
    return x < 0 and x - dif - dc or x - dif + dc
  end
  return x - dif
end

random = math.random
randomseed = math.randomseed

inf = math.huge
MAX_INT = math.maxinteger
MIN_INT = math.mininteger
pi = math.pi
sqrt = math.sqrt
exp = math.exp
e = exp(1)
ln = math.log
log = function (x, base)
  base = base or 10
  return ln(x)/ln(base)
end

min = function (arr)
  local m = inf
  for k, x in ipairs(arr) do
   m = x < m and x or m
  end
  return m
end

max = function (arr)
  local m = -inf
  for k, x in ipairs(arr) do
   m = x > m and x or m
  end
  return m
end

sum = function (t)
  local acc = 0
  for k,v in ipairs(t) do
    acc = acc + v
  end
  return acc
end

avg = function (t)
  return sum(t) / #t
end

isinteger = function (x)
  return math.fmod(x, 1) == 0
end

-- iterator . array
array = function (...)
  local arr = {}
  for v in ... do
    arr[#arr + 1] = v
  end
  return arr
end

-- iterator <- [form, to)
irange = function (from, to, step)
  if to == nil then
    to = from
    from = 0
  end
  step = step or 1
  local i = from - step
  to = to - step
  return function()
    if i < to then
      i = i + step
      return i
    end
  end
end

-- array <- [form, to)
range = function (from, to, step)
  return array(irange(from, to, step))
end

-- array . reversed iterator
irev = function (arr)
  local i = #arr + 1
  return function()
    if i > 1 then
      i = i - 1
      return arr[i]
    end
  end
end

-- array . reversed array
arev = function (arr)
  return array(irev(arr))
end

test = function (f, t)
  for k,v in ipairs(t) do
    if not f(v) then
      return false
    end
  end
  return true
end

-- # Functional
map = function (t, ...)
  local ta = {}
  for k,v in pairs(t) do
    local tmp = v
    for _,f in pairs({...}) do tmp = f(tmp) end
    ta[k] = tmp
  end
  return ta
end

filter = function (t, ...)
  local ta = {}
  local i = 1
  for k,v in pairs(t) do
    local erase = false
    for _,f in pairs({...}) do
      if not f(v) then
        erase = true
        break
      end
    end
    if not erase then
	  ta[i] = v
	  i = i + 1
    end
  end
  return ta
end

-- e.g: foldr({2,3},\n,x.x^n|,2) = 81
foldr = function (t, f, acc)
  for k,v in pairs(t) do
    acc = f(acc, v)
  end
  return acc
end

-- e.g: foldl({2,3},\n,x.x^n|,2) = 512
foldl = function (t, f, acc)
  for v in irev(t) do
    acc = f(acc, v)
  end
  return acc
end

-- 調用鏈生成函數（HOF for method chaining）
-- e.g: chain(range(-5,5))(map,\x.x/5|)(map,sin)(map,\x.e^x*10|)(map,floor)()
--    = floor(map(map(map(range(-5,5),\x.x/5|),sin),\x.e^x*10|))
--    = {4, 4, 5, 6, 8, 10, 12, 14, 17, 20}
-- 可以用 $ 代替 chain
chain = function (t)
  local ta = t
  local function cf(f, ...)
    if f ~= nil then
      ta = f(ta, ...)
      return cf
    else
      return ta
    end
  end
  return cf
end

-- # Statistics
fac = function (n)
  local acc = 1
  for i = 2,n do
    acc = acc * i
  end
  return acc
end

nPr = function (n, r)
  return fac(n) / fac(n - r)
end

nCr = function (n, r)
  return nPr(n,r) / fac(r)
end

MSE = function (t)
  local ss = 0
  local s = 0
  local n = #t
  for k,v in ipairs(t) do
    ss = ss + v*v
    s = s + v
  end
  return sqrt((n*ss - s*s) / (n*n))
end

-- # Linear Algebra


-- # Calculus
-- Linear approximation
lapproxd = function (f, delta)
  local delta = delta or 1e-8
  return function (x)
           return (f(x+delta) - f(x)) / delta
         end
end

-- Symmetric approximation
sapproxd = function (f, delta)
  local delta = delta or 1e-8
  return function (x)
           return (f(x+delta) - f(x-delta)) / delta / 2
         end
end

-- 近似導數
deriv = function (f, delta, dc)
  dc = dc or 1e-4
  local fd = sapproxd(f, delta)
  return function (x)
           return round(fd(x), dc)
         end
end

-- Trapezoidal rule
trapzo = function (f, a, b, n)
  local dif = b - a
  local acc = 0
  for i = 1, n-1 do
    acc = acc + f(a + dif * (i/n))
  end
  acc = acc * 2 + f(a) + f(b)
  acc = acc * dif / n / 2
  return acc
end

-- 近似積分
integ = function (f, delta, dc)
  delta = delta or 1e-4
  dc = dc or 1e-4
  return function (a, b)
           if b == nil then
             b = a
             a = 0
           end
           local n = round(abs(b - a) / delta)
           return round(trapzo(f, a, b, n), dc)
         end
end

-- Runge-Kutta
rk4 = function (f, timestep)
  local timestep = timestep or 0.01
  return function (start_x, start_y, time)
           local x = start_x
           local y = start_y
           local t = time
           -- loop until i >= t
           for i = 0, t, timestep do
             local k1 = f(x, y)
             local k2 = f(x + (timestep/2), y + (timestep/2)*k1)
             local k3 = f(x + (timestep/2), y + (timestep/2)*k2)
             local k4 = f(x + timestep, y + timestep*k3)
             y = y + (timestep/6)*(k1 + 2*k2 + 2*k3 + k4)
             x = x + timestep
           end
           return y
         end
end


-- # System
date = os.date
time = os.time
path = function ()
  return debug.getinfo(1).source:match("@?(.*/)")
end


local function serialize(obj)
  local type = type(obj)
  if type == "number" then
    return isinteger(obj) and floor(obj) or obj
  elseif type == "boolean" then
    return tostring(obj)
  elseif type == "string" then
    return '"'..obj..'"'
  elseif type == "table" then
    local str = "{"
    local i = 1
    for k, v in pairs(obj) do
      if i ~= k then  
        str = str.."["..serialize(k).."]="
      end
      str = str..serialize(v)..", "  
      i = i + 1
    end
    str = str:len() > 3 and str:sub(0,-3) or str
    return str.."}"
  elseif pcall(obj) then -- function類型
    return "callable"
  end
  return obj
end

-- greedy：隨時求值（每次變化都會求值，否則結尾爲特定字符時求值）
local greedy = true

local function calculator_translator(input, seg)
  if string.sub(input, 1, 1) ~= "=" then return end
  
  local expfin = greedy or string.sub(input, -1, -1) == ";"
  local exp = (greedy or not expfin) and string.sub(input, 2, -1) or string.sub(input, 2, -2)
  
  -- 空格輸入可能
  exp = exp:gsub("#", " ")
  
  -- yield(Candidate("number", seg.start, seg._end, exp, "表達式"))
       
  if not expfin then return end
  
  local expe = exp
  -- 鏈式調用語法糖
  expe = expe:gsub("%$", " chain ")
  -- lambda語法糖
  do
    local count
    repeat
      expe, count = expe:gsub("\\%s*([%a%d%s,_]-)%s*%.(.-)|", " (function (%1) return %2 end) ")
    until count == 0
  end
  --yield(Candidate("number", seg.start, seg._end, expe, "展開"))

  -- 防止危險操作，禁用os和io命名空間
  if expe:find("i?os?%.") then return end
  -- return語句保證了只有合法的Lua表達式才可執行
  local result = load("return "..expe)()
  if result == nil then return end


---阿拉伯数字转中文大写
local function  NumberToString(szNum)
  local szChMoney = ""  --转换后的字符串
  local iLen = 0  --初始化字符串的长度为0
  local iNum = 0
  local iAddZero = 0  --记录 添加零
  local hzUnit = {"", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿","拾", "佰", "仟", "万", "拾", "佰", "仟"}
  local hzNum = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"}
  --使用tonumber判断参数szNum是否为数字，或是一个可以转换为数字的字符串
  --如果调用的时候没有 base， tonumber 尝试把参数转换为一个数字。如果参数已经是一个数字，或是一个可以转换为数字的字符串，tonumber 就返回这个数字； 否则返回 nil（空）。
  if nil == tonumber(szNum) then
      return tostring(szNum)--参数不是数字或可以转换为数字的字符串，将参数szNum转换为字符串返回
  end
  -- --获取参数字符串的长度
  -- -- if iLen > 10 then
  -- --     return("数值太大了")
  -- -- end
  -- --如果字符串的长度大于12 或者=0(参数为空) 或者 参数转换为数字后 小于0
  --获取参数字符串的长度
  iLen =string.len(szNum)
  if iLen > 12 or iLen == 0 or tonumber(szNum) < 0 then
      return tostring(szNum)
  end

  --第一个元素1开始，iLen的长度结束
  for i = 1, iLen  do
      -- string.sub截取字符串，从第一个i（1）开始
      iNum = string.sub(szNum,i,i)
      --如果截取的字符iNum等于0 并且 i不等于字符串的长度（即不是字符串最后一个数字）
      if iNum == 0 and i ~= iLen then--如果是0并且不是数字最后的一个0（数字中间的0）
          iAddZero = iAddZero + 1  --记录要添加零+1
      else
          if iAddZero > 0 then  --记录要添加零大于0，字符串添加一个零
          szChMoney = szChMoney..hzNum[1]--字符串拼接:szChMoney + hzNum[1]元素：零
      end
          szChMoney = szChMoney..hzNum[iNum + 1] --//转换为相应的数字
          iAddZero = 0--将重置为0
      end
      --如果iAddZero小于4并且数字的长度-i的值%4 或者 当前截取的数字不等于0
      if (iAddZero < 4) and (0 == (iLen - i) % 4 or 0 ~= tonumber(iNum)) then
          szChMoney = szChMoney..hzUnit[iLen-i+1]--拼接单位（十、百、千、万）的字符
      end
  end

  local function removeZero(num)
      --去掉末尾多余的 零
      num = tostring(num)
      local szLen = string.len(num)
      local zero_num = 0
      for i = szLen, 1, -3 do
          szNum = string.sub(num,i-2,i)
          if szNum == hzNum[1] then
              zero_num = zero_num + 1
          else
              break
          end
      end
      num = string.sub(num, 1,szLen - zero_num * 3)
      szNum = string.sub(num, 1,6)
      --- 开头的 "一十" 转成 "十" , 贴近人的读法
      if szNum == hzNum[2]..hzUnit[2] then
          num = string.sub(num, 4, string.len(num))
      end
      --去掉连续三个零
      if string.find(num,"零零零") ~= nil then
          num=string.gsub(num,"零零零","零")
      
      end
      --去掉连续两个零
      if string.find(num,"零零") ~= nil then
          num=string.gsub(num,"零零","零")
      
      end
      --去掉十后面的零
      if string.find(num,"十零") ~= nil then
          num=string.gsub(num,"十零","十")
      end
      if string.find(num,"零万") ~= nil then
          num=string.gsub(num,"零万","万")
      end
      return num
  end

  return removeZero(szChMoney)
  -- return (szChMoney)
end

--小数转中文大写
local function Decimalnumber(SzNum)
  local szminNumber = ""
  local DecimalLen = 0
  local hzNum = {"壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖", "零"}

  DecimalLen = string.len(SzNum)

  for i = 1, DecimalLen , 1 do
      local number1=tonumber(string.sub(SzNum,i,i))
      if number1 == 0 then
          szminNumber = szminNumber..hzNum[10]
      else
          szminNumber = szminNumber..hzNum[number1]
      end
  end
  return szminNumber
end

-- for i = 1 ,200 do
--    print(numberToString(i))
-- end

local function FindNumber(SzNum)
  local Tostr = SzNum
  local MaxNumber=""
  local MinNumber=""
  local num1=0
  local num2=0
  local Pinjie=""
  --判断是否为0
  if tonumber(SzNum)==0 then
    return("零")
  end

  --判断数字长度是否超过千亿
  if tonumber(string.len(SzNum)) > 12 then
    return("土豪！数值太大了！")
  end

  --判断数字是否有小数 4560.13245
  if string.find(Tostr,"%p") ~= nil then
      --如果有,拆分开来
      num1,num2=string.find(Tostr,"%p")

      --截取小数点前面的数字
      MaxNumber=string.sub(Tostr,1,num1-1)
      MinNumber=string.sub(Tostr,num1+1,string.len(Tostr))

      --拼接转换中文大写后的数字
      local Bug=(NumberToString(MaxNumber))
      if tonumber(MaxNumber)>0 then
          Pinjie=Bug.."点"..Decimalnumber(MinNumber)
          return(Pinjie)
          else
          Pinjie=Bug.."零点"..Decimalnumber(MinNumber)
         return(Pinjie)
      end
  else
      --如果没有，直接将数字转换为中文大写
      return(NumberToString(SzNum))
  end
end

--壹万壹仟壹佰壹拾壹亿壹仟壹佰壹拾壹万壹仟壹佰壹拾壹

  result = serialize(result)
  yield(Candidate("number", seg.start, seg._end, result, "答案"))
  yield(Candidate("number", seg.start, seg._end, exp.." = "..result, "等式"))
  yield(Candidate("number", seg.start, seg._end, FindNumber(result), "大写"))
end

return calculator_translator
