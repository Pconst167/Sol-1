
<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">
<link rel="icon" href="http://sol-1.org/images/2.jpg">	

<style>
    table a,
table a:visited,
table a:active {
    color: blue !important;
}
</style>
</head>

<body>


<?php
	include("menu.php");
?>

</br>

<table  width="80%">
<tr><td>
<h3>Overview</h3>
<pre>
Sol-1 has a microcode engine, which controls the flow of execution for each of its instructions.</br>
Broadly speaking, it works in the following way: Each instruction is composed of up to 64 micro-instructions. At each falling edge of the clock, we update
the control word, which consists of a row of flip flops, whose inputs come from a large rom. These control bits are stored in flip-flops and they control
what will happen on the next rising edge of the clock. The control bits consist of various types of control information, such as write enables for registers,
multiplexer selection bits, alu function codes, and also information about the current micro-instruction, such as its type, and by how much the micro-address
register should be incremented at the next rising edge, and so on.
This means that after each falling edge, Sol-1 is ready to change its internal state, it knows what needs to be done on the next rising edge of the clock. 
When the next rksing edge of the clock arrives, these control bits will dictate whether a particular register, say register A, will input whatever data waits
at its input, and so on.
After a rising edge comes on, the current value of the control word will contain information about the current micro-instruction, such as its type,
how much the micro-address should be incremented by, and any microcode conditions.
Based on the type of the current micro-instruction, then at the next rising edge, the next micro-instruction will be selected.
There are 4 types of micro-instruction, named: next_by_offset, branch, next_is_fetch and next_by_ir.
In 'next_by_offset', the address of the next micro-instruction will be the current address plus the 'offset' field of the current micro-instruction.
In 'branch', we test a condition inside the CPU, and if the result is true, we jump by the 'offset' field, otherwise we add +1.
In 'next_is_fetch', the next micro-instruction will be the 'fetch' one, which will fetch the next instruction from RAM.
In 'next_by_ir', we use the value of the instruction register as the base address for the next micro-instruction.
</pre>

<h3>Control Word</h3>
<pre>
ROM0
typ0
typ1
u_offset_0
u_offset_1
u_offset_2
u_offset_3
u_offset_4
u_offset_5

ROM1
u_offset_6
cond_invert
cond_flag_src
cond_sel_0
cond_sel_1
cond_sel_2
cond_sel_3
escape

ROM2
u_zf_in_src_0
u_zf_in_src_1
u_cf_in_src_0
u_cf_in_src_1
u_sf_in_src
u_of_in_src
ir_wrt
status_flags_wrt

ROM3
shift_src_0
shift_src_1
shift_src_2
zbus_in_src_0
zbus_in_src_1
alu_a_src_0          
alu_a_src_1          
alu_a_src_2

ROM4
alu_a_src_3
alu_a_src_4
alu_a_src_5
alu_op_0
alu_op_1
alu_op_2
alu_op_3
alu_mode

ROM5
alu_cf_in_src0
alu_cf_in_src1
alu_cf_in_invert
zf_in_src_0
zf_in_src_1
alu_cf_out_invert
cf_in_src_0
cf_in_src_1

ROM6
cf_in_src_2
sf_in_src_0
sf_in_src_1
of_in_src_0
of_in_src_1
of_in_src_2
rd                         
wr                         
                         
ROM7
alu_b_src_0
alu_b_src_1
alu_b_src_2
display_reg_load 
dl_wrt
dh_wrt
cl_wrt
ch_wrt

ROM8
bl_wrt
bh_wrt
al_wrt
ah_wrt
mdr_in_src
mdr_out_src
mdr_out_en   
mdr_l_wrt   

ROM9
mdr_h_wrt
tdr_l_wrt
tdr_h_wrt
di_l_wrt
di_h_wrt
si_l_wrt
si_h_wrt
mar_l_wrt

ROM10
mar_h_wrt
bp_l_wrt
bp_h_wrt
pc_l_wrt
pc_h_wrt
sp_l_wrt
sp_h_wrt
unused

ROM11
unused
int_vector_wrt
irq_masks_wrt   
mar_in_src
int_ack          
clear_all_ints
ptb_wrt
page_table_we

ROM12
mdr_to_pagetable_data_buffer
force_user_ptb    
unused
unused
unused
unused
gl_wrt
gh_wrt


ROM13
immy_0
immy_1
immy_2
immy_3
immy_4
immy_5
immy_6
immy_7

</pre>
<h3>Microcode compiler</h3>
<pre>
Sol-1 has a microcode compiler tool, built to make the programming of instructions easier. 
These is a GUI version and a text based version. The GUI version was programmed for Windows at the time, and I run it through WINE on Linux.
The text-based version is used directly on Linux.
The tools are located in the sol-1/hardware folder.
</pre>

<h3>Sol-1's microcode listing</h3>
This is the listing for Sol-1's entire microcode as a text-file: <a href="https://github.com/Pconst167/sol-1/blob/main/hardware/microcode_assembler/sol-1.micro">Click here to download.</a>
</td></tr>

</table>
<?php include("footer.php"); ?>
</body>
</html>

