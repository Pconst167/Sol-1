
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
cpu_top.sv:

module cpu_top(
  input logic arst,
  input logic clk,
  //input logic [7:0] data_bus,
  input logic [7:0] pins_irq_req,
  input logic dma_req,
  input logic pin_wait,
  input logic ext_input,
  
  inout logic [7:0] data_bus,
  output logic [21:0] address_bus,
  //output logic [7:0] data_bus_out,
  output logic rd,
  output logic wr,
  output logic mem_io,
  output logic halt,
  output logic dma_ack
);
  import pa_cpu::*; 

// General registers
  logic [7:0] ah, al;
  logic [7:0] bh, bl;
  logic [7:0] ch, cl;
  logic [7:0] dh, dl;
  logic [7:0] gh, gl;
  
// System registers
  logic [7:0] ir;
  logic [7:0] pch, pcl;
  logic [7:0] ptb;
  logic [7:0] cpu_status;
  logic [7:0] cpu_flags;
  logic [7:0] irq_masks;
  logic [7:0] irq_status;
  logic [7:0] irq_vector;
  logic [7:0] irq_clear;

  logic status_dma_ack;
  logic status_irq_en;
  logic status_mode;
  logic status_paging_en;
  logic status_halt;
  logic status_displayreg_load;
  logic status_dir;

// Special registers
  logic [7:0] sph, spl;
  logic [7:0] ssph, sspl;
  logic [7:0] bph, bpl;
  logic [7:0] sih, sil;
  logic [7:0] dih, dil;
  logic [7:0] marh, marl;
  logic [7:0] mdrh, mdrl;
  logic [7:0] tdrh, tdrl;
  
// Buses
  logic [7:0] x_bus;
  logic [7:0] w_bus;
  logic [7:0] y_bus; 
  logic [7:0] k_bus;
  logic [7:0] z_bus; 

// ALU
  logic [7:0] alu_out;
  logic alu_zf;
  logic alu_cf_out;
  logic alu_sf;
  logic alu_of;
  logic alu_final_cf;
  logic [7:0] u_flags;
  logic alu_cf_in;
  logic irq_request;
// IRQ requests after passing through their corresponding DFFs
  logic [7:0] irq_dff;
  
// Control word fields
  logic [1:0] ctrl_typ;
  logic [6:0] ctrl_offset;
  logic ctrl_cond_invert;
  logic ctrl_cond_flag_src;
  logic [3:0] ctrl_cond_sel;
  logic ctrl_escape;
  logic [1:0] ctrl_u_zf_in_src;
  logic [1:0] ctrl_u_cf_in_src;
  logic ctrl_u_sf_in_src;
  logic ctrl_u_of_in_src;
  logic ctrl_ir_wrt;
  logic ctrl_status_wrt;
  logic [2:0] ctrl_shift_src;
  logic [1:0] ctrl_zbus_src;
  logic [5:0] ctrl_alu_a_src;
  logic [3:0] ctrl_alu_op;
  logic ctrl_alu_mode;
  logic [1:0] ctrl_alu_cf_in_src;
  logic ctrl_alu_cf_in_invert;
  logic ctrl_alu_cf_out_invert;
  logic [1:0] ctrl_zf_in_src;
  logic [2:0] ctrl_cf_in_src;
  logic [1:0] ctrl_sf_in_src;
  logic [2:0] ctrl_of_in_src;
  logic ctrl_rd;
  logic ctrl_wr;
  logic [2:0] ctrl_alu_b_src;
  logic ctrl_display_reg_load; // used during fetch to select and load register display
  logic ctrl_dl_wrt;
  logic ctrl_dh_wrt;
  logic ctrl_cl_wrt;
  logic ctrl_ch_wrt;
  logic ctrl_bl_wrt;
  logic ctrl_bh_wrt;
  logic ctrl_al_wrt;
  logic ctrl_ah_wrt;
  logic ctrl_mdr_in_src;
  logic ctrl_mdr_out_src;
  logic ctrl_mdr_out_en;
  logic ctrl_mdr_l_wrt;			
  logic ctrl_mdr_h_wrt;
  logic ctrl_tdr_l_wrt;
  logic ctrl_tdr_h_wrt;
  logic ctrl_di_l_wrt;
  logic ctrl_di_h_wrt;
  logic ctrl_si_l_wrt;
  logic ctrl_si_h_wrt;
  logic ctrl_mar_l_wrt;
  logic ctrl_mar_h_wrt;
  logic ctrl_bp_l_wrt;
  logic ctrl_bp_h_wrt;
  logic ctrl_pc_l_wrt;
  logic ctrl_pc_h_wrt;
  logic ctrl_sp_l_wrt;
  logic ctrl_sp_h_wrt;
  logic ctrl_gl_wrt;
  logic ctrl_gh_wrt;
  logic ctrl_int_vector_wrt;
  logic ctrl_irq_masks_wrt;		// wrt signals are also active low
  logic ctrl_mar_in_src;
  logic ctrl_int_ack;		      // active high
  logic ctrl_clear_all_ints;
  logic ctrl_ptb_wrt;
  logic ctrl_page_table_we; 
  logic ctrl_mdr_to_pagetable_data_en;
  logic ctrl_force_user_ptb;   // goes to board as page_table_addr_source via or gate
  logic [7:0] ctrl_immy;

// Derived signals
  logic pagetable_addr_source;
  logic bus_tristate;
  logic int_pending;

// Nets
  wire logic [15:0] mdr_to_pagetable_data;
  wire logic bus_rd;
  wire logic bus_wr;
  wire logic bus_mem_io;

  assign rd = ~bus_rd;
  assign wr = ~bus_wr;
  assign mem_io = bus_mem_io;
  assign halt = status_halt;
  assign dma_ack = status_dma_ack;

  assign status_dma_ack         = cpu_status[bitpos_cpu_status_dma_ack];
  assign status_irq_en          = cpu_status[bitpos_cpu_status_irq_en];
  assign status_mode            = cpu_status[bitpos_cpu_status_mode];
  assign status_paging_en       = cpu_status[bitpos_cpu_status_paging_en];
  assign status_halt            = cpu_status[bitpos_cpu_status_halt];
  assign status_displayreg_load = cpu_status[bitpos_cpu_status_displayreg_load];
  assign status_dir             = cpu_status[bitpos_cpu_status_dir];

/*************************
 Start of RTL code
**************************/

// ALU
  always_comb begin
    logic cf_muxed;
    case(ctrl_alu_cf_in_src)
      2'b00: cf_muxed = 1'b1;
      2'b01: cf_muxed = cpu_flags[1];
      2'b10: cf_muxed = u_flags[1];
      2'b11: cf_muxed = 1'b0;
    endcase
    alu_cf_in = cf_muxed ^ ctrl_alu_cf_in_invert;
  end
  alu u_alu(
    .a(x_bus),
    .b(y_bus),
    .cf_in(alu_cf_in),
    .op(ctrl_alu_op),
    .mode(ctrl_alu_mode),
    .alu_out(alu_out),
    .alu_cf_out(alu_cf_out)
  );
  assign alu_zf = ~|alu_out;
  assign alu_final_cf = ctrl_alu_cf_out_invert ^ alu_cf_out;
  assign alu_sf = z_bus[7];
  assign alu_of = (z_bus[7] ^ x_bus[7]) & ~((x_bus[7] ^ y_bus[7]) ^ ~(ctrl_alu_op[0] & ctrl_alu_op[3] & ~(ctrl_alu_op[2] | ctrl_alu_op[1])));
  
