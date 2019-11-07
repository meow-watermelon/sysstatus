#!/usr/bin/env lua

require "libs.str"
require "libs.system"
require "libs.filesystem"
require "libs.network"

local sysstatus = {}

sysstatus["hostname"] = os.getenv("HOSTNAME")
sysstatus["time"] = os.time()
