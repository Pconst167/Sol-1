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
Hello and Welcome. This is a website dedicated to a project of mine, Sol-1. Sol-1 is a homebrew CPU and Minicomputer built from 74HC logic.</br>
Thank you very much for taking the time to look at it. This is a hobby project and displayed for educational purposes and/or fun.</br>
I am slowly adding more information and sessions to this website, so not all pages in the links exist yet.</br>
</br>
<!--
<b>Sol-1 is connected to the internet and you can access it by telnetting to: sol-1.org 51515.</b></br>
If telnet is impractical at the moment, check out the 'terminal' page. There you will be able to communicate with the system live.</br>
I'm not a web developer so the interface is based on a php script and it takes a few seconds to receive a response from Sol-1.
</br>
</br>
--> 
The system is built on multibus wire-wrap cards. There is a unix-like operating system (still under development), an assembler, and a C compiler(still under development but mostly functional).<br>
I started writing a version of the classical Ed text editor. It's in /usr/bin2. At the moment it only has the append and print commands as well as 'w'.<br>
I plan to document this better and I'm sorry for the lack of documentation at the moment. However I believe that if you look at the git repository you will find everything you are looking for. In the meantime I am working to make this site better.<br>
</br>
<img src="images/sol/front-5.jpg" width="20%" >
<img src="images/sol/board-1.jpg" width="20%">

<h3>Features</h3>
<h4>Hardware</h4>
- User and Kernel privilege modes, with up to 256 processes running in parallel.</br>
- Paged virtual memory, such that each process can have a total of 64KB RAM for itself.</br>
- Two serial ports (16550), a real time clock(M48T02), 2 parallel ports(8255), a programmable timer(8253), an IDE hard-drive interface(2.5 Inch HDD), and a sound chip(AY-3-8910).</br>
- 8 prioritized external interrupts</br>
- DMA channel</br>
- The sequencer is microcoded, with 15 ROMS operating horizontally</br>
- 8/16-Bit MUL and DIV instructions</br>
- Fast indexed string instructions in the spirit of x86's REP MOVSB, CMPSB, LODSB, STOSB, etc</br>
</br>

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
| TDR    | TDRH/TDRL | Temporary Data Register (Internal CPU scratch register) 
</pre>
<h3>Software</h3>
* Unix-like operating system</br>
* Assembler</br>
* Full C compiler</br>
* SystemVerilog model</br>
* Emulator</br>
* I plan to port the original Colossal Cave adventure, as well as many other text-adventure games in the near future.
</br>
</td>
</tr>

<tr><td>
</br>
<i>Here is a demonstration session on Sol-1:</i>
</br>
</br>
</br>

<img src="/images/Screenshot from 2023-12-07 10-54-26.png"></br>
<img src="/images/Screenshot from 2023-12-07 10-54-47.png"></br>
<img src="/images/Screenshot from 2023-12-07 10-55-57.png"></br>
<img src="/images/Screenshot from 2023-12-07 10-56-11.png"></br>
<img src="/images/Screenshot from 2023-12-07 10-57-16.png"></br>
<img src="/images/Screenshot from 2023-12-07 11-00-16.png"></br>
<img src="/images/Screenshot from 2023-12-07 11-01-51.png"></br>
<img src="/images/Screenshot from 2023-12-07 11-02-06.png"></br>
<img src="/images/Screenshot from 2023-12-07 11-02-15.png"></br>
<img src="/images/Screenshot from 2023-12-07 11-03-06.png"></br>
<img src="/images/Screenshot from 2023-12-07 11-03-20.png"></br>




</td>
</tr>
</table>



<?php include("footer.php"); ?>
</body>
</html>

