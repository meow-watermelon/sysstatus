# SysStatus
SysStatus is a package to provide running host system real-time metrics via HTTP service in JSON format.

### PHP Version
---
#### Install
1. Configure a web server with PHP support.
2. Copy all files under `php/` to a proper location that the web server can read.

#### Configuration
There's no special configuration needs to be done. However, the package needs to access some data from commands or files under `/proc` so please make sure the SELinux enforcement setting is **disabled** or **permissive**.

#### Output
The output is in JSON format. Followings are details.

TODO

#### Notes
1. Only **GET** method is supported.
