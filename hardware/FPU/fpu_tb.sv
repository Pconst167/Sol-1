import pa_fpu::*;

module fpu_tb;

  logic arst;
  logic clk;
  logic [7:0] databus_in;
  logic [7:0] databus_out;
  logic [3:0] addr; 
  logic cs;
  logic rd;
  logic wr;
  logic end_ack;      // acknowledge end
  logic cmd_end;      // end of command / irq
  logic busy;   // active high when an operation is in progress

  logic [31:0] result;

  initial begin
    clk = 0;
    forever #250ns clk = ~clk;
  end

  initial begin
    #100us $finish;
  end

  initial begin
    arst = 1;
    end_ack = 1'b0;
    databus_in = '0;
    addr = '0;
    cs = 1'b1;
    rd = 1'b1;
    wr = 1'b1;
    end_ack = 1'b0;
    #500ns;
    arst = 0;

//    write_operand_a(32'h449a522c); //  1234.56789
//    write_operand_b(32'h458ebf1f); //  4567.8901        3e8a60f3          0.270270927

//    write_operand_b(32'h449a522c); //  1234.56789
//    write_operand_a(32'h458ebf1f); //  4567.8901        406ccca7          3.699991009



    write_operand_a(32'h4479fff0); //  
    write_operand_b(32'h4479fff0); //  

    ta_set_operation(pa_fpu::op_add);
    ta_read_result(result);
    $display("Addition Result: %x\n", result);

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

task ta_set_operation(pa_fpu::e_fpu_operation operation);
  // write operation
  #250ns;
  cs = 1'b0;
  databus_in = operation;
  addr = 4'h8;
  #250ns;
  wr = 1'b0;
  #250ns;
  wr = 1'b1;
  #250ns;
  cs = 1'b1;
endtask

task ta_read_result(output logic [31:0] result);
    // Wait for the command to execute and end before reading result
    @(posedge cmd_end);

    // Read result
    #250ns;
    cs = 1'b0;
    addr = 4'h9;
    #250ns;
    rd = 1'b0;
    #250ns;
    result[7:0] = databus_out;
    #250ns;
    addr = 4'hA;
    #250ns;
    result[15:8] = databus_out;
    #250ns;
    addr = 4'hB;
    #250ns;
    result[23:16] = databus_out;
    #250ns;
    addr = 4'hC;
    #250ns;
    result[31:24] = databus_out;
    #250ns;
    rd = 1'b1;
    #250ns;
    cs = 1'b1;

    // send acknowledge signal
    end_ack = 1'b1;
    @(negedge cmd_end);
    end_ack = 1'b0;
endtask

  task write_operand_a(
    input logic [31:0] op_a
  );
    cs = 1'b0;
    databus_in = op_a[7:0];
    addr = 4'h0;
    #250ns;
    wr = 1'b0;
    #250ns;
    wr = 1'b1;
    #250ns;
    databus_in = op_a[15:8];
    addr = 4'h1;
    #250ns;
    wr = 1'b0;
    #250ns;
    wr = 1'b1;
    #250ns;
    databus_in = op_a[23:16];
    addr = 4'h2;
    #250ns;
    wr = 1'b0;
    #250ns;
    wr = 1'b1;
    #250ns;
    databus_in = op_a[31:24];
    addr = 4'h3;
    #250ns;
    wr = 1'b0;
    #250ns;
    wr = 1'b1;
    #250ns;
    cs = 1'b1;
  endtask

  task write_operand_b(
    input logic [31:0] op_b
  );
    cs = 1'b0;
    databus_in = op_b[7:0];
    addr = 4'h4;
    #250ns;
    wr = 1'b0;
    #250ns;
    wr = 1'b1;
    #250ns;
    databus_in = op_b[15:8];
    addr = 4'h5;
    #250ns;
    wr = 1'b0;
    #250ns;
    wr = 1'b1;
    #250ns;
    databus_in = op_b[23:16];
    addr = 4'h6;
    #250ns;
    wr = 1'b0;
    #250ns;
    wr = 1'b1;
    #250ns;
    databus_in = op_b[31:24];
    addr = 4'h7;
    #250ns;
    wr = 1'b0;
    #250ns;
    wr = 1'b1;
    #250ns;
    cs = 1'b1;
  endtask




endmodule