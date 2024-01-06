
<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">
<link rel="icon" href="http://sol-1.org/images/2.jpg">	

<style>
        body {
            margin: 0;
            padding: 0;
            background-image: url('images/bg/retro-sci-fi-background-futuristic-grid-landscape-of-the-80s-digital-cyber-surface-suitable-for-design-in-the-style-of-the-1980s-free-video.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh; /* Viewport height */
	    background-color: black;
	   color:white;
        }

        html {
            height: 100%;
        }

    table a,
table a:visited,
table a:active {
    color: #00FF00 !important;
}
table a:hover{
  color:white !important;
}

    </style>
</head>

<?php
$response = '';
$text = "ps\n";

$host = 'sol-1.org'; 
$port = 51515;     

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
$text = $text ;
socket_write($socket, $text, strlen($text));

// Wait for the server response
$response = '';
$timeout = 6; // 4 seconds timeout
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


?>
<body>


<?php
	include("menu.php");
?>


</br>

<table>
<tr><td>
<pre>
This is a snapshot of Sol-1 at this moment.

<?php printf($response)  ?>
</pre>
</td></tr>
</table>
</br><br>
<?php include("footer.php"); ?>
</body>
</html>

