#!/usr/bin/env lua
-- FILEYSTEM FUNCTIONS
-- Rev. Date: 11-07-2019
-- Function List:
-- df_usage(): mounted fs space/inode usage

local str = require "str"

local M = {}

local cat = "fs"

local function df_usage()
    local df_cmd_array = {}
    local df_metrics = {"fs", "total", "used", "avail", "used_pct"}

    -- space usage
    local prefix = "space"
    local df_space_cmd_handle = io.popen("/bin/df -P", "r")

    if df_space_cmd_handle:read(0) ~= nil then
	    for space in df_space_cmd_handle:lines() do
	        if string.find(space, "^Filesystem") == nil then
	            local s = str.split_space(space)
	            local df_space_mnt = s[6]
	            df_cmd_array[df_space_mnt] = {}

	            for counter = 1, 5 do
	                df_cmd_array[df_space_mnt][cat .. "." .. prefix .. "." .. df_metrics[counter]] = s[counter]
	            end
	        end
	    end
    else
        error("ERROR: EOF error on the command [df_space_cmd_handle]", 2)
    end

    df_space_cmd_handle:close()

    -- inode usage
    prefix = "inode"
    local df_inode_cmd_handle = io.popen("/bin/df -P -i", "r")

    if df_inode_cmd_handle:read(0) ~= nil then
	    for inode in df_inode_cmd_handle:lines() do
	        if string.find(inode, "^Filesystem") == nil then
	            local s = str.split_space(inode)
	            local df_inode_mnt = s[6]

	            for counter = 1, 5 do
	                df_cmd_array[df_inode_mnt][cat .. "." .. prefix .. "." .. df_metrics[counter]] = s[counter]
	            end
	        end
	    end
    else
        error("ERROR: EOF error on the command [df_inode_cmd_handle]", 2)
    end

    df_inode_cmd_handle:close()

    -- debug
    --[[
    for k, v in pairs(df_cmd_array) do
        for m, n in pairs(v) do
            print(k, m, n)
        end
    end
    --]]

    return df_cmd_array
end

M.df_usage = df_usage

return M