// CPU Flags
  always_ff @(posedge clk) begin
    case(ctrl_zf_in_src)
      2'b00: cpu_flags[bitpos_cpu_flags_zf] <= cpu_flags[bitpos_cpu_flags_zf];
      2'b01: cpu_flags[bitpos_cpu_flags_zf] <= alu_zf;
      2'b10: cpu_flags[bitpos_cpu_flags_zf] <= cpu_flags[bitpos_cpu_flags_zf] & alu_zf;
      2'b11: cpu_flags[bitpos_cpu_flags_zf] <= z_bus[0];
    endcase
    case(ctrl_cf_in_src)
      3'b000: cpu_flags[bitpos_cpu_flags_cf] <= cpu_flags[bitpos_cpu_flags_cf];
      3'b001: cpu_flags[bitpos_cpu_flags_cf] <= alu_final_cf;
      3'b010: cpu_flags[bitpos_cpu_flags_cf] <= alu_out[0];
      3'b011: cpu_flags[bitpos_cpu_flags_cf] <= z_bus[1];
      3'b100: cpu_flags[bitpos_cpu_flags_cf] <= alu_out[7];
      default: cpu_flags[bitpos_cpu_flags_cf] <= cpu_flags[bitpos_cpu_flags_cf];
    endcase
    case(ctrl_sf_in_src)
      2'b00: cpu_flags[bitpos_cpu_flags_sf] <= cpu_flags[bitpos_cpu_flags_sf];
      2'b01: cpu_flags[bitpos_cpu_flags_sf] <= z_bus[7];
      2'b10: cpu_flags[bitpos_cpu_flags_sf] <= 1'b0;
      2'b11: cpu_flags[bitpos_cpu_flags_sf] <= z_bus[2];
    endcase
    case(ctrl_of_in_src)
      3'b000: cpu_flags[bitpos_cpu_flags_of] <= cpu_flags[bitpos_cpu_flags_of];
      3'b001: cpu_flags[bitpos_cpu_flags_of] <= alu_of;
      3'b010: cpu_flags[bitpos_cpu_flags_of] <= z_bus[7];
      3'b011: cpu_flags[bitpos_cpu_flags_of] <= z_bus[3];
      3'b100: cpu_flags[bitpos_cpu_flags_of] <= u_flags[bitpos_cpu_flags_sf] ^ z_bus[7];
      default: cpu_flags[bitpos_cpu_flags_of] <= cpu_flags[bitpos_cpu_flags_of];
    endcase
  end

// z_bus assignments
  always_comb begin
    logic extremity_bit;
    case(ctrl_shift_src)
      3'b000: extremity_bit = 1'b0;
      3'b001: extremity_bit = u_flags[1]; // u_cf
      3'b010: extremity_bit = cpu_flags[1]; // msw cf
      3'b011: extremity_bit = alu_out[0];
      3'b100: extremity_bit = alu_out[7];
      3'b101: extremity_bit = 1'b1;
      3'b110: extremity_bit = 1'b1;
      3'b111: extremity_bit = 1'b1;
    endcase
    case(ctrl_zbus_src)
      2'b00: z_bus = alu_out;
      2'b01: z_bus = (alu_out >> 1) | {extremity_bit, 7'b000_0000};
      2'b10: z_bus = (alu_out << 1) | {7'b000_0000, extremity_bit};
      2'b11: z_bus = {8{alu_out[7]}};
    endcase
  end

// w_bus assignment
  always_comb begin
    case(ctrl_alu_a_src[4:0])
      5'b00000: w_bus = al;
      5'b00001: w_bus = ah;
      5'b00010: w_bus = bl;
      5'b00011: w_bus = bh;
      5'b00100: w_bus = cl;
      5'b00101: w_bus = ch;
      5'b00110: w_bus = dl;
      5'b00111: w_bus = dh;
      5'b01000: w_bus = spl;
      5'b01001: w_bus = sph;
      5'b01010: w_bus = bpl;
      5'b01011: w_bus = bph;
      5'b01100: w_bus = sil;
      5'b01101: w_bus = sih;
      5'b01110: w_bus = dil;
      5'b01111: w_bus = dih;
      5'b10000: w_bus = pcl;
      5'b10001: w_bus = pch;
      5'b10010: w_bus = marl;
      5'b10011: w_bus = marh;
      5'b10100: w_bus = mdrl;
      5'b10101: w_bus = mdrh;
      5'b10110: w_bus = tdrl;
      5'b10111: w_bus = tdrh;
      5'b11000: w_bus = sspl;
      5'b11001: w_bus = ssph;
      5'b11010: w_bus = irq_vector;
      5'b11011: w_bus = irq_masks;
      5'b11100: w_bus = irq_status;
      5'b11101: w_bus = '0;
      5'b11110: w_bus = '0;
      5'b11111: w_bus = '0;
    endcase
  end     

