<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">
<link rel="icon" href="http://sol-1.org/images/2.jpg">	
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>

</head>

<body >

<?php include("menu.php"); ?>

</br>

<table width="80%">
<tr><td   align="justify" valign="top">

<h3>Register Table</h3>
<h4>General Purpose Registers</h4>
<pre style="font-size:14px;">
| 16bit | 8bit  | Description 
| ----- | ----- | -----------
| A     | AH/AL | Accumulator 
| B     | BH/BL | Base Register (Secondary Counter Register) 
| C     | CH/CL | Counter Register (Primary Counter) 
| D     | DH/DL | Data Register / Data Pointer 
| G     | GH/GL | General Register (For scratch) 
</pre>
<h4>Special Purpose Registers</h4>
<pre style="font-size:14px;">
| 16bit  |   8bit    | Description 
| ------ | --------- | ----------- 
| PC     |           | Program Counter 
| SP     |           | Stack Pointer 
| SSP    |           | Supervisor Stack Pointer 
| BP     |           | Base Pointer (Used to manage stack frames) 
| SI     |           | Source Index (Source address for string operations) 
| DI     |           | Destination Index (Destination address for string operations) 
| PTB    |           | Page Table Base 
| Status |           | CPU Status 
| Flags  |           | Arithmetic and Logic flags register 
</pre>
<br>
</td>
</tr>

</table>



<?php include("footer.php"); ?>
</body>
</html>

