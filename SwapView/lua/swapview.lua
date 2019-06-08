--
-- Created by IntelliJ IDEA.
-- User: mr-kangaroo
-- Date: 2019/6/8
-- Time: 5:50 PM
-- To change this template use File | Settings | File Templates.
--

require("lfs")

local format = string.format
local nullstr

if jit then
    nullstr = '%z'
else
    nullstr = '\x00'
end


function fileSize(size)
    local units = {'K', 'M', 'G', 'T' }
    local value =  math.abs( size )
    local unit = 0
    
    while value > 1100 and unit < 4 do
        value = value / 1024
        unit = unit + 1
    end
    if unit == 0 then
        return format('%dB', size)
    else
        if size < 0 then
            value = -value
        end
        return format('%.1f%siB',value, units[unit])
    end
end

function getSwapFor( pid )
    local open = io.open
    local swapfile = open(format('/proc/%s/smaps',pid),'r')
    if not swapfile then return 0, '' end

    local ok, size = pcall(function ( ... )
        -- body
        local size = 0
        for line in swapfile:lines() do
            if line:sub(1, 5) == 'Swap:' then
                size = size + tonumber(line:match('%d+'))
            end
        end
        return size
    end)
    swapfile:close()
    if not ok then return 0, '' end

    local cmdfile = open(format('/proc/%s/cmdline',pid),'r')
    if not cmdfile then return 0, '' end

    local cmd = cmdfile:read('*a')
    cmdfile:close()

    if cmd and cmd:byte(#cmd) == 0 then
        cmd = cmd:sub(1, #cmd -1)
    end
    cmd =  cmd:gsub(nullstr, ' ')
    return size * 1024, cmd
end

function getSwap( )
    -- body
    local ret = {}
    local insert = table.insert
    for pid in lfs.dir('/proc') do
        if tonumber(pid) then
            size, cmd = getSwapFor(pid)
            if size > 0 then
                insert(ret, {pid,size,cmd})
            end
        end
    end

    table.sort( ret, function( a, b )
        -- body
        return a[2] < b[2]
    end)
    return ret
end

local fmt = "%5s %9s %s"
local totalFmt = "Total: %8s"
local results = getSwap()
local sum = 0
print(format(fmt,'PID','SWAP','COMMAND'))
for _, v in ipairs(results) do
    print(format(fmt,v[1],fileSize(v[2],v[3])))
    sum = sum + v[2]
end
print(format(totalFmt,fileSize(sum)))