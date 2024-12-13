module comb_divider(
  input logic [3:0] a,
  input logic [3:0] b,
  output logic [3:0] quotient,
  output logic [3:0] remainder
);
  logic [4:0] bb;
  logic [4:0] partial;

  always_comb begin
    bb = {1'b0, ~b} + 5'b1;

    partial = {4'b0, a[3]} + bb;
    quotient[3] = partial[4];
    if(quotient[3])
      partial = {1'b0, partial[2:0], a[2]};
    else begin
      partial = partial - bb;
      partial = {1'b0, partial[2:0], a[2]};
    end

    partial = partial + bb;

    quotient[2] = partial[4];
    if(quotient[2])
      partial = {1'b0, partial[2:0], a[1]};
    else begin
      partial = partial - bb;
      partial = {1'b0, partial[2:0], a[1]};
    end

    partial = partial + bb;

    quotient[1] = partial[4];
    if(quotient[1])
      partial = {1'b0, partial[2:0], a[0]};
    else begin
      partial = partial - bb;
      partial = {1'b0, partial[2:0], a[0]};
    end

    partial = partial + bb;

    quotient[0] = partial[4];

    if(!quotient[0]) begin
      partial = partial - bb;
    end
    remainder   = partial[3:0];

  end

endmodule

