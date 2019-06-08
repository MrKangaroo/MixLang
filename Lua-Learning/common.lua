local os = os
local math = math
local type = type
local next = next
local pcall = pcall
local pairs = pairs
local select = select
local tonumber = tonumber
local tostring = tostring
local getmetatable = getmetatable
local common = {}
local metaCommon = {}

if not debug.getinfo(3) then
    print('This is a module to load with `local common = require("common")`.')
    os.exit(1)
end
metaCommon.__time = 0
metaCommon.__clok = 0
metaCommon.__func = {}
metaCommon.__sort = {}
metaCommon.__marg = 1e-10
metaCommon.__fmtb = "[%s]:%d {%s} [%d]<%s>[%s](%d)"
metaCommon.__type = { "number", "boolean", "string", "function", "table", "nil", "userdata" }
metaCommon.__syms = "1234567890abcdefghijklmnopqrstuvwxyxABCDEFGHIJKLMNOPQRSTUVWXYZ"
metaCommon.__metatable = "common.lib"
metaCommon.__nlog = { __top = 0 }
metaCommon.__rmod = {
    { "*all", "Read the whole file" },
    { "*line", "Read the next line(defaule)" },
    { "*number", "Read a number" },
    ["*all"] = true,
    ["*line"] = true,
    ["*number"] = true
}
metaCommon.__func["pi"] = {}
metaCommon.__func["pi"].foo = function(itr, top)
    if (top == itr) then return 1 end
    local bs, nu = ((2 * itr) + 1), ((itr + 1) ^ 2)
    return bs + nu / metaCommon.__func["pi"].foo(itr + 1, top)
end

metaCommon.__func["pi"].out = function(itr)
    return (4 / metaCommon.__func["pi"].foo(0, itr))
end

metaCommon.__func["exp"] = {}
metaCommon.__func["exp"].foo = function(itr, top)
    if (top == itr) then return 1 end; local fac = 1
    for I = 1, itr do fac = fac * I end
    return (1 / fac + metaCommon.__func["exp"].foo(itr + 1, top))
end
metaCommon.__func["exp"].out = function(itr)
    return metaCommon.__func["exp"].foo(1, itr)
end

metaCommon.__func["phi"] = {}
metaCommon.__func["phi"].foo = function(itr, top)
    if (top == itr) then return 1 end
    return (1 + (1 / metaCommon.__func["phi"].foo(itr + 1, top)))
end
metaCommon.__func["phi"].out = function(itr)
    return metaCommon.__func["phi"].foo(0, itr)
end

function common.isNil(nval)
    -- body
    return nval == nil
end

function common.isNan(nval)
    return nval ~= nval
end

function common.isInf(nval)
    if nval == math.huge then return true, 1 end
    if nval == -math.huge then return true, -1 end
    return false
end

function common.isTable(tval)
    return type(tval) == metaCommon.__type[5]
end

function common.isDryTable(tval)
    if (not common.isTable(tval)) then return false end
    return next(tval) == nil
end

function commin.isString(sval)
    local sTy = metaCommon.__type[3]
    return getmetatable(sTy) == getmetatable(sval)
end

function common.isDryString(sVal)
    if (not common.isString(sVal)) then return false end
    return (sVal == "")
end

function common.isNumber(nVal)
    if (not tonumber(nVal)) then return false end
    if (nil ~= getmetatable(nVal)) then return false end
    return (type(nVal) == metaCommon.__type[1])
end

function common.isInteger(nVal)
    if (not common.isNumber(nVal)) then return false end
    local nW, nF = math.modf(nVal); return (nF == 0)
end

function common.isFunction(fVal)
    return (type(fVal) == metaCommon.__type[4])
end

function common.isBool(bVal)
    if (bVal == true) then return true end
    if (bVal == false) then return true end
    return false
end

function common.isType(sT, iD)
    return (sT == metaCommon.__type[iD])
end


function common.logSkipAdd(...)
    local tArgs, tNlg = { ... }, metaCommon.__nlog
    for key, val in pairs(tArgs) do
        table.insert(tNlg, tostring(val))
        tNlg.__top = tNlg.__top + 1
    end
end

function common.logSkipClear(...)
    local tNlg = metaCommon.__nlog
    if(common.isDryTable(tNlg)) then tNlg.__top = 0
end