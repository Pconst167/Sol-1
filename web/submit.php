<?php
$host = '192.168.1.90'; // Replace with your server's IP
$port = 51515;       // Replace with your server's port

// Create a TCP/IP socket
$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
if ($socket === false) {
    echo "socket_create() failed: reason: " . socket_strerror(socket_last_error()) . "\n";
    exit;
}

// Connect to the server
$result = socket_connect($socket, $host, $port);
if ($result === false) {
    echo "socket_connect() failed.\nReason: " . socket_strerror(socket_last_error($socket)) . "\n";
    socket_close($socket);
    exit;
}

// Send data to the server
$text = $_POST['text'];
$text = $text . "\n";
socket_write($socket, $text, strlen($text));

// Wait for the server response
$response = '';
$timeout = 2; // 5 seconds timeout
$endTime = time() + $timeout;

while (time() < $endTime) {
    $read = [ $socket ];
    $write = NULL;
    $except = NULL;
    $tv_sec = $endTime - time();

    // Check if data is available to read
    $num_changed_sockets = socket_select($read, $write, $except, $tv_sec);

    if ($num_changed_sockets === false) {
        echo "socket_select() failed, reason: " . socket_strerror(socket_last_error()) . "\n";
        break;
    } elseif ($num_changed_sockets > 0) {
        // Read available data
        $part = socket_read($socket, 1024);
        if ($part === false) {
            echo "socket_read() failed, reason: " . socket_strerror(socket_last_error($socket)) . "\n";
            break;
        } elseif ($part === '') {
            // No more data, end the loop
            break;
        }
        $response .= $part;
    }
}

// Close the socket
socket_close($socket);

// Output the response
echo "Response from server: " . nl2br($response) . "\n";
?>

