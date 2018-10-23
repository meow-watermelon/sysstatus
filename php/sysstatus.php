<?php
// exit if running under command line
if (php_sapi_name() === 'cli') {
    echo("ERROR: Cannot run under command line.".PHP_EOL);
    exit(1);
}

// load libs
require 'libs/system.php';
require 'libs/filesystem.php';
require 'libs/network.php';

$sysstatus = array();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // tags
    $sysstatus['hostname'] = gethostname();
    $sysstatus['time'] = time();
 
    // system metrics
    $sysstatus['system']['loadavg'] = sys_loadavg();
    $sysstatus['system']['file-nr'] = sys_filenr();
    $sysstatus['system']['procs'] = sys_proc();
    $sysstatus['system']['memory'] = sys_mem();
    $sysstatus['system']['cpu'] = sys_cpu();
    $sysstatus['system']['diskperf'] = sys_diskperf();

    // filesystem metrics
    $sysstatus['filesystem']['usage'] = df_usage();
    
    // network metrics
    $sysstatus['network']['netstat'] = net_netstat();
    $sysstatus['network']['netsnmp'] = net_netsnmp();
    $sysstatus['network']['netdev'] = net_netdev();
    
    // encode json
    $sysstatus_json = json_encode($sysstatus);
    
    echo $sysstatus_json;
} else {
    echo "ERROR: HTTP method ".$_SERVER['REQUEST_METHOD']." is not supported.".PHP_EOL;
    http_response_code(400);
}

// debug use
// var_dump($sysstatus);
// var_dump($sysstatus_json);
?>
