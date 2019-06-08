-- 字符串连接
local str = "hello " .. 'world'
print(str)

-- string format
print(("%d"):format(1))
print(("%.2f"):format(1.5222))
print(("%.0f"):format(1.44))

-- patterns and capture
local text = '21.12,24.16,"-1.1%"'
print(string.match( text,'%d'))
print(string.match( text,'%-?%d[%.%d]*'))
print(string.match( text,'(%-?%d[%.%d]*),(%-?%d[%.%d]*)'))

-- stand io
name = 'kitty'
-- print("what's you name ?")
-- name = io.read()
-- print("what's you age ?")
-- age = io.read('*n')
-- print('You name is' .. name .. 'and You age is ' .. age)

-- multiple variables localized and swap value
local a ,b = 1,2
local a ,b = b ,a
print(a .. ' ' .. b)

-- define function
function myFunction()
    -- body
    return 2,3,4
end
-- assign multiple values
local q,w,e = myFunction()
print(q .. ' '  .. w .. ' ' .. e)

x = 10
do 
    local x = x
    print(x)
    x = x + 1
    do
        local x = x + 1
        print(x)
    end
    print(x)
end
print(x)

-- selection
if x > 11 then
    print("x > 11")
else
    print("x < 11")
end

-- for loop
for i=1,2 do
    greeting = i==1 and 'Hello' or 'Bye'
    print(greeting, name)
end

-- while loop
local num = 5
while num ~= 0 do
    print(num)
    num = num -1
end

-- table: the only data structure in lua
paybyweek = {11,33,44,55}
paybyperson = {a = 11, bb = 33, cc = 44, dd = 55}

-- iterator over array part
for week,pay in ipairs(paybyweek) do
    print('Paid ' .. pay .. ' in week ' .. week)
end

-- iterator over hash part
for person,pay in pairs(paybyperson) do
    print('paid ' .. pay .. ' to ' .. person)
end

if paybyperson['a'] then
    -- body
    print('aaaa')
end

-- random
local M, N = 10,20
math.random()
math.random( M)
math.random( M,N)