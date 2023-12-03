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
        }

        html {
            height: 100%;
        }
    </style>
</head>

<body >

<?php include("menu.php"); ?>

<header>
<h3><span id="headerSubTitle">home</span></h3>
</header>


<table>
<tr>
<td>
<pre>
This website is connected to a homebrew 16Bit CPU/Minicomputer built from scratch using 74-Series logic gates.
It is constructed using plain 74HC logic gates on wire-wrap boards and has around 270 chips in total.

Right now it is operating at 2.75MHz and runs a simple homebrew operating system. This is a work in progress and although the
hardware foundations are solid (although not completely finished), the software front is still small.
I wrote a BIOS which contains basic IO functions and operates inside 64KB of ROM/RAM.
It also has a simple bootloader, responsible for loading-up the kernel of the operating
system. The kernel also runs inside a 64KB space and is the CPU supervisor with full control. Up to 255 user processes
can run in parallel along with the kernel process. Each process is isolated to their own 64KB space.

The system is connected to the internet via a Telnet server. You can access the live system from the 'sol-1 terminal' menu.
There you will be directly connected to Sol-1 via its serial port and you can start using the shell. I leave the system
online as much as I can, but sometimes it will be off.

Schematics and source code are available on the 'files' page.

(Note: This page is very much under construction.)
</pre>
</td>
</tr>
</table>






</body>
</html>

