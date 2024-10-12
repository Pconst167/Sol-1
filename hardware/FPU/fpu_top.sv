import pa_fpu::*;

module fpu(
  input  logic arst,
  input  logic clk,
  input  logic [7:0] databus_in,
  output logic [7:0] databus_out,
  input  logic [5:0] addr, 
  input  logic cs,
  input  logic rd,
  input  logic wr,
  input  logic end_ack,      // acknowledge end
  output logic cmd_end,      // end of command / irq
  output logic busy   // active high when an operation is in progress
);

  logic [31:0] operand_a;
  logic [23:0] a_mantissa;
  logic [ 7:0] a_exp;
  logic        a_sign;
  logic [31:0] operand_b;
  logic [23:0] b_mantissa;
  logic [ 7:0] b_exp;
  logic        b_sign;
  logic [31:0] result;
  logic [23:0] result_mantissa;
  logic        result_sign;
  logic [ 7:0] result_exp;
  logic [ 7:0] aexp_no_bias;
  logic [ 7:0] bexp_no_bias;

  logic        aexp_lt_bexp;
  logic        aexp_gt_bexp;
  logic        aexp_eq_bexp;

  logic [ 7:0] ab_exp_diff;
  logic [ 7:0] ba_exp_diff;

  logic [ 7:0] status;
  e_fpu_operation operation; // arithmetic operation to be performed

  logic op_written;

  logic [7:0] aexp_after_adjust;
  logic [7:0] bexp_after_adjust;
  logic [23:0] a_mantissa_after_adjust;
  logic [23:0] b_mantissa_after_adjust;

  pa_fpu::e_fpu_state curr_state_fpu_fsm;
  pa_fpu::e_fpu_state next_state_fpu_fsm;

  assign a_mantissa      = {1'b1, operand_a[22:0]};
  assign a_exp           = operand_a[30:23];
  assign a_sign          = operand_a[31];
  assign b_mantissa      = {1'b1, operand_b[22:0]};
  assign b_exp           = operand_b[30:23];
  assign b_sign          = operand_b[31];
  assign result_mantissa = result[22:0];
  assign result_exp      = result[30:23];
  assign result_sign     = result[31];

  assign aexp_no_bias    = a_exp - 127;
  assign bexp_no_bias    = b_exp - 127;

  assign ab_exp_diff     = aexp_no_bias - bexp_no_bias;
  assign ba_exp_diff     = bexp_no_bias - aexp_no_bias;

  // if aexp < bexp, then increase aexp and right-shift a_mantissa by same number
  // else if aexp > bexp, then increase bexp and right-shift b_mantissa by same number
  // else, exponents are the same and we are ok
  always_comb begin
    aexp_lt_bexp = aexp_no_bias  < bexp_no_bias;
    aexp_gt_bexp = aexp_no_bias  > bexp_no_bias;
    aexp_eq_bexp = aexp_no_bias == bexp_no_bias;
    
    if(aexp_lt_bexp) begin
      aexp_after_adjust = aexp_no_bias + ba_exp_diff;
      a_mantissa_after_adjust = a_mantissa >> ba_exp_diff;
      bexp_after_adjust = bexp_no_bias;
      b_mantissa_after_adjust = b_mantissa;
    end   
    else if(aexp_gt_bexp) begin
      aexp_after_adjust = aexp_no_bias;
      a_mantissa_after_adjust = a_mantissa;
      bexp_after_adjust = bexp_no_bias + ab_exp_diff;
      b_mantissa_after_adjust = b_mantissa >> ab_exp_diff;
    end   
    else begin
      aexp_after_adjust = aexp_no_bias;
      a_mantissa_after_adjust = a_mantissa;
      bexp_after_adjust = bexp_no_bias;
      b_mantissa_after_adjust = b_mantissa;
    end

    if(operation == op_sub) begin
      result[22:0]  = a_mantissa_after_adjust - b_mantissa_after_adjust;
      result[30:23] = aexp_after_adjust + 8'd127;
      // result is negative if: 
      result[31]    = !a_sign && !b_sign && b_mantissa > a_mantissa || a_sign && !b_sign || a_sign && b_sign && a_mantissa > b_mantissa;
    end
    else if(operation == op_add) begin
      result[22:0]  = a_mantissa_after_adjust + b_mantissa_after_adjust;
      result[30:23] = aexp_after_adjust + 8'd127;
      // result is negative if: a is negative and a > b, or b is negative and b > a, or both are negative
      result[31]    = a_sign && a_mantissa > b_mantissa || b_sign && b_mantissa > a_mantissa || a_sign && b_sign;
    end

  end

  always_comb begin
    if(cs == 1'b0 && rd == 1'b0) begin
      case(addr)
        6'h0: databus_out = operand_a[7:0];
        6'h1: databus_out = operand_a[15:8];
        6'h2: databus_out = operand_a[23:16];
        6'h3: databus_out = operand_a[31:24];

        6'h4: databus_out = operand_b[7:0];
        6'h5: databus_out = operand_b[15:8];
        6'h6: databus_out = operand_b[23:16];
        6'h7: databus_out = operand_b[31:24];

        6'h8: databus_out = operation;

        default: databus_out = '0;
      endcase      
    end
    else databus_out = 'z;
  end

  always_latch begin
    if(arst) begin
      operand_a  = '0;
      operand_b  = '0;
      operation  = op_add;  
      op_written = 1'b0;
    end
    else if(cs == 1'b0 && wr == 1'b0) begin
      case(addr)
        6'h0: operand_a[7:0]   = databus_in;
        6'h1: operand_a[15:8]  = databus_in;
        6'h2: operand_a[23:16] = databus_in;
        6'h3: operand_a[31:24] = databus_in;

        6'h4: operand_b[7:0]   = databus_in;
        6'h5: operand_b[15:8]  = databus_in;
        6'h6: operand_b[23:16] = databus_in;
        6'h7: operand_b[31:24] = databus_in;

        6'h8: begin
          operation            = e_fpu_operation'(databus_in[3:0]);
          op_written           = 1'b1;
        end
      endcase      
    end
    else if(
      curr_state_fpu_fsm == pa_fpu::start_add_st ||
      curr_state_fpu_fsm == pa_fpu::start_sub_st ||
      curr_state_fpu_fsm == pa_fpu::start_mul_st ||
      curr_state_fpu_fsm == pa_fpu::start_div_st
    ) 
      op_written = 1'b0;
  end

  always_comb begin
    next_state_fpu_fsm = curr_state_fpu_fsm;

    case(curr_state_fpu_fsm)
      pa_fpu::idle_st: 
        if(op_written && wr)
          case(operation)
            pa_fpu::op_add:
              next_state_fpu_fsm = pa_fpu::start_add_st;
            pa_fpu::op_sub:
              next_state_fpu_fsm = pa_fpu::start_sub_st;
            pa_fpu::op_mul:
              next_state_fpu_fsm = pa_fpu::start_mul_st;
            pa_fpu::op_div:
              next_state_fpu_fsm = pa_fpu::start_div_st;
          endcase

      default:
        next_state_fpu_fsm = pa_fpu::idle_st;
    endcase
  end

  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      cmd_end <= 1'b0;
      status <= '0;
    end
    else begin
      case(next_state_fpu_fsm)
        pa_fpu::start_add_st: begin
          
        end
        default: begin
          
        end
      endcase  

    end
  end

  always_ff @(posedge clk, posedge arst) begin
    if(arst) 
      curr_state_fpu_fsm <= idle_st;
    else 
      curr_state_fpu_fsm <= next_state_fpu_fsm;
  end

endmodule
