#!/usr/bin/env lua

-- load modules
local json = require "json"
local system = require "system"
local filesystem = require "filesystem"
local network = require "network"
local apache2 = require "apache2"

-- initialize the table
local sysstatus = {}

-- tags
sysstatus["time"] = os.time()

-- system metrics
sysstatus["system"] = {}
sysstatus["system"]["loadavg"] = system.sys_loadavg()
sysstatus["system"]["uptime"] = system.sys_uptime()
sysstatus["system"]["file-nr"] = system.sys_filenr()
sysstatus["system"]["procs"] = system.sys_proc()
sysstatus["system"]["memory"] = system.sys_mem()
sysstatus["system"]["cpu"] = system.sys_cpu()
sysstatus["system"]["diskperf"] = system.sys_diskperf()

-- filesystem metrics
sysstatus["filesystem"] = {}
sysstatus["filesystem"]["usage"] = filesystem.df_usage()

-- network metrics
sysstatus["network"] = {}
sysstatus["network"]["netstat"] = network.net_netstat()
sysstatus["network"]["netsnmp"] = network.net_netsnmp()
sysstatus["network"]["netdev"] = network.net_netdev()

function handle(r)
    r.content_type = "application/json"

    sysstatus["hostname"] = r.server_name
    local sysstatus_json = json.encode(sysstatus)

    if r.method == "GET" then
        r:puts(sysstatus_json)
        r.status = 200
    else
        r:puts("ERROR: HTTP method " .. r.method .. " is not supported.\n")
        r.status = 405
    end

    return apache2.OK
end

-- print(json.encode(sysstatus))
