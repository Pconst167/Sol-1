import pa_fpu::*;

module fpu_tb;

  logic arst;
  logic clk;
  logic [7:0] databus_in;
  logic [7:0] databus_out;
  logic [5:0] addr; 
  logic cs;
  logic rd;
  logic wr;
  logic end_ack;      // acknowledge end
  logic cmd_end;      // end of command / irq
  logic busy;   // active high when an operation is in progress

  initial begin
    clk = 0;
    forever #250ns clk = ~clk;
  end

  initial begin
    #100us $finish;
  end

  initial begin
    arst = 1;
    databus_in = '0;
    addr = '0;
    cs = 1'b1;
    rd = 1'b1;
    wr = 1'b1;
    end_ack = 1'b0;
    #500ns;
    arst = 0;

    write_operand_a(32'h401ccccd); //  2.45
    write_operand_b(32'h406a3d71); //  3.66          410f78d5

    // write operation
    #500ns;
    cs = 1'b0;
    databus_in = pa_fpu::op_mul;
    addr = 6'h8;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
  end

  fpu fpu_top(
    .arst              (arst),
    .clk               (clk),
    .databus_in  (databus_in),
    .databus_out (databus_out),
    .addr        (addr),
    .cs                (cs),
    .rd                (rd),
    .wr                (wr),
    .end_ack           (end_ack),
    .cmd_end           (cmd_end),
    .busy        (busy)
  );


  task write_operand_a(
    input logic [31:0] op_a
  );
    #500ns;
    cs = 1'b0;
    databus_in = op_a[7:0];
    addr = 6'h0;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
    #500ns;
    cs = 1'b0;
    databus_in = op_a[15:8];
    addr = 6'h1;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
    #500ns;
    cs = 1'b0;
    databus_in = op_a[23:16];
    addr = 6'h2;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
    #500ns;
    cs = 1'b0;
    databus_in = op_a[31:24];
    addr = 6'h3;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
  endtask

  task write_operand_b(
    input logic [31:0] op_b
  );
    #500ns;
    cs = 1'b0;
    databus_in = op_b[7:0];
    addr = 6'h4;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
    #500ns;
    cs = 1'b0;
    databus_in = op_b[15:8];
    addr = 6'h5;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
    #500ns;
    cs = 1'b0;
    databus_in = op_b[23:16];
    addr = 6'h6;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
    #500ns;
    cs = 1'b0;
    databus_in = op_b[31:24];
    addr = 6'h7;
    wr = 1'b0;
    #500ns;
    wr = 1'b1;
    cs = 1'b1;
  endtask




endmodule