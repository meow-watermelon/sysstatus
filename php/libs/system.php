<?php
// SYSTEM FUNCTIONS
// Rev. Date: 10-22-2018
// Function List:
// sys_loadavg(): 1m/5m/15m load avg.
// sys_filenr(): FDs usage
// sys_proc(): process state
// sys_mem(): memory usage
// sys_cpu(): processors usage
// sys_diskperf(): disk performance metrics

function sys_loadavg() {
    $cat = 'system';
    $prefix = 'loadavg';
    $loadavg_file = '/proc/loadavg';
    $loadavg_content = file($loadavg_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    $loadavg = preg_split("/\s+/", $loadavg_content[0]);
    $loadavg_o = array(
        "$cat.$prefix.1min" => $loadavg[0],
        "$cat.$prefix.5min" => $loadavg[1],
        "$cat.$prefix.15min" => $loadavg[2],
    );

    return $loadavg_o;
}

function sys_filenr() {
    $cat = 'system';
    $prefix = 'files';
    $filenr_file = '/proc/sys/fs/file-nr';
    $filenr_content = file($filenr_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    $filenr = preg_split("/\s+/", $filenr_content[0]);
    $filenr_o = array(
        "$cat.$prefix.open" => $filenr[0],
        "$cat.$prefix.max" => $filenr[2],
    );

    return $filenr_o;
}

function sys_proc() {
    $cat = 'system';
    $prefix = 'process';
    $ps_cmd = escapeshellcmd('/bin/ps -eo stat --no-headers');
    $ps_cmd_handle = popen($ps_cmd, 'r');
    $ps_cmd_array = array();
    
    if ($ps_cmd_handle) {
        while (($buffer = fgets($ps_cmd_handle)) !== FALSE) {
            $proc_stat = substr(trim($buffer), 0, 1);
            if (!array_key_exists("$cat.$prefix.$proc_stat", $ps_cmd_array)) {
                $ps_cmd_array["$cat.$prefix.$proc_stat"] = 1;
            } else {
                $ps_cmd_array["$cat.$prefix.$proc_stat"]++;
            }
        }
    
        if (!feof($ps_cmd_handle)) {
            print("ERROR: EOF error on the command: {$ps_cmd}\n");
            exit(2);
        }
    
        pclose($ps_cmd_handle);
    }

    return $ps_cmd_array;
}

function sys_mem() {
    $cat = 'system';
    $prefix = 'mem';
    $meminfo_file = '/proc/meminfo';
    $meminfo_content = file($meminfo_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    $meminfo_metrics = array(
        'MemTotal' => 'mem_total',
        'MemFree' => 'mem_free',
        'Buffers' => 'buffers',
        'Cached' => 'cached',
        'SwapCached' => 'swap_cached',
        'SwapTotal' => 'swap_total',
        'SwapFree' => 'swap_free',
        'Dirty' => 'dirty',
        'Slab' => 'slab',
    );
    $meminfo_o = array();
    
    foreach ($meminfo_content as $m) {
        $value = array();
        foreach ($meminfo_metrics as $metric => $name) {
            if (preg_match("/^$metric:\s+(\d+) .*/", $m, $value)) {
                $meminfo_o["$cat.$prefix.$name"] = $value[1];
                break;
            }
        }
    }

    return $meminfo_o;
}

function sys_cpu() {
    $cat = 'system';
    $prefix = 'cpu';
    $cpu_file = '/proc/stat';
    $cpu_content = file($cpu_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    $cpu_o = array();
    $cpu_metrics = array('user', 'nice', 'sys', 'idle', 'iowait');
    
    foreach ($cpu_content as $buffer) {
        if (preg_match("/^cpu/", $buffer)) {
            $c = preg_split("/\s+/", $buffer);
            $cpu_name = $c[0];
    
            $counter = 0;
            for ($i = 1; $i < 6; $i++) {
                $cpu_o[$cpu_name]["$cat.$prefix.$cpu_metrics[$counter]"] = $c[$i];
                $counter++;
            }
        }
    }

    return $cpu_o;
}

function sys_diskperf() {
    $cat = 'system';
    $prefix = 'disk';
    $disk_file = '/proc/diskstats';
    $disk_content = file($disk_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    $disk_o = array();
    
    $disk_metrics = array('read_complete', 'read_merge', 'read_sector', 'read_time_spend', 'write_complete', 'write_merge', 'write_sector', 'write_time_spend', 'io_queue', 'io_time_spend');
    
    foreach ($disk_content as $buffer) {
        $d = preg_split("/\s+/", $buffer);
        $dev_name = $d[3];
    
        $counter = 0;
        for ($i = 4; $i < count($d) - 1; $i++) {
            $disk_o[$dev_name]["$cat.$prefix.$disk_metrics[$counter]"] = $d[$i];
            $counter++;
        }
    }

    return $disk_o;
}
?>
