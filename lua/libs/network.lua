#!/usr/bin/env lua
-- NETWORK FUNCTIONS
-- Rev. Date: 11-07-2019
-- Function List:
-- net_netstat(): netstat metrics
-- net_netsnmp(): SNMP metrics for network layer
-- net_netdev(): network interfaces traffic metrics

local str = require "str"

local M = {}

local cat = "network"

local function net_netstat()
    local netstat_o = {}

    local metrics_table = {}
    local netstat_file = "/proc/net/netstat"
    local netstat_file_handle = io.open(netstat_file, "r")
    for item in netstat_file_handle:lines() do
        if string.match(item, "%a+:%s+%a+.*") then
            local prefix, s = string.match(item, "(%a+):%s+(%a+.*)")
            prefix = string.lower(prefix)
            metrics_table = str.split_space(s)
            for _, metric in ipairs(metrics_table) do
                netstat_o[cat .. "." .. prefix .. "." .. metric] = 0
            end
        end

        if string.match(item, "%a+:%s+%d+.*") then
            local prefix, s = string.match(item, "(%a+):%s+(%d+.*)")
            prefix = string.lower(prefix)
            local values_table = str.split_space(s)
            for counter = 1, #values_table do
                netstat_o[cat .. "." .. prefix .. "." .. metrics_table[counter]] = values_table[counter]
            end
        end
    end

    netstat_file_handle:close()

    --debug
    --[[
    for k, v in pairs(netstat_o) do
        print(k, v)
    end
    --]]

    return netstat_o
end

local function net_netsnmp()
    local netsnmp_o = {}

    local metrics_table = {}
    local netsnmp_file = "/proc/net/snmp"
    local netsnmp_file_handle = io.open(netsnmp_file, "r")
    for item in netsnmp_file_handle:lines() do
        if string.match(item, "%a+:%s+%a+.*") then
            local prefix, s = string.match(item, "(%a+):%s+(%a+.*)")
            prefix = string.lower(prefix)
            metrics_table = str.split_space(s)
            for _, metric in ipairs(metrics_table) do
                netsnmp_o[cat .. "." .. prefix .. "." .. metric] = 0
            end
        end

        if string.match(item, "%a+:%s+%d+.*") then
            local prefix, s = string.match(item, "(%a+):%s+(%d+.*)")
            prefix = string.lower(prefix)
            local values_table = str.split_space(s)
            for counter = 1, #values_table do
                netsnmp_o[cat .. "." .. prefix .. "." .. metrics_table[counter]] = values_table[counter]
            end
        end
    end

    netsnmp_file_handle:close()

    --debug
    --[[
    for k, v in pairs(netsnmp_o) do
        print(k, v)
    end
    --]]

    return netsnmp_o
end

local function net_netdev()
    local netdev_o = {}

    local prefix = "dev"
    local dev_metrics = {"rx_bytes",
        "rx_packets",
        "rx_errs",
        "rx_drop",
        "rx_fifo",
        "rx_frame",
        "rx_compressed",
        "rx_multicast",
        "tx_bytes",
        "tx_packets",
        "tx_errs",
        "tx_drop",
        "tx_fifo",
        "tx_frame",
        "tx_compressed",
        "tx_multicast"}
    local netdev_file = "/proc/net/dev"
    local netdev_file_handle = io.open(netdev_file, "r")
    for item in netdev_file_handle:lines() do
        if string.match(item, "%s*%S+:.*") then
            local dev, values = string.match(item, "%s*(%S+):(.*)")
            netdev_o[dev] = {}
            local values_table = str.split_space(values)
            for counter = 1, #dev_metrics do
                netdev_o[dev][cat .. "." .. prefix .. "." .. dev_metrics[counter]] = values_table[counter]
            end
        end
    end

    netdev_file_handle:close()

    -- debug
    --[[
    for k, v in pairs(netdev_o) do
        for m, n in pairs(v) do
            print(k, m, n)
        end
    end
    --]]

    return netdev_o
end

M.net_netstat = net_netstat
M.net_netsnmp = net_netsnmp
M.net_netdev = net_netdev

return M
