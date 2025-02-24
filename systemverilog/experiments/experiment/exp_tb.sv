module exp_tb;

  logic [3:0] a;
  logic [3:0] b;

  logic [4:0] c;
  logic [4:0] d;

  initial begin
    a = 4'b1111; // 15 or -1
    b = 4'b0001; // 1
    #10us;

    $display("%b", c);
    $stop;
  end


  assign c = a+~b; 

endmodule
