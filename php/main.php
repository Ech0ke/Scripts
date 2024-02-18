<?php
$fileFormats = array("txt", "html", "csv");
$fileFormat;

function formatHtmlCell($data, $startIdx, $len = null) {
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
                    'ImageName' => formatHtmlCell($processes[$i], 0, 26),
                    'PID' => formatHtmlCell($processes[$i], 26, 9),
                    'SessionName' => formatHtmlCell($processes[$i], 35, 17),
                    'SessionNumber' => formatHtmlCell($processes[$i], 52, 12),
                    'MemUsage' => formatHtmlCell($processes[$i], 64, 13),
                    'Status' => formatHtmlCell($processes[$i], 77, 16),
                    'UserName' => formatHtmlCell($processes[$i], 93, 51),
                    'CPUTime' => formatHtmlCell($processes[$i], 144, 13),
                    'WindowTitle' => formatHtmlCell($processes[$i], 157)
                );
                $log .= "<tr>";
                foreach ($properties as $property) {
                    $log .= "<td style='text-align:left';>$property</td>";
                }
                $log .= "</tr>";
            }
            $log .= "</table>";
            break;
        // case 'csv':
        //     $log = "Image Name,PID,Session Name,Session#,Mem Usage\n";
        //     foreach ($processes as $process) {
        //         $info = preg_split('/\s+/', $process);
        //         $log .= implode(",", $info) . "\n";
        //     }
        //     break;
    }
    file_put_contents("processes-log.$format", $log);
}

if (isset($argv[1])) {
    if (in_array($argv[1], $fileFormats)) {
        $fileFormat = $argv[1];
    } elseif ($argv[1]==="") {
        $fileFormat = $fileFormats[0];
    } else {
        echo "Provided file format not supported. Supported types: txt, html, csv";
        exit(1);
    }
}

$username = isset($argv[2]) ? $argv[2] : null;

// Get processes
$processes = getProcesses($username);

writeLog($processes, $fileFormat);

echo "Press Enter to continue...";
system("pause >nul");

unlink("processes-log.$fileFormat");
?>