<?php
// Define constants
define("FILE_FORMATS", array("txt", "html", "csv"));
define("LOG_FILE_NAME", "process-log");

// Extract needed property based on provided index and length and remove whitespace
function extractProcessValue($data, $startIdx, $len = null) {
    return $cellInfo = trim(substr($data, $startIdx, $len));
}

// get running processes based on username or just get all
function getProcesses($username) {
    if ($username && $username!=="") {
        exec("tasklist /v /FI \"USERNAME eq $username\"", $output);
    } else {
        exec("tasklist /v", $output);
    }
    return $output;
}

function writeLog($processes, $format = 'txt') {
    switch ($format) {
        // in case txt just output raw processes array
        case 'txt':
            $log = implode("\n", $processes);
            break;
        // in case html create table and fill table cells with properties extracted
        case 'html':
            $log = "<table border='1' style='border-collapse: collapse;'><tr><th>Image Name</th><th>PID</th><th>Session Name</th><th>Session#</th><th>Mem Usage</th><th>Status</th><th>User Name</th><th>CPU Time</th><th>Window Title</th></tr>";
            
            // iterator starts at 3 in order to skip headers, delimiter
            for ($i = 3; $i < count($processes); $i++) {
                $properties = array(
                    'ImageName' => extractProcessValue($processes[$i], 0, 26),
                    'PID' => extractProcessValue($processes[$i], 26, 9),
                    'SessionName' => extractProcessValue($processes[$i], 35, 17),
                    'SessionNumber' => extractProcessValue($processes[$i], 52, 12),
                    'MemUsage' => extractProcessValue($processes[$i], 64, 13),
                    'Status' => extractProcessValue($processes[$i], 77, 16),
                    'UserName' => extractProcessValue($processes[$i], 93, 51),
                    'CPUTime' => extractProcessValue($processes[$i], 144, 13),
                    'WindowTitle' => extractProcessValue($processes[$i], 157)
                );

                $log .= "<tr>";

                foreach ($properties as $property) {
                    $log .= "<td style='text-align:left';>$property</td>";
                }

                $log .= "</tr>";
            }
            $log .= "</table>";
            break;
        case 'csv':
            $log = "Image Name,PID,Session Name,Session#,Mem Usage,Status,User Name,CPU Time,Window Title\n";

            // iterator starts at 3 in order to skip headers, delimiter
            for ($i = 3; $i < count($processes); $i++) {
                $properties = array(
                    'ImageName' => extractProcessValue($processes[$i], 0, 26),
                    'PID' => extractProcessValue($processes[$i], 26, 9),
                    'SessionName' => extractProcessValue($processes[$i], 35, 17),
                    'SessionNumber' => extractProcessValue($processes[$i], 52, 12),
                    'MemUsage' => extractProcessValue($processes[$i], 64, 13),
                    'Status' => extractProcessValue($processes[$i], 77, 16),
                    'UserName' => extractProcessValue($processes[$i], 93, 51),
                    'CPUTime' => extractProcessValue($processes[$i], 144, 13),
                    'WindowTitle' => extractProcessValue($processes[$i], 157)
                );
                $log .= implode(',', $properties) . "\n";
            }
            break;
    }

    // write string to a file
    file_put_contents(LOG_FILE_NAME . ".$format", $log);
}

// set output file format to use according to provided parameter 
if (isset($argv[1])) {
    if (in_array($argv[1], FILE_FORMATS)) {
        $fileFormat = $argv[1];
    } elseif (empty($argv[1])) {
        $fileFormat = FILE_FORMATS[0];
    } else {
        echo "Provided file format not supported. Supported types: txt, html, csv";
        exit(1);
    }
} else {
    $fileFormat = FILE_FORMATS[0];
}

$username = isset($argv[2]) ? $argv[2] : null;

$processes = getProcesses($username);

writeLog($processes, $fileFormat);

// Pause script
echo "Press Enter to continue...";
system("pause >nul");

// Delete process-log file
unlink(LOG_FILE_NAME . ".$fileFormat");
?>