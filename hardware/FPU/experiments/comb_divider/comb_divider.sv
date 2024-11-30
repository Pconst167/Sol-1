module comb_divider(
  input logic [3:0] a,
  input logic [3:0] b,
  output logic [3:0] quotient,
  output logic [3:0] remainder
);

  always_comb begin
    bb = ~{1'b0, b} + 1;
    a_initial = {4'b0, a[3]};

    partial_0 = a_initial + bb;
    quotient[3] = partial_0[4];
    if(quotient[3])
      partial_1 = {2'b0, a[3], a[2]} + bb;
    else 
      partial_1 = {partial_0[2:0], a[2]} + bb;
    quotient[2] = partial_1[4];

    if(quotient[2])
      partial_2 = {1'b0, a[3], a[2], a[1]} + bb;
    else 
      partial_2 = {partial_1[2:0], a[1]} + bb;
    quotient[1] = partial_2[4];

    if(quotient[1])
      partial_3 = {a[3], a[2], a[1], a[0]} + bb;
    else 
      partial_3 = {partial_2[2:0], a[0]} + bb;
    quotient[0] = partial_3[4];

    quotient = ~quotient;

  end

endmodule