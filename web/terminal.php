<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">
<link rel="icon" href="http://sol-1.org/images/2.jpg">	

</head>


<?php
$response = '';
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $text = $_POST['text'];
    if($text == "_ctrlc"){
      $text = chr(0x03)  ;
    }
    else{
      $text = $text . "\n";
    }

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
$text = $text ;
socket_write($socket, $text, strlen($text));

// Wait for the server response
$response = '';
$timeout = 5; // 5 seconds timeout
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

}

// If you want to display the previous responses as well, 
// you might want to store them in a session or a temporary file.
?>

<body>

<?php include("menu.php"); ?>

</br>

<table width="80%" >
<tr>
<td colspan="2" style="text-align:justify;">
Sol-1's environment is freely accessible online. All you have to do is Telnet to it. 
When you do, you will be presented with a live shell environment, directly conencted to Sol-1 via a serial port.
</br>
It is running a Unix-like homebrew operating system that I am writing from scratch, so for now it is all
very simple, and only a few Unix commands are available. 
</br>
The address is sol-1.org at port 51515. You can telnet via putty(recommended), or via your terminal's telnet software.
</br>
You can also connect directly using the Telnet client below.
</br>
</br>

<div id="fTelnetContainer" class="fTelnetContainer"></div>
<script>document.write('<script src="//embed-v2.ftelnet.ca/js/ftelnet-loader.norip.noxfer.js?v=' + (new Date()).getTime() + '"><\/script>');</script>
<script>
    var Options = new fTelnetOptions();
    Options.BareLFtoCRLF = true;
    Options.BitsPerSecond = 9600;
    Options.ConnectionType = 'telnet';
    Options.Emulation = 'ansi-bbs';
    Options.Enter = '\n';
    Options.Font = 'CP437';
    Options.ForceWss = false;
    Options.Hostname = 'sol-1.org';
    Options.LocalEcho = false;
    Options.NegotiateLocalEcho = false;
    Options.Port = 51515;
    Options.ProxyHostname = 'p-eu.ftelnet.ca';
    Options.ProxyPort = 80;
    Options.ProxyPortSecure = 443;
    Options.ScreenColumns = 120;
    Options.ScreenRows = 30;
    Options.SendLocation = false;
    var fTelnet = new fTelnetClient('fTelnetContainer', Options);
</script>
</td>
</tr>
</table>


The terminal is disabled for maintenance.

</br>
</br>

<?php include("footer.php"); ?>
</body>
</html>




