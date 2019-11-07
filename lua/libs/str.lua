#!/usr/bin/env lua

local M = {}

local function split_space(s)
    local items = {}
    for i in string.gmatch(s, "%S+") do
        items[#items + 1] = i
    end

    return items
end

M.split_space = split_space

return M
