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

  typedef struct{
    logic [31:0] a;
    logic [31:0] b;
    real af;
    real bf;
  } st_fpu_computation;

  st_fpu_computation computation_list[] = {
    st_fpu_computation'{32'h4d96890d, 32'h4a447fad, 315695520.0,  3219435.3},
    st_fpu_computation'{32'h3f800000, 32'h3f8ccccd, 1.0,          1.1},
    st_fpu_computation'{32'h4cbebc20, 32'h0,        100000000,    0},
    st_fpu_computation'{32'h3ee839f1, 32'h0,        0.4535670493, 0},
    st_fpu_computation'{32'h40000000, 32'h0,        2,            0},
    st_fpu_computation'{32'h41200000, 32'h0,        10,           0},
    st_fpu_computation'{32'h40490fda, 32'h402df854, 3.1415926,    2.7182818},
    st_fpu_computation'{32'h3a83126f, 32'h0,        0.001,        0}
  };

  initial begin
    clk = 0;
    forever #250ns clk = ~clk;
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

    write_operand_a(32'h42168f5c); //  37.64
    write_operand_b(32'h41200000); //  10

    ta_set_operation(pa_fpu::op_sqrt);
    ta_start_operation();
    ta_read_result(result);

    $display("Result: 0x%x", result);

    $stop;
  end

  fpu fpu_top(
    .arst        (arst),
    .clk         (clk),
    .databus_in  (databus_in),
    .databus_out (databus_out),
    .addr        (addr),
    .cs          (cs),
    .rd          (rd),
    .wr          (wr),
    .end_ack     (end_ack),
    .cmd_end     (cmd_end),
    .busy        (busy)
  );

  task ta_start_operation;
    @(posedge clk);
    cs = 1'b0;
    addr = 4'h9;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(posedge clk);
    cs = 1'b1;
  endtask

  task ta_set_operation(pa_fpu::e_fpu_op operation);
    // write operation
    @(posedge clk);
    cs = 1'b0;
    databus_in = operation;
    addr = 4'h8;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(posedge clk);
    cs = 1'b1;
  endtask

  task ta_read_result(output logic [31:0] result);
    // Wait for the command to execute and end before reading result
    @(posedge cmd_end);

    // Read result
    @(posedge clk);
    cs = 1'b0;
    addr = 4'h9;
    @(negedge clk);
    rd = 1'b0;
    @(negedge clk);
    result[7:0] = databus_out;
    @(negedge clk);
    addr = 4'hA;
    @(negedge clk);
    result[15:8] = databus_out;
    @(negedge clk);
    addr = 4'hB;
    @(negedge clk);
    result[23:16] = databus_out;
    @(negedge clk);
    addr = 4'hC;
    @(negedge clk);
    result[31:24] = databus_out;
    @(negedge clk);
    rd = 1'b1;
    @(negedge clk);
    cs = 1'b1;

    // send acknowledge signal
    end_ack = 1'b1;
    @(negedge cmd_end);
    @(negedge clk);
    end_ack = 1'b0;
  endtask

  task write_operand_a(
    input logic [31:0] op_a
  );
    @(posedge clk);
    cs = 1'b0;
    databus_in = op_a[7:0];
    addr = 4'h0;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(negedge clk);
    databus_in = op_a[15:8];
    addr = 4'h1;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(negedge clk);
    databus_in = op_a[23:16];
    addr = 4'h2;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(negedge clk);
    databus_in = op_a[31:24];
    addr = 4'h3;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(negedge clk);
    cs = 1'b1;
  endtask

  task write_operand_b(
    input logic [31:0] op_b
  );
    @(posedge clk);
    cs = 1'b0;
    databus_in = op_b[7:0];
    addr = 4'h4;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(negedge clk);
    databus_in = op_b[15:8];
    addr = 4'h5;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(negedge clk);
    databus_in = op_b[23:16];
    addr = 4'h6;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(negedge clk);
    databus_in = op_b[31:24];
    addr = 4'h7;
    @(negedge clk);
    wr = 1'b0;
    @(negedge clk);
    wr = 1'b1;
    @(negedge clk);
    cs = 1'b1;
  endtask

endmodule