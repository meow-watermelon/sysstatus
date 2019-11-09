# SysStatus
SysStatus is a package to provide running host system real-time metrics via HTTP service in JSON format.

### PHP Version
---
#### Install
1. Configure a web server with PHP support. TLS is recommended.
2. Copy all files under `php/` to a proper location that the web server can read.
3. Access the endpoint via <https://hostname/path/sysstatus.php>.

#### Configuration
There's no special configuration needs to be done. However, the package needs to access some data from commands or files under `/proc` so please make sure the SELinux enforcement setting is **disabled** or **permissive**.

### Lua Version
---
#### Install
1. SysStatus Lua version is written for Apache HTTPD web server use. A running HTTPD web server running with Lua support is required. TLS is recommended.
2. Copy all files from `lua/sysstatus.lua` and `lua/libs` to a proper location that the web server can read.
3. Copy `httpd_configs/00-lua.conf` to HTTPD `conf.modules.d` directory and copy `http_configs/lua.conf` to HTTPD `conf.d` directory. Restart HTTPD web server.
4. Access the endpoint via <https://hostname/path/sysstatus.php>.

#### Configuration
The package needs to access some data from commands or files under `/proc` so please make sure the SELinux enforcement setting is **disabled** or **permissive**. Also, this Lua version can ONLY run with Lua support on Apache HTTPD server.

#### Output
The output is in JSON format.

#### Notes
1. Only **GET** method is supported.