// x_bus assignment
  always_comb begin
    if(ctrl_alu_a_src[5] == 1'b0) begin
      x_bus = w_bus;
    end
    else begin
      case(ctrl_alu_a_src[1:0])
        2'b00: x_bus = cpu_flags;
        2'b01: x_bus = cpu_status;
        2'b10: x_bus = gl;
        2'b11: x_bus = gh;
      endcase
    end
  end
  
// k_bus assignment
  always_comb begin
    case(ctrl_alu_b_src[1:0])
      2'b00: k_bus = mdrl;
      2'b01: k_bus = mdrh;
      2'b10: k_bus = tdrl;
      2'b11: k_bus = tdrh;
    endcase
  end

// y_bus assignment
  always_comb begin
    if(ctrl_alu_b_src[2] == 1'b0) begin
      y_bus = ctrl_immy;
    end
    else begin
      y_bus = k_bus;
    end
  end

// z_bus to Registers Block
  always_ff @(posedge clk) begin
    if(ctrl_al_wrt == 1'b0) al <= z_bus;
    if(ctrl_ah_wrt == 1'b0) ah <= z_bus;
    if(ctrl_bl_wrt == 1'b0) bl <= z_bus;
    if(ctrl_bh_wrt == 1'b0) bh <= z_bus;
    if(ctrl_cl_wrt == 1'b0) cl <= z_bus;
    if(ctrl_ch_wrt == 1'b0) ch <= z_bus;
    if(ctrl_dl_wrt == 1'b0) dl <= z_bus;
    if(ctrl_dh_wrt == 1'b0) dh <= z_bus;
    if(ctrl_gl_wrt == 1'b0) gl <= z_bus;
    if(ctrl_gh_wrt == 1'b0) gh <= z_bus;

    if(ctrl_tdr_l_wrt == 1'b0) tdrl <= z_bus;
    if(ctrl_tdr_h_wrt == 1'b0) tdrh <= z_bus;
    if(ctrl_di_l_wrt == 1'b0) dil <= z_bus;
    if(ctrl_di_h_wrt == 1'b0) dih <= z_bus;
    if(ctrl_si_l_wrt == 1'b0) sil <= z_bus;
    if(ctrl_si_h_wrt == 1'b0) sih <= z_bus;
    if(ctrl_bp_l_wrt == 1'b0) bpl <= z_bus;
    if(ctrl_bp_h_wrt == 1'b0) bph <= z_bus;
    if(ctrl_sp_l_wrt == 1'b0) spl <= z_bus;
    if(ctrl_sp_h_wrt == 1'b0) sph <= z_bus;
    if(ctrl_pc_l_wrt == 1'b0) pcl <= z_bus;
    if(ctrl_pc_h_wrt == 1'b0) pch <= z_bus;
    if(ctrl_status_wrt == 1'b0) cpu_status <= z_bus;
    if(ctrl_irq_masks_wrt == 1'b0) irq_masks <= z_bus;
    if(ctrl_sp_l_wrt == 1'b0 && status_mode == 1'b0) sspl <= z_bus;
    if(ctrl_sp_h_wrt == 1'b0 && status_mode == 1'b0) ssph <= z_bus;

    if(ctrl_ir_wrt == 1'b0) ir <= data_bus;
    if(ctrl_mar_l_wrt == 1'b0) marl <= ctrl_mar_in_src ? pcl : z_bus;
    if(ctrl_mar_h_wrt == 1'b0) marh <= ctrl_mar_in_src ? pch : z_bus;
    if(ctrl_mdr_l_wrt == 1'b0) mdrl <= ctrl_mdr_in_src ? data_bus : z_bus;
    if(ctrl_mdr_h_wrt == 1'b0) mdrh <= ctrl_mdr_in_src ? data_bus : z_bus;

    if(ctrl_ptb_wrt == 1'b0) ptb <= z_bus;
  end

// Page Table
  assign pagetable_addr_source = ctrl_force_user_ptb || status_mode;
  assign mdr_to_pagetable_data = ctrl_mdr_to_pagetable_data_en ? {mdrh, mdrl} : 'z;
  memory #(PAGETABLE_RAM_SIZE) u_pagetable_low(
    .ce_n(1'b0),
    .oe_n(ctrl_mdr_to_pagetable_data_en),
    .we_n(~ctrl_page_table_we),
    .address({pagetable_addr_source ? ptb : 8'h00, marh[7:3]}),
    .data_in(mdr_to_pagetable_data[7:0]),
    .data_out(mdr_to_pagetable_data[7:0])    
  );
  memory #(PAGETABLE_RAM_SIZE) u_pagetable_high(
    .ce_n(1'b0),
    .oe_n(ctrl_mdr_to_pagetable_data_en),
    .we_n(~ctrl_page_table_we),
    .address({pagetable_addr_source ? ptb : 8'h00, marh[7:3]}),
    .data_in(mdr_to_pagetable_data[15:8]),
    .data_out(mdr_to_pagetable_data[15:8])    
  );
  assign bus_tristate = status_dma_ack || status_halt;
  assign address_bus = bus_tristate ? 'z : status_paging_en ? {mdr_to_pagetable_data[10:0], marh[2:0], marl[7:0]} : {6'b000000, marh, marl};
  assign bus_mem_io = bus_tristate ? 1'bz : status_paging_en ? mdr_to_pagetable_data[11] : 1'b1;
  assign bus_rd = bus_tristate ? 1'bz : ctrl_rd;
  assign bus_wr = bus_tristate ? 1'bz : ctrl_wr;
  assign data_bus = ctrl_mdr_out_en ? ctrl_mdr_out_src ? mdrh : mdrl : 'z;

// Interrupts
  for(genvar i = 0; i < 8; i++) begin
    assign irq_clear[i] = ctrl_int_ack && irq_vector[3:1] == i;
    always_ff @(posedge pins_irq_req[i], posedge ctrl_clear_all_ints, posedge irq_clear[i]) begin
      if(ctrl_clear_all_ints == 1'b1 || irq_clear[i] == 1'b1) irq_dff[i] <= 1'b0;
      else irq_dff[i] <= 1'b1;
    end
  end
  always_ff @(posedge clk) begin
    irq_status <= irq_dff;
  end
  // IRQ Handling Block
  always_ff @(posedge clk) begin
    logic [7:0] irqs_masked;
    logic [2:0] irq_encoded;

    irqs_masked = irq_status & irq_masks;
    irq_request = |irqs_masked; // Check if any IRQ is requested
    if(irqs_masked[0] == 1'b1) irq_encoded = 000;
    else if(irqs_masked[1] == 1'b1) irq_encoded = 3'b001;
    else if(irqs_masked[2] == 1'b1) irq_encoded = 3'b010;
    else if(irqs_masked[3] == 1'b1) irq_encoded = 3'b011;
    else if(irqs_masked[4] == 1'b1) irq_encoded = 3'b100;
    else if(irqs_masked[5] == 1'b1) irq_encoded = 3'b101;
    else if(irqs_masked[6] == 1'b1) irq_encoded = 3'b110;
    else if(irqs_masked[7] == 1'b1) irq_encoded = 3'b111;
    
    if(ctrl_int_vector_wrt == 1'b0) begin
      irq_vector <= {4'b0000, irq_encoded[2:0], 1'b0};
    end
  end
  assign int_pending = irq_request & status_irq_en;

// Microcode Sequencer
  microcode_sequencer u_microcode_sequencer(
    .arst(arst),
    .clk(clk),
    .ir(ir),
    .cpu_flags(cpu_flags),
    .cpu_status(cpu_status),
    .z_bus(z_bus),
    .alu_out(alu_out),
    .alu_zf(alu_zf),
    .alu_of(alu_of),
    .alu_final_cf(alu_final_cf),
    .dma_req(dma_req),
    ._wait(pin_wait),
    .int_pending(int_pending),
    .ext_input(ext_input),
    .u_flags(u_flags),

    .* // control word
  );


endmodule



sol1_top.sv:
module sol1_top;
  import pa_testbench::*;

	logic arst;
	logic stop_clk_req;
  logic clk;
	logic halt;
	logic dma_req;
	logic dma_ack;
	logic [7:0] pins_irq_req;
  logic pin_wait;
  logic ext_input;

// Bus
	wire logic [21:0] address_bus;
	wire logic [7:0] data_bus;
	wire logic rd;
	wire logic wr;
	wire logic mem_io;

// Chip selects
  logic bios_ram_cs;
  logic bios_rom_cs;
  logic uart0_cs;
  logic uart1_cs;
  logic rtc_cs;
  logic pio0_cs;
  logic pio1_cs;
  logic ide_cs;
  logic timer_cs;
  logic bios_config_cs;

  // Address decoding support wires
  wire logic inside_real_mode_addr_space;
  wire logic addr_bus_7_to_14_alltrue;
  wire logic peripheral_access;

  initial begin
    // Load bios code into rom
    static int fp = $fopen("../software/obj/bios.obj", "rb");
    if(!fp) $fatal("Failed to open bios.obj");
    if(!$fread(sol1_top.u_bios_rom.mem, fp)) $fatal("Failed to read bios.obj");
    $display("OK.");

    // Start CPU...
		pins_irq_req = 8'h00;
		dma_req = 1'b0;
    ext_input = 1'b0;
    pin_wait = 1'b0;

    arst = 1'b1;
		stop_clk_req = 1'b1;
    #100ns;
		arst = 1'b0;	
    #100ns;
		stop_clk_req = 1'b0;

		#100ms $stop;
  end

	clock u_clock(
		.arst(arst),
		.stop_clk_req(stop_clk_req),
		.clk_out(clk)
	);

	cpu_top u_cpu_top(
		.arst(arst),
		.clk(clk),
		.pins_irq_req(pins_irq_req),
		.dma_req(dma_req),
		.address_bus(address_bus),
		//.data_bus_in(data_bus),
		//.data_bus_out(data_bus),
		.data_bus(data_bus),
		.rd(rd),
		.wr(wr),
		.mem_io(mem_io),
		.halt(halt),
		.dma_ack(dma_ack),
    .pin_wait(pin_wait),
    .ext_input(ext_input)
	);

  memory #(32 * KB) u_bios_rom(
    .ce_n(bios_rom_cs),
    .oe_n(rd),
    .we_n(1'b1),
    .address(address_bus[14:0]),
    .data_in(data_bus),
    .data_out(data_bus)
  );
  memory #(32 * KB) u_bios_ram(
    .ce_n(bios_ram_cs),
    .oe_n(rd),
    .we_n(wr),
    .address(address_bus[14:0]),
    .data_in(data_bus),
    .data_out(data_bus)
  );

  ide u_ide(
    .arst(arst),
    .clk(clk),
    .ce_n(ide_cs),
    .oe_n(rd),
    .we_n(wr),
    .address(address_bus[2:0]),
    .data_in(data_bus),
    .data_out(data_bus)
  );

  uart u_uart0(
    .arst(arst),
    .clk(clk),
    .ce_n(uart0_cs),
    .oe_n(rd),
    .we_n(wr),
    .address(address_bus[2:0]),
    .data_in(data_bus),
    .data_out(data_bus)
  );

  // Declare 8x 512KB RAM modules
  generate for(genvar i = 0; i < 8; i++) begin
    memory #(512 * KB) u_ram(
      .ce_n(!(address_bus[21:19] == i[2:0] && !mem_io)),
      .oe_n(rd),
      .we_n(wr),
      .address(address_bus[18:0]),
      .data_in(data_bus),
      .data_out(data_bus)
    );
  end endgenerate

  assign addr_bus_7_to_14_alltrue = & address_bus[14:7];
  assign inside_real_mode_addr_space = ~| address_bus[21:16];
  assign peripheral_access = addr_bus_7_to_14_alltrue && address_bus[15] && mem_io;

  assign bios_rom_cs    = !(mem_io && inside_real_mode_addr_space && !address_bus[15]);
  assign bios_ram_cs    = !(mem_io && inside_real_mode_addr_space && !addr_bus_7_to_14_alltrue && address_bus[15]);
  assign uart0_cs       = peripheral_access ? !(address_bus[6:4] == 3'b000) : 1'b1;
  assign uart1_cs       = peripheral_access ? !(address_bus[6:4] == 3'b001) : 1'b1;
  assign rtc_cs         = peripheral_access ? !(address_bus[6:4] == 3'b010) : 1'b1;
  assign pio0_cs        = peripheral_access ? !(address_bus[6:4] == 3'b011) : 1'b1;
  assign pio1_cs        = peripheral_access ? !(address_bus[6:4] == 3'b100) : 1'b1;
  assign ide_cs         = peripheral_access ? !(address_bus[6:4] == 3'b101) : 1'b1;
  assign timer_cs       = peripheral_access ? !(address_bus[6:4] == 3'b110) : 1'b1;
  assign bios_config_cs = peripheral_access ? !(address_bus[6:4] == 3'b111) : 1'b1;

endmodule



microcode_sequencer.sv:
module microcode_sequencer(
  input logic arst,
  input logic clk,
  input logic [7:0] ir,
  input logic [7:0] cpu_flags,
  input logic [7:0] cpu_status,
  input logic [7:0] z_bus,
  input logic [7:0] alu_out,
  input logic alu_zf,
  input logic alu_of,
  input logic alu_final_cf,
  input logic dma_req,
  input logic _wait,
  input logic int_pending,
  input logic ext_input,
  
  output logic [7:0] u_flags,
  
  output logic [1:0] ctrl_typ,
  output logic [6:0] ctrl_offset,
  output logic ctrl_cond_invert,
  output logic ctrl_cond_flag_src,
  output logic [3:0] ctrl_cond_sel,
  output logic ctrl_escape,
  output logic [1:0] ctrl_u_zf_in_src,
  output logic [1:0] ctrl_u_cf_in_src,
  output logic ctrl_u_sf_in_src,
  output logic ctrl_u_of_in_src,
  output logic ctrl_ir_wrt,
  output logic ctrl_status_wrt,
  output logic [2:0] ctrl_shift_src,
  output logic [1:0] ctrl_zbus_src,
  output logic [5:0] ctrl_alu_a_src,
  output logic [3:0] ctrl_alu_op,
  output logic ctrl_alu_mode,
  output logic [1:0] ctrl_alu_cf_in_src,
  output logic ctrl_alu_cf_in_invert,
  output logic ctrl_alu_cf_out_invert,
  output logic [1:0] ctrl_zf_in_src,
  output logic [2:0] ctrl_cf_in_src,
  output logic [1:0] ctrl_sf_in_src,
  output logic [2:0] ctrl_of_in_src,
  output logic ctrl_rd,
  output logic ctrl_wr,
  output logic [2:0] ctrl_alu_b_src,
  output logic ctrl_display_reg_load, // used during fetch to select and load register display
  output logic ctrl_dl_wrt,
  output logic ctrl_dh_wrt,
  output logic ctrl_cl_wrt,
  output logic ctrl_ch_wrt,
  output logic ctrl_bl_wrt,
  output logic ctrl_bh_wrt,
  output logic ctrl_al_wrt,
  output logic ctrl_ah_wrt,
  output logic ctrl_mdr_in_src,
  output logic ctrl_mdr_out_src,
  output logic ctrl_mdr_out_en,
  output logic ctrl_mdr_l_wrt,			
  output logic ctrl_mdr_h_wrt,
  output logic ctrl_tdr_l_wrt,
  output logic ctrl_tdr_h_wrt,
  output logic ctrl_di_l_wrt,
  output logic ctrl_di_h_wrt,
  output logic ctrl_si_l_wrt,
  output logic ctrl_si_h_wrt,
  output logic ctrl_mar_l_wrt,
  output logic ctrl_mar_h_wrt,
  output logic ctrl_bp_l_wrt,
  output logic ctrl_bp_h_wrt,
  output logic ctrl_pc_l_wrt,
  output logic ctrl_pc_h_wrt,
  output logic ctrl_sp_l_wrt,
  output logic ctrl_sp_h_wrt,
  output logic ctrl_gl_wrt,
  output logic ctrl_gh_wrt,
  output logic ctrl_int_vector_wrt,
  output logic ctrl_irq_masks_wrt,		// wrt signals are also active low
  output logic ctrl_mar_in_src,
  output logic ctrl_int_ack,		      // active high
  output logic ctrl_clear_all_ints,
  output logic ctrl_ptb_wrt,
  output logic ctrl_page_table_we, 
  output logic ctrl_mdr_to_pagetable_data_en,
  output logic ctrl_force_user_ptb,   // goes to board as page_table_addr_source via or gate
  output logic [7:0] ctrl_immy
);
  import pa_microcode::*;
  import pa_cpu::*;

  logic status_dma_ack;
  logic status_irq_en;
  logic status_mode;
  logic status_paging_en;
  logic status_halt;
  logic status_displayreg_load;
  logic status_dir;

  logic any_interruption;
  logic [CONTROL_WORD_WIDTH - 1 : 0] ucode_roms [CYCLES_PER_INSTRUCTION * NBR_INSTRUCTIONS];
  logic [CONTROL_WORD_WIDTH - 1 : 0] control_word;
  logic [CONTROL_WORD_WIDTH - 1 : 0] control_word_n;
  logic [13:0] u_address;
  logic final_condition;

  assign status_dma_ack         = cpu_status[bitpos_cpu_status_dma_ack];
  assign status_irq_en          = cpu_status[bitpos_cpu_status_irq_en];
  assign status_mode            = cpu_status[bitpos_cpu_status_mode];
  assign status_paging_en       = cpu_status[bitpos_cpu_status_paging_en];
  assign status_halt            = cpu_status[bitpos_cpu_status_halt];
  assign status_displayreg_load = cpu_status[bitpos_cpu_status_displayreg_load];
  assign status_dir             = cpu_status[bitpos_cpu_status_dir];

  assign control_word = ucode_roms[u_address];

  always_ff @(negedge clk) begin
    control_word_n <= control_word;
  end

  assign any_interruption = dma_req | int_pending;

  assign ctrl_typ = control_word[bitpos_typ1 : bitpos_typ0];
  assign ctrl_offset = control_word[bitpos_offset_6 : bitpos_offset_0];
  assign ctrl_cond_invert = control_word[bitpos_cond_invert];
  assign ctrl_cond_flag_src = control_word[bitpos_cond_flag_src];
  assign ctrl_cond_sel = control_word[bitpos_cond_sel_3 : bitpos_cond_sel_0];
  assign ctrl_escape = control_word[bitpos_escape];

  assign ctrl_u_zf_in_src = control_word_n[bitpos_u_zf_in_src_1 : bitpos_u_zf_in_src_0];
  assign ctrl_u_cf_in_src = control_word_n[bitpos_u_cf_in_src_1 : bitpos_u_cf_in_src_0];
  assign ctrl_u_sf_in_src = control_word_n[bitpos_u_sf_in_src];
  assign ctrl_u_of_in_src = control_word_n[bitpos_u_of_in_src];
  assign ctrl_ir_wrt = control_word_n[bitpos_ir_wrt];
  assign ctrl_status_wrt = control_word_n[bitpos_status_wrt];
  assign ctrl_shift_src = control_word_n[bitpos_shift_src_2 : bitpos_shift_src_0];
  assign ctrl_zbus_src = control_word_n[bitpos_zbus_src_1 : bitpos_zbus_src_0];
  assign ctrl_alu_a_src = control_word_n[bitpos_alu_a_src_5 : bitpos_alu_a_src_0];
  assign ctrl_alu_op = control_word_n[bitpos_alu_op_3 : bitpos_alu_op_0];
  assign ctrl_alu_mode = control_word_n[bitpos_alu_mode];
  assign ctrl_alu_cf_in_src = control_word_n[bitpos_alu_cf_in_src_1 : bitpos_alu_cf_in_src_0];
  assign ctrl_alu_cf_in_invert = control_word_n[bitpos_alu_cf_in_invert];
  assign ctrl_alu_cf_out_invert = control_word_n[bitpos_alu_cf_out_invert];
  assign ctrl_zf_in_src = control_word_n[bitpos_zf_in_src_1 : bitpos_zf_in_src_0];
  assign ctrl_cf_in_src = control_word_n[bitpos_cf_in_src_2 : bitpos_cf_in_src_0];
  assign ctrl_sf_in_src = control_word_n[bitpos_sf_in_src_1 : bitpos_sf_in_src_0];
  assign ctrl_of_in_src = control_word_n[bitpos_of_in_src_2 : bitpos_of_in_src_0];
  assign ctrl_rd = control_word_n[bitpos_rd];
  assign ctrl_wr = control_word_n[bitpos_wr];
  assign ctrl_alu_b_src = control_word_n[bitpos_alu_b_src_2 : bitpos_alu_b_src_0];
  assign ctrl_display_reg_load = control_word_n[bitpos_display_reg_load]; // used during fetch to select and load register display
  assign ctrl_dl_wrt = control_word_n[bitpos_dl_wrt];
  assign ctrl_dh_wrt = control_word_n[bitpos_dh_wrt];
  assign ctrl_cl_wrt = control_word_n[bitpos_cl_wrt];
  assign ctrl_ch_wrt = control_word_n[bitpos_ch_wrt];
  assign ctrl_bl_wrt = control_word_n[bitpos_bl_wrt];
  assign ctrl_bh_wrt = control_word_n[bitpos_bh_wrt];
  assign ctrl_al_wrt = control_word_n[bitpos_al_wrt];
  assign ctrl_ah_wrt = control_word_n[bitpos_ah_wrt];
  assign ctrl_mdr_in_src = control_word_n[bitpos_mdr_in_src];
  assign ctrl_mdr_out_src = control_word_n[bitpos_mdr_out_src];
  assign ctrl_mdr_out_en = control_word_n[bitpos_mdr_out_en];
  assign ctrl_mdr_l_wrt = control_word_n[bitpos_mdr_l_wrt];			
  assign ctrl_mdr_h_wrt = control_word_n[bitpos_mdr_h_wrt];
  assign ctrl_tdr_l_wrt = control_word_n[bitpos_tdr_l_wrt];
  assign ctrl_tdr_h_wrt = control_word_n[bitpos_tdr_h_wrt];
  assign ctrl_di_l_wrt = control_word_n[bitpos_di_l_wrt];
  assign ctrl_di_h_wrt = control_word_n[bitpos_di_h_wrt];
  assign ctrl_si_l_wrt = control_word_n[bitpos_si_l_wrt];
  assign ctrl_si_h_wrt = control_word_n[bitpos_si_h_wrt];
  assign ctrl_mar_l_wrt = control_word_n[bitpos_mar_l_wrt];
  assign ctrl_mar_h_wrt = control_word_n[bitpos_mar_h_wrt];
  assign ctrl_bp_l_wrt = control_word_n[bitpos_bp_l_wrt];
  assign ctrl_bp_h_wrt = control_word_n[bitpos_bp_h_wrt];
  assign ctrl_pc_l_wrt = control_word_n[bitpos_pc_l_wrt];
  assign ctrl_pc_h_wrt = control_word_n[bitpos_pc_h_wrt];
  assign ctrl_sp_l_wrt = control_word_n[bitpos_sp_l_wrt];
  assign ctrl_sp_h_wrt = control_word_n[bitpos_sp_h_wrt];
  assign ctrl_gl_wrt = control_word_n[bitpos_gl_wrt];
  assign ctrl_gh_wrt = control_word_n[bitpos_gh_wrt];
  assign ctrl_int_vector_wrt = control_word_n[bitpos_int_vector_wrt];
  assign ctrl_irq_masks_wrt = control_word_n[bitpos_irq_masks_wrt];		// wrt signals are also active low
  assign ctrl_mar_in_src = control_word_n[bitpos_mar_in_src];
  assign ctrl_int_ack = control_word_n[bitpos_int_ack];		      // active high
  assign ctrl_clear_all_ints = control_word_n[bitpos_clear_all_ints];
  assign ctrl_ptb_wrt = control_word_n[bitpos_ptb_wrt];
  assign ctrl_page_table_we = control_word_n[bitpos_page_table_we]; 
  assign ctrl_mdr_to_pagetable_data_en = control_word_n[bitpos_mdr_to_pagetable_data_en];
  assign ctrl_force_user_ptb = control_word_n[bitpos_force_user_ptb];   // goes to board as page_table_addr_source via or gate
  assign ctrl_immy = control_word_n[bitpos_immy_7 : bitpos_immy_0];

  always_comb begin
    logic zf_muxed, cf_muxed, sf_muxed, of_muxed;
    logic condition;
    
    zf_muxed = ctrl_cond_flag_src ? u_flags[0] : cpu_flags[0];
    cf_muxed = ctrl_cond_flag_src ? u_flags[1] : cpu_flags[1];
    sf_muxed = ctrl_cond_flag_src ? u_flags[2] : cpu_flags[2];
    of_muxed = ctrl_cond_flag_src ? u_flags[3] : cpu_flags[3];

    case(ctrl_cond_sel)
      4'b0000: begin
        condition = zf_muxed;
      end
      4'b0001: begin
        condition = cf_muxed;
      end
      4'b0010: begin
        condition = sf_muxed;
      end
      4'b0011: begin
        condition = of_muxed;
      end
      4'b0100: begin
        condition = sf_muxed ^ of_muxed;
      end
      4'b0101: begin
        condition = (sf_muxed ^ of_muxed) | zf_muxed;
      end
      4'b0110: begin
        condition = cf_muxed | zf_muxed;
      end
      4'b0111: begin
        condition = dma_req;
      end
      4'b1000: begin
        condition = status_mode;
      end
      4'b1001: begin
        condition = _wait;
      end
      4'b1010: begin
        condition = int_pending;
      end
      4'b1011: begin
        condition = ext_input;
      end
      4'b1100: begin
        condition = status_dir;
      end
      4'b1101: begin
        condition = status_displayreg_load;
      end
      4'b1110: condition = 1'b0;
      4'b1111: condition = 1'b0;
    endcase

    final_condition = condition ^ ctrl_cond_invert;
  end

  // DFF for u_flags register
  always_ff @(posedge clk) begin
    // u_zf
    case(ctrl_u_zf_in_src)
      2'b00: u_flags[0] <= u_flags[0];
      2'b01: u_flags[0] <= alu_zf;
      2'b10: u_flags[0] <= u_flags[0] & alu_zf;
      2'b11: u_flags[0] <= u_flags[0];
    endcase
    // u_cf
    case(ctrl_u_cf_in_src)
      2'b00: u_flags[1] <= u_flags[1];
      2'b01: u_flags[1] <= alu_final_cf;
      2'b10: u_flags[1] <= alu_out[0];
      2'b11: u_flags[1] <= alu_out[7];
    endcase
    // u_sf
    case(ctrl_u_sf_in_src)
      1'b0: u_flags[2] <= u_flags[2];
      1'b1: u_flags[2] <= z_bus[7];
    endcase
    // u_of
    case(ctrl_u_of_in_src)
      1'b0: u_flags[3] <= u_flags[3];
      1'b1: u_flags[3] <= alu_of;
    endcase
  end

  always_ff @(posedge clk, posedge arst) begin
    if(arst) u_address <= '0;
    else case(ctrl_typ)
      2'b00:
        u_address <= u_address + ctrl_offset;
      2'b01:
        if(final_condition) u_address <= u_address + ctrl_offset;
        else u_address <= u_address + 14'b1;
      2'b10:
        if(any_interruption) u_address <= TRAP_U_ADDR;
        else u_address <= FETCH_U_ADDR;
      2'b11:
        u_address <= {ir, 1'b0, ctrl_escape, 4'b0000};
    endcase
  end

// Load microcode ROM files into microcode memory
  initial begin
    bit [7:0] rom [CYCLES_PER_INSTRUCTION * NBR_INSTRUCTIONS];
    static string rom_base = "../hardware/microcode/roms/rom";
    int file;
    string filename;

    for(int rom_number = 0; rom_number <= 14; rom_number++) begin
      filename = $sformatf("%s%0d", rom_base, rom_number);
      file = $fopen(filename, "rb");
      if(!file) $fatal("Failed to open file.");
      if(!$fread(rom, file)) $fatal("Failed to read file.");

      $display("Loading microcode ROM: ", filename);
      for(int i = 0; i < CYCLES_PER_INSTRUCTION * NBR_INSTRUCTIONS; i++) begin
        ucode_roms[i][rom_number * 8 +: 8] = rom[i][7:0];
      end
    end
  end



endmodule



ide.sv:
module ide(
  input logic arst,
  input logic clk,
  input logic ce_n,
  input logic oe_n,
  input logic we_n,
  input logic [2:0] address,
  input logic [7:0] data_in,

  output logic [7:0] data_out
);
  import pa_testbench::*;
  
  typedef enum logic [3:0] {
    RESET_ST = 4'h0,
    BUSY_ST,
    READ_START_ST,
    READ_ST,
    WRITE_START_ST,
    WRITE_ST,
    COMPLETE_ST
  } t_ideState;

  t_ideState currentState;
  t_ideState nextState;

  logic [7:0] LBA [2:0];
  logic [9:0] byteCounter;
  logic [7:0] mem [672 * KB];
  logic [7:0] registers [7:0];
  logic [7:0] command;
  logic [7:0] status;

  initial begin
    static int fp = $fopen("../disk_backups/image_10Mar2023", "rb");
    $display("Loading disk image...");
    if(!fp) $fatal("Failed to open disk image");
    if(!$fread(mem, fp)) $fatal("Failed to read disk image");
    $display("OK.");
  end

  assign data_out = !ce_n && !oe_n && we_n ? address == 3'h7 ? status : registers[address] : 'z;
  assign LBA = registers[5:3];

// State machine
  always @(posedge clk, posedge arst) begin
    if(arst) begin
      command <= '0;
      status <= 8'b0000_0000;
      byteCounter <= '0;
    end
    else case(currentState)
      RESET_ST: begin
      end
      WRITE_START_ST: begin
        byteCounter <= '0;
        status <= status | 8'b0000_1000; // not finished
      end
      READ_START_ST: begin
        byteCounter <= '0;
        status <= status | 8'b0000_1000; // not finished
      end
      COMPLETE_ST: begin
        status <= status & 8'b1111_0111; // finished
        command <= '0;
      end
    endcase
  end

  always @(negedge oe_n, negedge we_n) begin
    if(!oe_n && address == 3'h0 && !ce_n) begin
      registers[0] <= mem[{LBA[2], LBA[1], LBA[0]} + byteCounter];
      byteCounter <= byteCounter + 10'd1;
    end
    else if(!we_n && !ce_n) begin
      if(address == 3'h0) begin
        mem[{LBA[2], LBA[1], LBA[0]} + byteCounter] <= data_in;
        registers[0] <= data_in; // for completion sake
        byteCounter <= byteCounter + 10'd1;
      end
      else if(!we_n && !ce_n && address == 3'h7) command <= data_in;
      else registers[address] <= data_in;
    end
  end

  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      currentState <= RESET_ST;
    end
    else currentState <= nextState;
  end

  always_comb begin
    nextState = currentState;
    case(currentState)
      RESET_ST:
        if(command == 8'h20) nextState = READ_START_ST;
        else if(command == 8'h30) nextState = WRITE_START_ST;
      WRITE_START_ST:
        nextState = WRITE_ST;
      READ_START_ST:
        nextState = READ_ST;
      READ_ST:
        if(byteCounter == 10'd512) nextState = COMPLETE_ST;
        else if(!oe_n && !ce_n && address == 3'h0) nextState = READ_ST;
      WRITE_ST:
        if(byteCounter == 10'd512) nextState = COMPLETE_ST;
        else if(!we_n && !ce_n && address == 3'h0) nextState = WRITE_ST;
      COMPLETE_ST:
        nextState = RESET_ST;
    endcase
  end

endmodule



alu.sv:
module alu(
  input logic [7:0] a,
  input logic [7:0] b,
  input logic cf_in,
  input logic [3:0] op,
  input logic mode,

  output logic [7:0] alu_out,
  output logic alu_cf_out
);
  logic temp_cf_out;

  always_comb begin
    case(op)
      4'b0000: begin
        {temp_cf_out, alu_out} = mode ? ~a : a + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0001: begin
        {temp_cf_out, alu_out} = mode ? ~(a | b) : (a | b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0010: begin
        {temp_cf_out, alu_out} = mode ? ~a & b : (a | ~b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0011: begin
        {temp_cf_out, alu_out} = mode ? 8'h00 : 8'hFF + {7'b0, ~cf_in}; // -1 + {7'b0, ~cf_in}
        alu_cf_out = ~temp_cf_out;
      end
      4'b0100: begin
        {temp_cf_out, alu_out} = mode ? ~(a & b) : a + (a & ~b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0101: begin
        {temp_cf_out, alu_out} = mode ? ~b : (a | b) + (a & ~b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0110: begin
        {temp_cf_out, alu_out} = mode ? a ^ b : a - b - {7'b0, cf_in};
        alu_cf_out = temp_cf_out;
      end
      4'b0111: begin
        {temp_cf_out, alu_out} = mode ? a & ~b : a & ~b - {7'b0, cf_in};
        alu_cf_out = temp_cf_out;
      end
      4'b1000: begin
        {temp_cf_out, alu_out} = mode ? ~a | b : a + (a & b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1001: begin
        {temp_cf_out, alu_out} = mode ? ~(a ^ b) : a + b + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1010: begin
        {temp_cf_out, alu_out} = mode ? b : (a | ~b) + (a & b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1011: begin
        {temp_cf_out, alu_out} = mode ? a & b : a & b - {7'b0, cf_in};
        alu_cf_out = temp_cf_out;
      end
      4'b1100: begin
        {temp_cf_out, alu_out} = mode ? 8'h01 : a + a + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1101: begin
        {temp_cf_out, alu_out} = mode ? a | ~b : (a | b) + a + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1110: begin
        {temp_cf_out, alu_out} = mode ? a | b : (a | ~b) + a + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1111: begin
        {temp_cf_out, alu_out} = mode ? a : a - {7'b0, cf_in};
        alu_cf_out = temp_cf_out;
      end
    endcase
  end


endmodule


memory.sv:
module memory #(
  parameter MEM_SIZE
)(
  input logic ce_n,
  input logic oe_n,
  input logic we_n,
  input logic [$clog2(MEM_SIZE) - 1 : 0] address,
  input logic [7:0] data_in,
  output logic [7:0] data_out
);

  logic [7:0] mem [MEM_SIZE - 1 : 0];

  assign data_out = !ce_n && !oe_n && we_n ? mem[address] : 'z;

  always @(ce_n, we_n, data_in) begin
    if(!ce_n && !we_n) mem[address] = data_in;
  end

endmodule


clock.sv:
module clock #(
  parameter FREQ = 2.75 // MHz
)(
	input logic arst,
	input logic stop_clk_req,
	output logic clk_out
);
  logic clk;
  logic stop_clk;
  real period = 1.0 / FREQ;
  real halfperiod = period / 2.0;

  initial begin
    clk = 1'b0;
    forever #(halfperiod / 2.0 * 1us) clk = ~clk; // Use halfperiod / 2 instead of halfperiod because clock_out is clk / 2
  end

  always @(negedge clk) begin
    stop_clk <= stop_clk_req;
  end

	always @(posedge clk, posedge arst) begin
    if(arst) clk_out <= 1'b1; // clock starts HIGH so that control bits can be written on the first falling edge.
		else if(!stop_clk) clk_out <= ~clk_out;
	end

endmodule



pa_microcode.sv:
  parameter byte unsigned base_u_rom8 = 8 * 8;
  parameter byte unsigned base_u_rom9 = 9 * 8;
  parameter byte unsigned base_u_rom10 = 10 * 8;
  parameter byte unsigned base_u_rom11 = 11 * 8;
  parameter byte unsigned base_u_rom12 = 12 * 8;
  parameter byte unsigned base_u_rom13 = 13 * 8;  
  
  // control word field positions
  parameter byte unsigned bitpos_typ0 = base_u_rom0 + 0;
  parameter byte unsigned bitpos_typ1 = base_u_rom0 + 1;
  parameter byte unsigned bitpos_offset_0 = base_u_rom0 + 2;
  parameter byte unsigned bitpos_offset_1 = base_u_rom0 + 3;
  parameter byte unsigned bitpos_offset_2 = base_u_rom0 + 4;
  parameter byte unsigned bitpos_offset_3 = base_u_rom0 + 5;
  parameter byte unsigned bitpos_offset_4 = base_u_rom0 + 6;
  parameter byte unsigned bitpos_offset_5 = base_u_rom0 + 7;
  
  parameter byte unsigned bitpos_offset_6 = base_u_rom1 + 0;
  parameter byte unsigned bitpos_cond_invert = base_u_rom1 + 1;
  parameter byte unsigned bitpos_cond_flag_src = base_u_rom1 + 2;
  parameter byte unsigned bitpos_cond_sel_0 = base_u_rom1 + 3;
  parameter byte unsigned bitpos_cond_sel_1 = base_u_rom1 + 4;
  parameter byte unsigned bitpos_cond_sel_2 = base_u_rom1 + 5;
  parameter byte unsigned bitpos_cond_sel_3 = base_u_rom1 + 6;
  parameter byte unsigned bitpos_escape = base_u_rom1 + 7;

  parameter byte unsigned bitpos_u_zf_in_src_0 = base_u_rom2 + 0;
  parameter byte unsigned bitpos_u_zf_in_src_1 = base_u_rom2 + 1;
  parameter byte unsigned bitpos_u_cf_in_src_0 = base_u_rom2 + 2;
  parameter byte unsigned bitpos_u_cf_in_src_1 = base_u_rom2 + 3;
  parameter byte unsigned bitpos_u_sf_in_src = base_u_rom2 + 4;
  parameter byte unsigned bitpos_u_of_in_src = base_u_rom2 + 5;
  parameter byte unsigned bitpos_ir_wrt = base_u_rom2 + 6;
  parameter byte unsigned bitpos_status_wrt = base_u_rom2 + 7;

  parameter byte unsigned bitpos_shift_src_0 = base_u_rom3 + 0;
  parameter byte unsigned bitpos_shift_src_1 = base_u_rom3 + 1;
  parameter byte unsigned bitpos_shift_src_2 = base_u_rom3 + 2;
  parameter byte unsigned bitpos_zbus_src_0 = base_u_rom3 + 3;
  parameter byte unsigned bitpos_zbus_src_1 = base_u_rom3 + 4;
  parameter byte unsigned bitpos_alu_a_src_0	= base_u_rom3 + 5;	
  parameter byte unsigned bitpos_alu_a_src_1	= base_u_rom3 + 6;	
  parameter byte unsigned bitpos_alu_a_src_2 = base_u_rom3 + 7; 

  parameter byte unsigned bitpos_alu_a_src_3 = base_u_rom4 + 0;
  parameter byte unsigned bitpos_alu_a_src_4 = base_u_rom4 + 1;
  parameter byte unsigned bitpos_alu_a_src_5 = base_u_rom4 + 2;
  parameter byte unsigned bitpos_alu_op_0 = base_u_rom4 + 3;
  parameter byte unsigned bitpos_alu_op_1 = base_u_rom4 + 4;
  parameter byte unsigned bitpos_alu_op_2 = base_u_rom4 + 5;
  parameter byte unsigned bitpos_alu_op_3 = base_u_rom4 + 6;
  parameter byte unsigned bitpos_alu_mode = base_u_rom4 + 7;

  parameter byte unsigned bitpos_alu_cf_in_src_0 = base_u_rom5 + 0;
  parameter byte unsigned bitpos_alu_cf_in_src_1 = base_u_rom5 + 1;
  parameter byte unsigned bitpos_alu_cf_in_invert = base_u_rom5 + 2;
  parameter byte unsigned bitpos_zf_in_src_0 = base_u_rom5 + 3;
  parameter byte unsigned bitpos_zf_in_src_1 = base_u_rom5 + 4;
  parameter byte unsigned bitpos_alu_cf_out_invert = base_u_rom5 + 5;
  parameter byte unsigned bitpos_cf_in_src_0 = base_u_rom5 + 6;
  parameter byte unsigned bitpos_cf_in_src_1 = base_u_rom5 + 7;

  parameter byte unsigned bitpos_cf_in_src_2 = base_u_rom6 + 0;
  parameter byte unsigned bitpos_sf_in_src_0 = base_u_rom6 + 1;
  parameter byte unsigned bitpos_sf_in_src_1 = base_u_rom6 + 2;
  parameter byte unsigned bitpos_of_in_src_0 = base_u_rom6 + 3;
  parameter byte unsigned bitpos_of_in_src_1 = base_u_rom6 + 4;
  parameter byte unsigned bitpos_of_in_src_2 = base_u_rom6 + 5;
  parameter byte unsigned bitpos_rd = base_u_rom6 + 6;
  parameter byte unsigned bitpos_wr = base_u_rom6 + 7;

  parameter byte unsigned bitpos_alu_b_src_0 = base_u_rom7 + 0;
  parameter byte unsigned bitpos_alu_b_src_1 = base_u_rom7 + 1;
  parameter byte unsigned bitpos_alu_b_src_2 = base_u_rom7 + 2;
  parameter byte unsigned bitpos_display_reg_load = base_u_rom7 + 3; // used during fetch to select and load register display
  parameter byte unsigned bitpos_dl_wrt = base_u_rom7 + 4;
  parameter byte unsigned bitpos_dh_wrt = base_u_rom7 + 5;
  parameter byte unsigned bitpos_cl_wrt = base_u_rom7 + 6;
  parameter byte unsigned bitpos_ch_wrt = base_u_rom7 + 7;

  parameter byte unsigned bitpos_bl_wrt = base_u_rom8 + 0;
  parameter byte unsigned bitpos_bh_wrt = base_u_rom8 + 1;
  parameter byte unsigned bitpos_al_wrt = base_u_rom8 + 2;
  parameter byte unsigned bitpos_ah_wrt = base_u_rom8 + 3;
  parameter byte unsigned bitpos_mdr_in_src = base_u_rom8 + 4;
  parameter byte unsigned bitpos_mdr_out_src = base_u_rom8 + 5;
  parameter byte unsigned bitpos_mdr_out_en = base_u_rom8 + 6;			// must invert before sending
  parameter byte unsigned bitpos_mdr_l_wrt = base_u_rom8 + 7;			

  parameter byte unsigned bitpos_mdr_h_wrt = base_u_rom9 + 0;
  parameter byte unsigned bitpos_tdr_l_wrt = base_u_rom9 + 1;
  parameter byte unsigned bitpos_tdr_h_wrt = base_u_rom9 + 2;
  parameter byte unsigned bitpos_di_l_wrt = base_u_rom9 + 3;
  parameter byte unsigned bitpos_di_h_wrt = base_u_rom9 + 4;
  parameter byte unsigned bitpos_si_l_wrt = base_u_rom9 + 5;
  parameter byte unsigned bitpos_si_h_wrt = base_u_rom9 + 6;
  parameter byte unsigned bitpos_mar_l_wrt = base_u_rom9 + 7;

  parameter byte unsigned bitpos_mar_h_wrt = base_u_rom10 + 0;
  parameter byte unsigned bitpos_bp_l_wrt = base_u_rom10 + 1;
  parameter byte unsigned bitpos_bp_h_wrt = base_u_rom10 + 2;
  parameter byte unsigned bitpos_pc_l_wrt = base_u_rom10 + 3;
  parameter byte unsigned bitpos_pc_h_wrt = base_u_rom10 + 4;
  parameter byte unsigned bitpos_sp_l_wrt = base_u_rom10 + 5;
  parameter byte unsigned bitpos_sp_h_wrt = base_u_rom10 + 6;
  //parameter byte unsigned bitpos_unused = base_u_rom10 + 7;

  //parameter byte unsigned bitpos_unused = base_u_rom11 + 0;
  parameter byte unsigned bitpos_int_vector_wrt = base_u_rom11 + 1;
  parameter byte unsigned bitpos_irq_masks_wrt = base_u_rom11 + 2;		// << wrt signals are also active low, 	
  parameter byte unsigned bitpos_mar_in_src = base_u_rom11 + 3;
  parameter byte unsigned bitpos_int_ack = base_u_rom11 + 4;		//--- active high
  parameter byte unsigned bitpos_clear_all_ints = base_u_rom11 + 5;
  parameter byte unsigned bitpos_ptb_wrt = base_u_rom11 + 6;
  parameter byte unsigned bitpos_page_table_we = base_u_rom11 + 7; 

  parameter byte unsigned bitpos_mdr_to_pagetable_data_en = base_u_rom12 + 0;
  parameter byte unsigned bitpos_force_user_ptb = base_u_rom12 + 1; // --->>> goes to board as page_table_addr_source via or gate
  //parameter byte unsigned bitpos_unused = base_u_rom12 + 2;
  //parameter byte unsigned bitpos_unused = base_u_rom12 + 3;
  //parameter byte unsigned bitpos_unused = base_u_rom12 + 4;
  //parameter byte unsigned bitpos_unused = base_u_rom12 + 5;
  parameter byte unsigned bitpos_gl_wrt = base_u_rom12 + 6;
  parameter byte unsigned bitpos_gh_wrt = base_u_rom12 + 7;

  parameter byte unsigned bitpos_immy_0 = base_u_rom13 + 0;
  parameter byte unsigned bitpos_immy_1 = base_u_rom13 + 1;
  parameter byte unsigned bitpos_immy_2 = base_u_rom13 + 2;
  parameter byte unsigned bitpos_immy_3 = base_u_rom13 + 3;
  parameter byte unsigned bitpos_immy_4 = base_u_rom13 + 4;
  parameter byte unsigned bitpos_immy_5 = base_u_rom13 + 5;
  parameter byte unsigned bitpos_immy_6 = base_u_rom13 + 6;
  parameter byte unsigned bitpos_immy_7 = base_u_rom13 + 7;
 
endpackage


pa_cpu.sv:
package pa_cpu;
  parameter PAGETABLE_RAM_SIZE = 2 ** 13;

  parameter byte unsigned bitpos_cpu_status_dma_ack = 0;
  parameter byte unsigned bitpos_cpu_status_irq_en = 1;
  parameter byte unsigned bitpos_cpu_status_mode = 2;
  parameter byte unsigned bitpos_cpu_status_paging_en = 3;
  parameter byte unsigned bitpos_cpu_status_halt = 4;
  parameter byte unsigned bitpos_cpu_status_displayreg_load = 5;
  // pos 6 undefined for now
  parameter byte unsigned bitpos_cpu_status_dir = 7;

  parameter byte unsigned bitpos_cpu_flags_zf = 0;
  parameter byte unsigned bitpos_cpu_flags_cf = 1;
  parameter byte unsigned bitpos_cpu_flags_sf = 2;
  parameter byte unsigned bitpos_cpu_flags_of = 3;

endpackage

</pre>
</td></tr>
</table>
</br><br>
<?php include("footer.php"); ?>
</body>
</html>

