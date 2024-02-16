<?php
$fileFormats = array("txt", "html", "csv");
$fileFormat;

function getProcesses($username) {
    if ($username) {
        exec("tasklist /v /FI \"USERNAME eq $username\"", $output);
    } else {
        exec("tasklist /v", $output);
    }
    return $output;
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

foreach ($processes as $process) {
    echo $process;
}
?>