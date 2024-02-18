<?php
define("FILE_FORMATS", array("txt", "html", "csv"));
define("LOG_FILE_NAME", "process-log");

function extractProcessValue($data, $startIdx, $len = null) {
    $cellInfo = trim(substr($data, $startIdx, $len));
    return preg_replace('/\s+/', '', $cellInfo);
}

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
        case 'txt':
            $log = implode("\n", $processes);
            break;
        case 'html':
            $log = "<table border='1' style='border-collapse: collapse;'><tr><th>Image Name</th><th>PID</th><th>Session Name</th><th>Session#</th><th>Mem Usage</th><th>Status</th><th>User Name</th><th>CPU Time</th><th>Window Title</th></tr>";
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
    file_put_contents(LOG_FILE_NAME . ".$format", $log);
}

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

// Get processes
$processes = getProcesses($username);

writeLog($processes, $fileFormat);

echo "Press Enter to continue...";
system("pause >nul");

unlink(LOG_FILE_NAME . ".$fileFormat");
?>