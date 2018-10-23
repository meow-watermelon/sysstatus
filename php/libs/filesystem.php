<?php
// FILESYSTEM FUNCTIONS
// Rev. Date: 10-22-2018
// Function List:
// df_usage(): mounted fs space/inode usage

function df_usage() {
    $cat = 'fs';
    $df_cmd_array = array();
    $df_metrics = array('fs', 'total', 'used', 'avail', 'used_pct');

    // space usage
    $prefix = 'space';
    $df_space_cmd = escapeshellcmd('/bin/df -P');
    $df_space_cmd_handle = popen($df_space_cmd, 'r');
    
    if ($df_space_cmd_handle) {
        while (($buffer = fgets($df_space_cmd_handle)) !== FALSE) {
            $space = trim($buffer);
            if (!preg_match("/^Filesystem/", $space)) {
                $s = preg_split("/\s+/", $buffer);
                $df_space_mnt = $s[5];
    
                $counter = 0;
                for ($i = 0; $i < 5; $i++) {
                    $df_cmd_array[$df_space_mnt]["$cat.$prefix.$df_metrics[$counter]"] = $s[$i];
                    $counter++;
                }
            }
        }
    
        if (!feof($df_space_cmd_handle)) {
            echo("ERROR: EOF error on the command: {$df_space_cmd}".PHP_EOL);
            exit(2);
        }
    
        pclose($df_space_cmd_handle);
    }
    
    // inode usage
    $prefix = 'inode';
    $df_inode_cmd = escapeshellcmd('/bin/df -P -i');
    $df_inode_cmd_handle = popen($df_inode_cmd, 'r');
    
    if ($df_inode_cmd_handle) {
        while (($buffer = fgets($df_inode_cmd_handle)) !== FALSE) {
            $inode = trim($buffer);
            if (!preg_match("/^Filesystem/", $inode)) {
                $s = preg_split("/\s+/", $inode);
                $df_inode_mnt = $s[5];
    
                $counter = 0;
                for ($i = 0; $i < 5; $i++) {
                    $df_cmd_array[$df_inode_mnt]["$cat.$prefix.$df_metrics[$counter]"] = $s[$i];
                    $counter++;
                }
            }
        }
    
        if (!feof($df_inode_cmd_handle)) {
            echo("ERROR: EOF error on the command: {$df_inode_cmd}".PHP_EOL);
            exit(2);
        }
    
        pclose($df_inode_cmd_handle);
    }

    return $df_cmd_array;
}
?>
