
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

<body>


<?php
	include("menu.php");
?>


</br>

<table>
<tr><td>
<pre>
Very sketchy for now. This will be updated in time.

 info for : IDE SERVICES INTERRUPT
 IDE read/write 512-byte sector
 al = option
 user buffer pointer in D
 AH = number of sectors
 CB = LBA bytes 3..0  
------------------------------------------------------------------------------------------------------;
 FILE SYSTEM DATA STRUCTURE
------------------------------------------------------------------------------------------------------;
 for a directory we have the header first, followed by metadata
 header 1 sector (512 bytes)
 metadata 1 sector (512 bytes)
 HEADER ENTRIES:
 filename (64)
 parent dir LBA (2) -  to be used for faster backwards navigation...

 metadata entries:
 filename (24)
 attributes (1)  |_|_|file_type(3bits)|x|w|r| types: file, directory, character device
 LBA (2)
 size (2)
 day (1)
 month (1)
 year (1)
 packet size = 32 bytes

 first directory on disk is the root directory '/'


 FILE ENTRY ATTRIBUTES
 filename (24)
 attributes (1)       :|0|0|file_type(3bits)|x|w|r|
 LBA (2)              : location of raw data for file entry, or dirID for directory entry
 size (2)             : filesize
 day (1)           
 month (1)
 year (1)
 packet size = 32 bytes  : total packet size in bytes
</pre>
</td></tr>
</table>
</br><br>
<?php include("footer.php"); ?>
</body>
</html>

