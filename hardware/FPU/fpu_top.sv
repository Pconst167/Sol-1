// FPU Prototype
// This is an FPU unit that will perform addition, subtraction, multiplication, division, square root, and transcendental functions
// It is written in SystemVerilog here for prototyping purposes, and after that will be built in hardware for the Sol-1 system
//
// Created P Const 2024
// x - x^3/3! + x^5/5! - x^7/7! + x^9/9!


import pa_fpu::*;

module fpu(
  input  logic arst,
  input  logic clk,
  input  logic [7:0] databus_in,
  output logic [7:0] databus_out,
  input  logic [3:0] addr, 
  input  logic cs,
  input  logic rd,
  input  logic wr,
  input  logic end_ack,      // acknowledge end
  output logic cmd_end,      // end of command / irq
  output logic busy   // active high when an operation is in progress
);

  logic          [31:0] operand_a;
  logic unsigned [25:0] a_mantissa;
  logic          [ 7:0] a_exp;
  logic                 a_sign;
  logic          [31:0] operand_b;
  logic unsigned [25:0] b_mantissa;
  logic          [ 7:0] b_exp;
  logic                 b_sign;
  logic          [ 7:0] aexp_no_bias;
  logic          [ 7:0] bexp_no_bias;
  logic          [ 7:0] ab_exp_diff;
  logic          [ 7:0] ba_exp_diff;

  logic          [31:0] result_ieee_packet;

  logic          [25:0] result_mantissa_before_inv;
  logic          [25:0] result_mantissa_before_shift1;
  logic          [25:0] result_mantissa_before_shift2;
  logic unsigned [25:0] result_mantissa_add_sub; // 24 bits plus carry
  logic          [ 7:0] result_exp_add_sub;
  logic                 result_sign_add_sub;
  logic unsigned [23:0] result_mantissa_multiplication;
  logic          [ 7:0] result_exp_multiplication;
  logic                 result_sign_multiplication;
  logic unsigned [47:0] result_mantissa_division;
  logic          [ 7:0] result_exp_division;
  logic                 result_sign_division;

  logic          [ 7:0] aexp_after_adjust;
  logic          [ 7:0] bexp_after_adjust;
  logic          [25:0] a_mantissa_after_adjust;
  logic          [25:0] b_mantissa_after_adjust;

  logic          [23:0] dividend;
  logic          [48:0] product_divisor;  // keeps the product and divisor. shifted right till product occupies entire space and divisor disappears
  logic          [ 4:0] divisor_counter;   // this keeps a count of how many times we have performed the product addition cycle. total = 24.

  logic          [ 7:0] status;
  e_fpu_operation       operation; // arithmetic operation to be performed
  logic                 op_written;
  logic                 overflow;

  // multiplication datapath control signals
  logic                 product_add;
  logic                 product_shift;

  pa_fpu::e_fpu_state   curr_state_fpu_fsm;
  pa_fpu::e_fpu_state   next_state_fpu_fsm;

  assign a_mantissa      = {!(a_exp == 8'd0), operand_a[22:0]};
  assign a_exp           = operand_a[30:23];
  assign a_sign          = operand_a[31];
  assign b_mantissa      = {!(b_exp == 8'd0), operand_b[22:0]};
  assign b_exp           = operand_b[30:23];
  assign b_sign          = operand_b[31];

  assign aexp_no_bias    = a_exp - 127;
  assign bexp_no_bias    = b_exp - 127;

  assign ab_exp_diff     = aexp_no_bias - bexp_no_bias;
  assign ba_exp_diff     = bexp_no_bias - aexp_no_bias;

  // latch for writing operation registers
  always_latch begin
    if(arst) begin
      operand_a  = {1'b0, 8'd127, 23'h0};
      operand_b  = {1'b0, 8'd127, 23'h0};
      operation  = op_add;  
      op_written = 1'b0;
    end
    else if(cs == 1'b0 && wr == 1'b0) begin
      case(addr)
        4'h0: operand_a[7:0]   = databus_in;
        4'h1: operand_a[15:8]  = databus_in;
        4'h2: operand_a[23:16] = databus_in;
        4'h3: operand_a[31:24] = databus_in;

        4'h4: operand_b[7:0]   = databus_in;
        4'h5: operand_b[15:8]  = databus_in;
        4'h6: operand_b[23:16] = databus_in;
        4'h7: operand_b[31:24] = databus_in;

        4'h8: begin
          operation            = e_fpu_operation'(databus_in[3:0]);
          op_written           = 1'b1;
        end
      endcase      
    end
    else if(
      curr_state_fpu_fsm == pa_fpu::add_start_st ||
      curr_state_fpu_fsm == pa_fpu::sub_start_st ||
      curr_state_fpu_fsm == pa_fpu::mul_start_st ||
      curr_state_fpu_fsm == pa_fpu::div_start_st
    ) 
      op_written = 1'b0;
  end

  // output bus assignments
  always_comb begin
    if(cs == 1'b0 && rd == 1'b0) begin
      case(addr)
        4'h0: databus_out = operand_a[7:0];
        4'h1: databus_out = operand_a[15:8];
        4'h2: databus_out = operand_a[23:16];
        4'h3: databus_out = operand_a[31:24];

        4'h4: databus_out = operand_b[7:0];
        4'h5: databus_out = operand_b[15:8];
        4'h6: databus_out = operand_b[23:16];
        4'h7: databus_out = operand_b[31:24];

        4'h8: databus_out = operation;

        4'h9: databus_out = result_ieee_packet[7:0];
        4'hA: databus_out = result_ieee_packet[15:8];
        4'hB: databus_out = result_ieee_packet[23:16];
        4'hC: databus_out = result_ieee_packet[31:24];

        default: databus_out = '0;
      endcase      
    end
    else databus_out = 'z;
  end

  // if aexp < bexp, then increase aexp and right-shift a_mantissa by same number
  // else if aexp > bexp, then increase bexp and right-shift b_mantissa by same number
  // else, exponents are the same and we are ok
  always_comb begin
    if(aexp_no_bias < bexp_no_bias) begin
      a_mantissa_after_adjust = a_mantissa >> ba_exp_diff;
      b_mantissa_after_adjust = b_mantissa;
      aexp_after_adjust       = aexp_no_bias + ba_exp_diff;
      bexp_after_adjust       = bexp_no_bias;
    end   
    else if(aexp_no_bias > bexp_no_bias) begin
      a_mantissa_after_adjust = a_mantissa;
      b_mantissa_after_adjust = b_mantissa >> ab_exp_diff;
      aexp_after_adjust       = aexp_no_bias;
      bexp_after_adjust       = bexp_no_bias + ab_exp_diff;
    end   
    else begin
      a_mantissa_after_adjust = a_mantissa;
      b_mantissa_after_adjust = b_mantissa;
      aexp_after_adjust       = aexp_no_bias;
      bexp_after_adjust       = bexp_no_bias;
    end

    // the _after_adjust variables are used for add and sub operations only
    if(a_sign == 1'b1) a_mantissa_after_adjust = ~a_mantissa_after_adjust + 1;
    if(b_sign == 1'b1) b_mantissa_after_adjust = ~b_mantissa_after_adjust + 1;

    // addition & subtraction
    if(operation == op_add) result_mantissa_add_sub = a_mantissa_after_adjust + b_mantissa_after_adjust;
    else if(operation == op_sub) result_mantissa_add_sub = a_mantissa_after_adjust - b_mantissa_after_adjust;
    if(result_mantissa_add_sub[23:0] == 23'd0) begin
      result_exp_add_sub = 8'd0; 
      result_sign_add_sub = 1'b0;
    end
    else begin
      result_exp_add_sub = aexp_after_adjust;
      result_mantissa_before_shift1=result_mantissa_add_sub;
      result_sign_add_sub = result_mantissa_add_sub[25];
      if(result_mantissa_add_sub[25]) begin
        result_mantissa_add_sub = result_mantissa_add_sub >> 2;
        result_exp_add_sub = result_exp_add_sub + 2;
      end
      else if(result_mantissa_add_sub[24]) begin
        result_mantissa_add_sub = result_mantissa_add_sub >> 1;
        result_exp_add_sub = result_exp_add_sub + 1;
      end
      result_mantissa_before_inv=result_mantissa_add_sub;
      if(result_sign_add_sub) result_mantissa_add_sub = -result_mantissa_add_sub;
      result_mantissa_before_shift2=result_mantissa_add_sub;
      if(|result_mantissa_add_sub[23:0]) begin // if there is at least one non zero bit, then perform while loop. this needs to be tested otherwise the loop is infinite.
         while(!result_mantissa_add_sub[23]) begin
           result_mantissa_add_sub = result_mantissa_add_sub << 1;
           result_exp_add_sub = result_exp_add_sub - 1;
         end
      end
      result_exp_add_sub = result_exp_add_sub + 8'd127;
    end
  end

  always @(posedge clk, posedge arst) begin
    if(arst) begin
      result_ieee_packet <= '0;
    end
    else if(curr_state_fpu_fsm == pa_fpu::result_valid_st) begin
      case(operation)
        op_add: 
          result_ieee_packet = {result_sign_add_sub, result_exp_add_sub, result_mantissa_add_sub[22:0]};
        op_sub: 
          result_ieee_packet = {result_sign_add_sub, result_exp_add_sub, result_mantissa_add_sub[22:0]};
        op_mul: 
          result_ieee_packet = {result_sign_multiplication, result_exp_multiplication, result_mantissa_multiplication[22:0]};
        op_div: 
          result_ieee_packet = {result_sign_division, result_exp_division, result_mantissa_division[22:0]};
      endcase
    end
  end

  always @(posedge clk, posedge arst) begin
    if(arst) begin
      dividend         <= '0;
      product_divisor  <= '0;
      divisor_counter  <= '0;
    end
    else begin
      if(product_add) begin
        if(product_divisor[0]) product_divisor[48:24] <= product_divisor[48:24] + dividend; // product_divisor is 49 bits rather than 48 so it can also keep the carry out
        divisor_counter <= divisor_counter + 5'd1; // increment counter here so that we can check the counter value in the next state. otherwise would need an extra state after shift_st to check counter == 16.
      end
      if(product_shift) product_divisor <= product_divisor >> 1;
      if(next_state_fpu_fsm == pa_fpu::mul_start_st) begin
        divisor_counter <= '0;
        dividend        <= a_mantissa[23:0];
        product_divisor <= {25'b0, b_mantissa[23:0]};  // initiate register, copy b_mantissa, as the divisor
      end
      // this is tested on current state rather than next state because when the fsm reaches mul_result_set_st, the shift operation is clocked in 
      if(curr_state_fpu_fsm == pa_fpu::mul_result_set_st) begin
        result_mantissa_multiplication = product_divisor[47:24];
        result_exp_multiplication  = aexp_no_bias + bexp_no_bias;
        result_sign_multiplication = a_sign ^ b_sign;
        if(result_mantissa_multiplication[23] == 1'b1) begin
          result_exp_multiplication = result_exp_multiplication + 8'd1; // if MSB is 1, then increment exp by one to normalize because in this case, we have two digits before the decimal point, and so really the result we had was 10.xxx or 11.xxx for example, and so the final result needs to be multiplied by 2
        end
        else if(result_mantissa_multiplication[23] == 1'b0) begin
          result_mantissa_multiplication = result_mantissa_multiplication << 1; // if the MSB of result is a 0, then shift left the result to normalize. in this case, nothing is changed in the mantissa or exponent. we only shift here because of the way we are copying the mantissa from the result variable to the final packet.
        end
        result_exp_multiplication = result_exp_multiplication + 8'd127; // normalize exponent
        end
    end
  end

  // Next state assignments
  always_comb begin
    next_state_fpu_fsm = curr_state_fpu_fsm;

    case(curr_state_fpu_fsm)
      pa_fpu::idle_st: 
        if(op_written)
          case(operation)
            pa_fpu::op_add:
              next_state_fpu_fsm = pa_fpu::add_start_st;
            pa_fpu::op_sub:
              next_state_fpu_fsm = pa_fpu::sub_start_st;
            pa_fpu::op_mul:
              next_state_fpu_fsm = pa_fpu::mul_start_st;
            pa_fpu::op_div:
              next_state_fpu_fsm = pa_fpu::div_start_st;
          endcase

      // addition states **********************************
      pa_fpu::add_start_st:
        next_state_fpu_fsm = result_valid_st;

      // subtraction states **********************************
      pa_fpu::sub_start_st:
        next_state_fpu_fsm = result_valid_st;

      // multiplication states **********************************
      pa_fpu::mul_start_st:
        next_state_fpu_fsm = pa_fpu::mul_product_add_st;
      pa_fpu::mul_product_add_st:
        next_state_fpu_fsm = pa_fpu::mul_product_shift_st;
      pa_fpu::mul_product_shift_st:
        if(divisor_counter == 5'd24) next_state_fpu_fsm = mul_result_set_st;
        else next_state_fpu_fsm = mul_product_add_st;
      pa_fpu::mul_result_set_st:
        next_state_fpu_fsm = pa_fpu::result_valid_st;

      // division states **********************************
      pa_fpu::div_start_st:
        next_state_fpu_fsm = pa_fpu::result_valid_st;

      pa_fpu::result_valid_st:
        if(end_ack == 1'b1) next_state_fpu_fsm = pa_fpu::idle_st;

      default:
        next_state_fpu_fsm = pa_fpu::idle_st;
    endcase
  end

  // Output assignments
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      cmd_end <= 1'b0;
      busy    <= 1'b0;
      status  <= '0;
      product_add <= 1'b0;
      product_shift <= 1'b0;
    end
    else begin
      case(next_state_fpu_fsm)
        pa_fpu::idle_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b0;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::add_start_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b0;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::sub_start_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b0;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::mul_start_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::mul_product_add_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
          product_add <= 1'b1;
          product_shift <= 1'b0;
        end
        pa_fpu::mul_product_shift_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b1;
        end
        pa_fpu::mul_result_set_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::div_start_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::div_end_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::result_valid_st: begin
          cmd_end <= 1'b1;
          busy    <= 1'b1;         
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
      endcase  
    end
  end

  // Next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst)  curr_state_fpu_fsm <= idle_st;
    else  curr_state_fpu_fsm <= next_state_fpu_fsm;
  end

endmodule