#!/usr/bin/env lua
-- SYSTEM FUNCTIONS
-- Rev. Date: XX-XX-XXXX
-- Function List:
-- sys_loadavg(): 1m/5m/15m load avg.
-- sys_uptime(): uptime
-- sys_filenr(): FDs usage
-- sys_proc(): process state
-- sys_mem(): memory usage
-- sys_cpu(): processors usage
-- sys_diskperf(): disk performance metrics

local str = require "str"
local M = {}

local cat = "system"

local function sys_loadavg()
    local loadavg_o = {}

    local prefix = "loadavg"
    local loadavg_file = "/proc/loadavg"
    local loadavg_file_handle = io.open(loadavg_file, "r")
    for item in loadavg_file_handle:lines() do
        local loadavg = str.split_space(item)

        loadavg_o[cat .. "." .. prefix .. ".1min"] = loadavg[1]
        loadavg_o[cat .. "." .. prefix .. ".5min"] = loadavg[2]
        loadavg_o[cat .. "." .. prefix .. ".15min"] = loadavg[3]
    end

    loadavg_file_handle:close()

    --debug
    --[[
    for _, v in pairs(loadavg_o) do
        print(v)
    end
    --]]

    return loadavg_o
end

local function sys_uptime()
    local uptime_o = {}

    local prefix = "uptime"
    local uptime_file = "/proc/uptime"
    local uptime_file_handle = io.open(uptime_file, "r")
    for item in uptime_file_handle:lines() do
        local uptime = str.split_space(item)

        uptime_o[cat .. "." .. prefix .. "up_time"] = uptime[1]
        uptime_o[cat .. "." .. prefix .. "idle_time"] = uptime[2]
    end

    uptime_file_handle:close()

    --debug
    --[[
    for _, v in pairs(uptime_o) do
        print(v)
    end
    --]]

    return uptime_o
end

local function sys_filenr()
    local filenr_o = {}

    local prefix = "filenr"
    local filenr_file = "/proc/sys/fs/file-nr"
    local filenr_file_handle = io.open(filenr_file, "r")
    for item in filenr_file_handle:lines() do
        local filenr = str.split_space(item)

        filenr_o[cat .. "." .. prefix .. "open"] = filenr[1]
        filenr_o[cat .. "." .. prefix .. "max"] = filenr[3]
    end

    filenr_file_handle:close()

    --debug
    --[[
    for _, v in pairs(filenr_o) do
        print(v)
    end
    --]]

    return filenr_o
end

local function sys_proc()
    local proc_o = {}

    local prefix = "process"
    local proc_pid_max_file = '/proc/sys/kernel/pid_max'
    local proc_pid_max_file_handle = io.open(proc_pid_max_file, "r")
    for item in proc_pid_max_file_handle:lines() do
        local proc_pid_max_content = str.split_space(item)
        local proc_pid_max = proc_pid_max_content[1]

        proc_o[cat .. "." .. prefix .. "." .. "pid_max"] = proc_pid_max
    end

    proc_pid_max_file_handle:close()

    local ps_cmd_handle = io.popen("/bin/ps -eo stat --no-headers", "r")
    if ps_cmd_handle:read(0) ~= nil then
        for item in ps_cmd_handle:lines() do
            local proc_stat = string.sub(item, 1, 1)

            if proc_o[cat .. "." .. prefix .. "." .. proc_stat] == nil then
                proc_o[cat .. "." .. prefix .. "." .. proc_stat] = 1
            else
                proc_o[cat .. "." .. prefix .. "." .. proc_stat] = proc_o[cat .. "." .. prefix .. "." .. proc_stat] + 1
            end
        end
    else
        error("ERROR: EOF error on the command [ps_cmd_handle]", 2)
    end

    ps_cmd_handle:close()

    --debug
    --[[
    for k, v in pairs(proc_o) do
        print(k, v)
    end
    --]]

    return proc_o
end

local function sys_mem()
    local meminfo_o = {}

    local prefix = "mem"
    local meminfo_metrics = {
        MemTotal = "mem_total",
        MemFree = "mem_free",
        Buffers = "buffers",
        Cached = "cached",
        SwapCached = "swap_cached",
        SwapTotal = "swap_total",
        SwapFree = "swap_free",
        Dirty = "dirty",
        Slab = "slab"
    }
    local meminfo_file = "/proc/meminfo"
    local meminfo_file_handle = io.open(meminfo_file, "r")
    for item in meminfo_file_handle:lines() do
        local meminfo_metric_table = str.split_space(item)
        for k, v in pairs(meminfo_metrics) do
            local pattern = "^"..k..":"
            if string.match(meminfo_metric_table[1], pattern) then
                meminfo_o[cat .. "." .. prefix .. "." .. v] = meminfo_metric_table[2]
                break
            end
        end
    end

    --debug
    --[[
    for k, v in pairs(meminfo_o) do
        print(k, v)
    end
    --]]


    return meminfo_o
end

local function sys_cpu()
end

local function sys_diskperf()
end

M.sys_loadavg = sys_loadavg
M.sys_uptime = sys_uptime
M.sys_filenr = sys_filenr
M.sys_proc = sys_proc
M.sys_mem = sys_mem
M.sys_cpu = sys_cpu
M.sys_diskperf = sys_diskperf

return M
