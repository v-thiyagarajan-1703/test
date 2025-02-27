<?php
echo "cron testing";

// Define the file path
$filePath = '/var/www/html/cron_output.txt';

// Define the content to append
$content = "This is a new entry from cron job at " . date('Y-m-d H:i:s') . "\n";

// Check if the file exists, create it if not
if (!file_exists($filePath)) {
    touch($filePath);
}

// Open the file in append mode ('a')
$file = fopen($filePath, 'a');

// Check if file is opened successfully
if ($file) {
    // Write the content to the file
    fwrite($file, $content);

    // Close the file
    fclose($file);
}

?>

