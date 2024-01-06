<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">
<link rel="icon" href="http://sol-1.org/images/2.jpg">	

<style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh; /* Viewport height */
	    background-color: black;
        }

        html {
            height: 100%;
        }
    </style>
</head>

<body>


<?php
	include("menu.php");
?>

</br>

<table>
	<tr>
		<td align="center">
			<iframe style="border-radius:10px;" width="325" height="325" src="https://www.youtube.com/embed/LQJOD-YyRi8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		</td>
		<td align="center">
			<iframe  style="border-radius:10px;"width="325" height="325" src="https://www.youtube.com/embed/-mnIOoQ9Jxo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		</td>
		<td align="center">
			<iframe style="border-radius:10px;" width="325" height="325" src="https://www.youtube.com/embed/Q-ZfEQytvYs" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		</td>
	</tr>
	<tr>
		
		<td align="center">
			<iframe style="border-radius:10px;" width="325" height="325" src="https://www.youtube.com/embed/xK2rUuUZaso" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		</td>
		<td align="center">
			<iframe style="border-radius:10px;" width="325" height="325" src="https://www.youtube.com/embed/1ELm-5UGSP0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		</td>
		<td align="center">
			<iframe style="border-radius:10px;" width="325" height="325" src="https://www.youtube.com/embed/Tx7uD30wfeg" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		</td>
	</tr>
	
	
</table>


<table valign="top">
<?php
	$directory = "images/sol";
	$count=0;

	if (is_dir($directory)){
	  if ($opendirectory = opendir($directory)){
	    while (($file = readdir($opendirectory)) != false){
	   	if($file != "." && $file != ".."){
			if($count % 3 == 0) echo "<tr>";
		    echo "<td><a href=\"images/sol/{$file}\" target=\"_blank\"><img width=\"325\" height=\"325\" src=\"images/sol/{$file}\"></td>"; 
			$count++;
			if($count % 3 == 0) echo "</tr>";
		}
	    }
	    closedir($opendirectory);
	  }
	}
?>
		
</table>

<?php include("footer.php"); ?>
</body>
</html>

