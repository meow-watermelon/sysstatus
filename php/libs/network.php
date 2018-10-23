<?php
// NETWORK FUNCTIONS
// Rev. Date: 10-22-2018
// Function List:
// net_netstat(): netstat metrics
// net_netsnmp(): SNMP metrics for network layer
// net_netdev(): network interfaces traffic metrics

function net_netstat() {
    $cat = 'network';
    $netstat_file = '/proc/net/netstat';
    $netstat_file_content = file($netstat_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    $netstat_o = array();

    foreach ($netstat_file_content as $buffer) {
        if (preg_match("/(\w+):\s+([A-Za-z]+.*)/", $buffer, $match)) {
            $prefix = strtolower($match[1]);
            $s = preg_split("/\s+/", $match[2]);
            foreach ($s as $metric) {
                $netstat_o["$cat.$prefix.$metric"] = 0;
            }
        }
        if (preg_match("/(\w+):\s+([0-9]+.*)/", $buffer, $match)) {
            $prefix = strtolower($match[1]);
            $s = preg_split("/\s+/", $match[2]);
            $counter = 0;
            foreach ($netstat_o as $k => $v) {
                if (preg_match("/$cat\.$prefix\..*/", $k)) {
                    $netstat_o[$k] = $s[$counter];
                    $counter++;
                }
            }
        }
    }

    return $netstat_o;
}

function net_netsnmp() {
    $cat = 'network';
    $netsnmp_file = '/proc/net/snmp';
    $netsnmp_file_content = file($netsnmp_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    $netsnmp_o = array();

    foreach ($netsnmp_file_content as $buffer) {
        if (preg_match("/(\w+):\s+([A-Za-z]+.*)/", $buffer, $match)) {
            $prefix = strtolower($match[1]);
            $s = preg_split("/\s+/", $match[2]);
            foreach ($s as $metric) {
                $netsnmp_o["$cat.$prefix.$metric"] = 0;
            }
        }
        if (preg_match("/(\w+):\s+([0-9]+.*)/", $buffer, $match)) {
            $prefix = strtolower($match[1]);
            $s = preg_split("/\s+/", $match[2]);
            $counter = 0;
            foreach ($netsnmp_o as $k => $v) {
                if (preg_match("/$cat\.$prefix\..*/", $k)) {
                    $netsnmp_o[$k] = $s[$counter];
                    $counter++;
                }
            }
        }
    }

    return $netsnmp_o;
}

function net_netdev() {
    $cat = 'network';
    $prefix = 'dev';
    $netdev_file = '/proc/net/dev';
    $netdev_file_content = file($netdev_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    $dev_metrics = array('rx_bytes', 'rx_packets', 'rx_errs', 'rx_drop', 'rx_fifo', 'rx_frame', 'rx_compressed', 'rx_multicast', 'tx_bytes', 'tx_packets', 'tx_errs', 'tx_drop', 'tx_fifo', 'tx_frame', 'tx_compressed', 'tx_multicast');
    $netdev_o = array();

    foreach ($netdev_file_content as $buffer) {
        if (preg_match("/(.*):\s+(.*)/", $buffer, $match)) {
            $dev_name = trim($match[1]);
            $s = preg_split("/\s+/", $match[2]);
            $counter = 0;
            foreach ($s as $value) {
                $netdev_o[$dev_name]["$cat.$prefix.$dev_metrics[$counter]"] = $value;
                $counter++;
            }
        }
    }

    return $netdev_o;
}
?>
