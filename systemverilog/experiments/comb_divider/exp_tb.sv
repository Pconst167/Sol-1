`default_nettype none

module comb_divider_tb;

  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] quotient;
  logic [3:0] remainder;

  logic [7:0] c;
  logic [4:0] d;

  initial begin
    a = 4'b1111; // 15 or -1
    b = 4'b0010; // 2
    #10us;

    $display("%b", c);
    $stop;
  end


  assign c = (a)*(b); // 1111 * 2 = 30   00011110

/*
  comb_divider div(
    .a(a),
    .b(b),
    .quotient(quotient),
    .remainder(remainder)
  );
*/
endmodule
