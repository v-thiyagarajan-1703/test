<?php
// Define the file path
$filePath = '/var/www/html/cron_output.txt';

// Define the content to append
$content = "This is a new entry from cron job at " . date('Y-m-d H:i:s') . "\n";

try {
    // Check if the file exists, create it if not
    if (!file_exists($filePath)) {
        if (!touch($filePath)) {
            throw new Exception("Failed to create file: $filePath");
        }
        chmod($filePath, 0666); // Ensure proper file permissions
    }

    // Check if the file is writable
    if (!is_writable($filePath)) {
        throw new Exception("File is not writable: $filePath");
    }

    // Write content to file
    if (file_put_contents($filePath, $content, FILE_APPEND | LOCK_EX) === false) {
        throw new Exception("Failed to write to file: $filePath");
    }

    echo "Data written to the file successfully.\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>

