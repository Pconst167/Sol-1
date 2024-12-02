// FPU Prototype
// This is an FPU unit that will perform addition, subtraction, multiplication, division, square root, and transcendental functions
// It is written in SystemVerilog here for prototyping purposes, and after that will be built in hardware for the Sol-1 system
//
// Created P. Constantino 2024
//
/*

  dot product:
    a dot b 
    = a0b0 + a1b1 + ... + anbn 
    = |a||b|cos(arg(a,b))

  cross product:
    a cross b 
    = (a2b3 - a3b2)i + (a3b1 - a1b3)j + (a1b2 - a2b1)k
    = |a||b|sin(arg(a,b))n where n is the unit vector normal to both a & b

  sin(x)    = x - x^3/3! + x^5/5! - x^7/7! + ...
  cos(x)    = 1 - x^2/2 + x^4/4! - x^6/6! + ...
  exp(x)    = 1 + x + x^2/2 + x^3/3! + x^4/4! + x^5/5! + ...
  ln(1+x)   = x - x^2/2 + x^3/3 - x^4/4 + x^5/5 - ...
  arctan(x) = x - x^3/3 + x^5/5 - x^7/7 + ... (slow convergence)

*/

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
  input  logic end_ack, // acknowledge end
  output logic cmd_end, // end of command / irq
  output logic busy     // active high when an operation is in progress
);

  logic             [31:0] ieee_packet;

  logic             [31:0] operand_a;
  logic             [25:0] a_mantissa; // 24 bits plus 2 upper guard bits for dealing with signed arithmetic
  logic             [25:0] a_mantissa_adjusted;
  logic             [ 7:0] a_exp;
  logic                    a_sign;
  logic             [31:0] operand_b;
  logic             [25:0] b_mantissa;  // 24 bits plus 2 upper guard bits for dealing with signed arithmetic
  logic             [25:0] b_mantissa_adjusted;
  logic             [ 7:0] b_exp;
  logic                    b_sign;
  logic             [ 7:0] a_exp_no_bias;
  logic             [ 7:0] b_exp_no_bias;
  logic             [ 7:0] ab_exp_diff;
  logic             [ 7:0] ba_exp_diff;

  logic             [ 7:0] a_exp_adjusted;
  logic             [ 7:0] b_exp_adjusted;

  // addition datapath
  logic             [25:0] result_mantissa_add; // 24 bits plus carry
  logic             [ 7:0] result_exp_add;
  logic                    result_sign_add;

  // subtraction datapath
  logic             [25:0] result_mantissa_sub; // 24 bits plus carry
  logic             [ 7:0] result_exp_sub;
  logic                    result_sign_sub;

  // multiplication datapath
  logic             [23:0] result_mantissa_mul;
  logic             [ 7:0] result_exp_mul;
  logic                    result_sign_mul;
  logic             [48:0] product_multiplier;  // keeps the product and multiplier. shifted right till product occupies entire space and multiplier disappears
  logic             [ 4:0] mul_cycle_counter;   // this keeps a count of how many times we have performed the product addition cycle. total = 24.
  // fsm control
  logic                    product_add;
  logic                    product_shift;
  logic                    start_operation_mul_fsm;  // ...
  logic                    operation_done_mul_fsm;   // for handshake between main fsm and multiply fsm

  // division datapath 
  logic             [23:0] result_mantissa_div;
  logic             [ 7:0] result_exp_div;
  logic                    result_sign_div;
  logic             [48:0] remainder_dividend; // 24 bits for quotient, 25 bits for the subtraction register (one more bit needed at MSB position for when dividend < divisor)
                                            // in such a case, the dividend is shifted left until it becomes larger than divisor and subtraction can happen (for fractional divisions)
  // fsm control
  logic              [5:0] div_counter;
  logic                    div_shift;
  logic                    div_set_a0_1;
  logic                    start_operation_div_fsm;  
  logic                    operation_done_div_fsm;   

  // sqrt datapath
  logic             [23:0] sqrt_xn;
  logic             [23:0] sqrt_xnp1;
  logic              [5:0] sqrt_counter;
  logic             [23:0] result_mantissa_sqrt;
  logic             [ 7:0] result_exp_sqrt;
  // fsm control
  logic                    sqrt_div;
  logic                    sqrt_shift;
  logic                    sqrt_add;
  logic                    start_operation_sqrt_fsm;  
  logic                    operation_done_sqrt_fsm;   

  pa_fpu::e_fpu_operations operation; // arithmetic operation to be performed
  logic                    start_operation;

  // other datapath control signals
  logic                    operation_wrt; // when needing to internally change the operator
  pa_fpu::e_fpu_operations new_operation; // arithmetic operation to be performed

  logic                    start_operation_ar_fsm;  // ...
  logic                    operation_done_ar_fsm;   // for handshake between main fsm and arithmetic fsm

  // status
  logic                    a_is_zero;
  logic                    b_is_zero;
  logic                    a_subnormal;
  logic                    b_subnormal;
  logic                    overflow;
  logic                    underflow;
  logic                    NaN;
  logic                    pos_infinity;
  logic                    neg_infinity;

  // fsm states
  pa_fpu::e_main_states    curr_state_main_fsm;
  pa_fpu::e_main_states    next_state_main_fsm;
  pa_fpu::e_arith_states   curr_state_arith_fsm;
  pa_fpu::e_arith_states   next_state_arith_fsm;
  pa_fpu::e_mul_states     curr_state_mul_fsm;
  pa_fpu::e_mul_states     next_state_mul_fsm;
  pa_fpu::e_div_states     curr_state_div_fsm;
  pa_fpu::e_div_states     next_state_div_fsm;
  pa_fpu::e_sqrt_states    curr_state_sqrt_fsm;
  pa_fpu::e_sqrt_states    next_state_sqrt_fsm;

  // ---------------------------------------------------------------------------------------

  assign a_mantissa      = {a_exp != 8'd0, operand_a[22:0]};
  assign a_exp           = operand_a[30:23];
  assign a_sign          = operand_a[31];
  assign b_mantissa      = {b_exp != 8'd0, operand_b[22:0]};
  assign b_exp           = operand_b[30:23];
  assign b_sign          = operand_b[31];

  assign a_exp_no_bias    = a_exp - 127;
  assign b_exp_no_bias    = b_exp - 127;

  assign ab_exp_diff     = a_exp_no_bias - b_exp_no_bias;
  assign ba_exp_diff     = b_exp_no_bias - a_exp_no_bias;

  assign a_is_zero       = a_exp == 8'h00 && a_mantissa == 23'h0;
  assign b_is_zero       = b_exp == 8'h00 && b_mantissa == 23'h0;

  assign a_subnormal     = a_exp == 8'h00 && a_mantissa != 23'h0;
  assign b_subnormal     = b_exp == 8'h00 && b_mantissa != 23'h0;

  // ---------------------------------------------------------------------------------------

  always @(posedge clk, posedge arst) begin
    if(arst) ieee_packet <= '0;
    else if(curr_state_arith_fsm == pa_fpu::arith_result_valid_st) begin
      case(operation)
        op_add: 
          ieee_packet = {result_sign_add, result_exp_add, result_mantissa_add[22:0]};
        op_sub: 
          ieee_packet = {result_sign_sub, result_exp_sub, result_mantissa_sub[22:0]};
        op_mul: 
          ieee_packet = {result_sign_mul, result_exp_mul, result_mantissa_mul[22:0]};
        op_square: 
          ieee_packet = {result_sign_mul, result_exp_mul, result_mantissa_mul[22:0]};
        op_div: 
          ieee_packet = {result_sign_div, result_exp_div, result_mantissa_div[22:0]};
        op_sqrt: 
          ieee_packet = {1'b0, result_exp_sqrt, result_mantissa_sqrt[22:0]};
      endcase
    end
  end

  // ---------------------------------------------------------------------------------------

  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operand_a  <= {1'b0, 8'd127, 23'h0};
      operand_b  <= {1'b0, 8'd127, 23'h0};
      operation  <= op_add;  
      start_operation <= 1'b0;
    end
    else begin
      if(cs == 1'b0 && wr == 1'b0) begin
        case(addr)
          4'h0: operand_a[7:0]   <= databus_in;
          4'h1: operand_a[15:8]  <= databus_in;
          4'h2: operand_a[23:16] <= databus_in;
          4'h3: operand_a[31:24] <= databus_in;

          4'h4: operand_b[7:0]   <= databus_in;
          4'h5: operand_b[15:8]  <= databus_in;
          4'h6: operand_b[23:16] <= databus_in;
          4'h7: operand_b[31:24] <= databus_in;

          4'h8: operation  <= e_fpu_operations'(databus_in[3:0]);
          4'h9: start_operation <= 1'b1;
        endcase      
      end

      if(next_state_main_fsm == pa_fpu::main_wait_st) 
        start_operation <= 1'b0;

      // set operand_a to latest result
      if(next_state_main_fsm == pa_fpu::main_wait_ack_st) 
        operand_a <= ieee_packet;

      if(operation_wrt == 1'b1) 
        operation <= new_operation;
    end
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

        4'h9: databus_out = ieee_packet[7:0];
        4'hA: databus_out = ieee_packet[15:8];
        4'hB: databus_out = ieee_packet[23:16];
        4'hC: databus_out = ieee_packet[31:24];

        default: databus_out = '0;
      endcase      
    end
    else databus_out = 'z;
  end

  // ---------------------------------------------------------------------------------------
  // addition & subtraction combinational datapath

  // if aexp < bexp, then increase aexp and right-shift a_mantissa by same number
  // else if aexp > bexp, then increase bexp and right-shift b_mantissa by same number
  // else, exponents are the same and we are ok
  always_comb begin
    if(a_exp < b_exp) begin
      a_mantissa_adjusted = a_mantissa >> ba_exp_diff;
      a_exp_adjusted      = a_is_zero ? a_exp_no_bias : a_exp_no_bias + ba_exp_diff;

      b_mantissa_adjusted = b_mantissa;
      b_exp_adjusted      = b_exp_no_bias;
    end   
    else if(b_exp < a_exp) begin
      a_mantissa_adjusted = a_mantissa;
      a_exp_adjusted      = a_exp_no_bias;

      b_mantissa_adjusted = b_mantissa >> ab_exp_diff;
      b_exp_adjusted      = b_is_zero ? b_exp_no_bias : b_exp_no_bias + ab_exp_diff;
    end   
    else begin
      a_mantissa_adjusted = a_mantissa;
      a_exp_adjusted      = a_exp_no_bias;
      b_mantissa_adjusted = b_mantissa;
      b_exp_adjusted      = b_exp_no_bias;
    end
    // the _adjusted variables are used for add and sub operations only
    // negate mantissas if signs are negative
    if(a_sign == 1'b1) a_mantissa_adjusted = ~a_mantissa_adjusted + 1;
    if(b_sign == 1'b1) b_mantissa_adjusted = ~b_mantissa_adjusted + 1;
  end

  // addition datapath
  always_comb begin
    result_mantissa_add = a_mantissa_adjusted + b_mantissa_adjusted;
    if(result_mantissa_add[25:0] == 26'd0) begin
      result_exp_add  = 8'd0; 
      result_sign_add = 1'b0;
    end
    else begin
      if(!a_is_zero) result_exp_add = a_exp_adjusted;
      else result_exp_add = b_exp_adjusted;
      result_sign_add = result_mantissa_add[25];
      if(result_sign_add) result_mantissa_add = -result_mantissa_add;
      if(result_mantissa_add[25]) begin
        result_mantissa_add = result_mantissa_add >> 2;
        result_exp_add = result_exp_add + 2;
      end
      else if(result_mantissa_add[24]) begin
        result_mantissa_add = result_mantissa_add >> 1;
        result_exp_add = result_exp_add + 1;
      end
      else if(result_mantissa_add[23:0] != 24'h0)
        while(!result_mantissa_add[23]) begin
          result_mantissa_add = result_mantissa_add << 1;
          result_exp_add = result_exp_add - 1;
        end
      result_exp_add = result_exp_add + 8'd127;
    end
  end

  // subtraction datapath
  always_comb begin
    result_mantissa_sub = a_mantissa_adjusted - b_mantissa_adjusted;
    if(result_mantissa_sub[25:0] == 26'd0) begin
      result_exp_sub = 8'd0; 
      result_sign_sub = 1'b0;
    end
    else begin
      if(!a_is_zero) result_exp_sub = a_exp_adjusted;
      else result_exp_sub = b_exp_adjusted;
      result_sign_sub = result_mantissa_sub[25];
      if(result_sign_sub) result_mantissa_sub = -result_mantissa_sub;
      if(result_mantissa_sub[25]) begin
        result_mantissa_sub = result_mantissa_sub >> 2;
        result_exp_sub = result_exp_sub + 2;
      end
      else if(result_mantissa_sub[24]) begin
        result_mantissa_sub = result_mantissa_sub >> 1;
        result_exp_sub = result_exp_sub + 1;
      end
      else if(result_mantissa_sub[23:0] != 24'h0)
        while(!result_mantissa_sub[23]) begin
          result_mantissa_sub = result_mantissa_sub << 1;
          result_exp_sub = result_exp_sub - 1;
        end
      result_exp_sub = result_exp_sub + 8'd127;
    end
  end

  // ---------------------------------------------------------------------------------------

  // multiplication datapath
  always @(posedge clk, posedge arst) begin
    if(arst) begin
      product_multiplier <= '0;
      mul_cycle_counter  <= '0;
    end
    else begin
      if(product_add) begin
        if(product_multiplier[0]) product_multiplier[48:24] <= product_multiplier[48:24] + a_mantissa[23:0]; // product_multiplier is 49 bits rather than 48 so it can also keep the carry out
        mul_cycle_counter <= mul_cycle_counter + 5'd1; // increment counter here so that we can check the counter value in the next state. otherwise would need an extra state after shift_st to check counter == 16.
      end
      if(product_shift) product_multiplier <= product_multiplier >> 1;
      if(next_state_mul_fsm == pa_fpu::mul_start_st) begin
        mul_cycle_counter  <= '0;
        product_multiplier <= {25'b0, b_mantissa[23:0]};  // initiate register, copy b_mantissa, as the multiplier
      end
      // this is tested on current state rather than next state because when the fsm reaches mul_result_set_st, the shift operation is clocked in 
      if(curr_state_mul_fsm == pa_fpu::mul_result_set_st) begin
        automatic logic [23:0] m = product_multiplier[47:24];
        automatic logic [7:0]  e = a_exp_no_bias + b_exp_no_bias + 8'd127;
        result_sign_mul <= a_sign ^ b_sign;
        if(m[23] == 1'b1) e = e + 8'd1;    // if MSB is 1, then increment exp by one to normalize because in this case, we have two digits before the decimal point, 
                                           // and so really the result we had was 10.xxx or 11.xxx for example, and so the final exponent needs to be incremented
        else if(m[23] == 1'b0) m = m << 1; // if the MSB of result is a 0, then shift left the result to normalize. in this case, nothing is changed in the mantissa 
                                           // or exponent. we only shift here because of the way we are copying the mantissa from the result variable to the final packet.
        result_exp_mul <= e;
        result_mantissa_mul <= m;
        end
    end
  end

  // ---------------------------------------------------------------------------------------

  // main fsm
  // next state assignments
  always_comb begin
    next_state_main_fsm = curr_state_main_fsm;

    case(curr_state_main_fsm)
      pa_fpu::main_idle_st: 
        if(start_operation) next_state_main_fsm = pa_fpu::main_wait_st;
      
      pa_fpu::main_wait_st: 
        if(operation_done_ar_fsm == 1'b1) next_state_main_fsm = pa_fpu::main_finish_st;

      pa_fpu::main_finish_st:
        if(operation_done_ar_fsm == 1'b0) next_state_main_fsm = pa_fpu::main_wait_ack_st;

      pa_fpu::main_wait_ack_st:
        if(end_ack == 1'b1) next_state_main_fsm = pa_fpu::main_idle_st;

      default:
        next_state_main_fsm = pa_fpu::main_idle_st;
    endcase
  end

  // main fsm
  // output assignments
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      start_operation_ar_fsm <= 1'b0;
      cmd_end                <= 1'b0;             
      busy                   <= 1'b0;         
    end
    else begin
      case(next_state_main_fsm)
        pa_fpu::main_idle_st: begin
          start_operation_ar_fsm <= 1'b0;
          cmd_end                <= 1'b0;             
          busy                   <= 1'b0;         
        end
        pa_fpu::main_wait_st: begin
          start_operation_ar_fsm <= 1'b1;
          cmd_end                <= 1'b0;             
          busy                   <= 1'b1;         
        end
        pa_fpu::main_finish_st: begin
          start_operation_ar_fsm <= 1'b0;
          cmd_end                <= 1'b0;             
          busy                   <= 1'b1;         
        end
        pa_fpu::main_wait_ack_st: begin
          start_operation_ar_fsm <= 1'b0;
          cmd_end                <= 1'b1;             
          busy                   <= 1'b1;         
        end
      endcase  
    end
  end

  // ---------------------------------------------------------------------------------------

  // arithmetic fsm
  // next state assignments
  always_comb begin
    next_state_arith_fsm = curr_state_arith_fsm;

    case(curr_state_arith_fsm)
      pa_fpu::arith_idle_st: 
        if(start_operation_ar_fsm)
          case(operation)
            pa_fpu::op_add:
              next_state_arith_fsm = pa_fpu::arith_add_st;
            pa_fpu::op_sub:
              next_state_arith_fsm = pa_fpu::arith_sub_st;
            pa_fpu::op_mul:
              next_state_arith_fsm = pa_fpu::arith_mul_st;
            pa_fpu::op_div:
              next_state_arith_fsm = pa_fpu::arith_div_st;
          endcase

      pa_fpu::arith_add_st:
        next_state_arith_fsm = arith_result_valid_st;

      pa_fpu::arith_sub_st:
        next_state_arith_fsm = arith_result_valid_st;

      pa_fpu::arith_mul_st:
        if(operation_done_mul_fsm == 1'b1) next_state_arith_fsm = pa_fpu::arith_mul_done_st;
      pa_fpu::arith_mul_done_st:
        if(operation_done_mul_fsm == 1'b0) next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_div_st:
        if(operation_done_div_fsm == 1'b1) next_state_arith_fsm = pa_fpu::arith_div_done_st;
      pa_fpu::arith_div_done_st:
        if(operation_done_div_fsm == 1'b0) next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_result_valid_st:
        if(start_operation_ar_fsm == 1'b0) next_state_arith_fsm = pa_fpu::arith_idle_st;

      default:
        next_state_arith_fsm = pa_fpu::arith_idle_st;
    endcase
  end

  // arithmetic fsm
  // output assignments
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operation_done_ar_fsm <= 1'b0;
      start_operation_mul_fsm <= 1'b0;
    end
    else begin
      case(next_state_arith_fsm)
        pa_fpu::arith_idle_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
        end
        pa_fpu::arith_add_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
        end
        pa_fpu::arith_sub_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
        end
        pa_fpu::arith_mul_st: begin
          operation_done_ar_fsm   <= 1'b0;
          start_operation_mul_fsm <= 1'b1;
        end
        pa_fpu::arith_mul_done_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
        end
        pa_fpu::arith_div_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_div_fsm <= 1'b1;
        end
        pa_fpu::arith_div_done_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_div_fsm <= 1'b0;
        end
        pa_fpu::arith_result_valid_st: begin
          operation_done_ar_fsm <= 1'b1;
          start_operation_mul_fsm <= 1'b0;
        end
      endcase  
    end
  end

  // ---------------------------------------------------------------------------------------

  // multiply fsm
  // next state assignments
  always_comb begin
    next_state_mul_fsm = curr_state_mul_fsm;

    case(curr_state_mul_fsm)
      pa_fpu::mul_idle_st: 
        if(start_operation_mul_fsm) next_state_mul_fsm = pa_fpu::mul_start_st;

      pa_fpu::mul_start_st:
        next_state_mul_fsm = pa_fpu::mul_product_add_st;
      
      pa_fpu::mul_product_add_st:
        next_state_mul_fsm = pa_fpu::mul_product_shift_st;
      
      pa_fpu::mul_product_shift_st:
        if(mul_cycle_counter == 5'd24) next_state_mul_fsm = mul_result_set_st;
        else next_state_mul_fsm = mul_product_add_st;
      
      pa_fpu::mul_result_set_st:
        next_state_mul_fsm = pa_fpu::mul_result_valid_st;
      
      pa_fpu::mul_result_valid_st:
        if(start_operation_mul_fsm == 1'b0) next_state_mul_fsm = pa_fpu::mul_idle_st;

      default:
        next_state_mul_fsm = pa_fpu::mul_idle_st;
    endcase
  end

  // multiply fsm
  // output assignments
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operation_done_mul_fsm <= 1'b0;
      product_add            <= 1'b0;
      product_shift          <= 1'b0;
    end
    else begin
      case(next_state_mul_fsm)
        pa_fpu::mul_idle_st: begin
          operation_done_mul_fsm <= 1'b0;
          product_add           <= 1'b0;
          product_shift         <= 1'b0;
        end
        pa_fpu::mul_start_st: begin
          operation_done_mul_fsm <= 1'b0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::mul_product_add_st: begin
          operation_done_mul_fsm <= 1'b0;
          product_add <= 1'b1;
          product_shift <= 1'b0;
        end
        pa_fpu::mul_product_shift_st: begin
          operation_done_mul_fsm <= 1'b0;
          product_add <= 1'b0;
          product_shift <= 1'b1;
        end
        pa_fpu::mul_result_set_st: begin
          operation_done_mul_fsm <= 1'b0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
        pa_fpu::mul_result_valid_st: begin
          operation_done_mul_fsm <= 1'b1;
          product_add <= 1'b0;
          product_shift <= 1'b0;
        end
      endcase  
    end
  end

  // ------------------------------------------------------------------------------------------------

  // division datapath
  always @(posedge clk, posedge arst) begin
    if(arst) begin
      remainder_dividend <= '0;
      div_counter        <= '0;
    end
    else begin
      if(next_state_div_fsm == pa_fpu::div_start_st) begin
        div_counter <= 24;
        remainder_dividend <= {2'b00, a_mantissa[23:0], 23'd0}; // dividend in lower half
      end
      if(div_shift) 
        remainder_dividend <= remainder_dividend << 1;
      if(div_set_a0_1) begin
        remainder_dividend[0] <= 1'b1;
        remainder_dividend[48:24] <= {1'b0, remainder_dividend[48:24]} + ~{2'b00, b_mantissa[23:0]} + 26'b1;
      end
      if(next_state_div_fsm == pa_fpu::div_sub_divisor_test_st)  
        div_counter <= div_counter - 1;
      if(curr_state_div_fsm == pa_fpu::div_result_valid_st) begin
        automatic logic [7:0] e = a_exp_no_bias - b_exp_no_bias + 8'd127;
        automatic logic [23:0] m = remainder_dividend[23:0];
        result_sign_div <= a_sign ^ b_sign;
        while(m[23] == 1'b0) begin
          m = m << 1;
          e = e - 1;
        end
        result_exp_div <= e;
        result_mantissa_div <= m;
      end
    end
  end

  // divide fsm
  // next state assignments
  always_comb begin
    next_state_div_fsm = curr_state_div_fsm;

    case(curr_state_div_fsm)
      pa_fpu::div_idle_st: 
        if(start_operation_div_fsm) next_state_div_fsm = pa_fpu::div_start_st;

      pa_fpu::div_start_st:
        next_state_div_fsm = pa_fpu::div_shift_st;
      
      pa_fpu::div_shift_st:
        next_state_div_fsm = pa_fpu::div_sub_divisor_test_st;
      
      pa_fpu::div_sub_divisor_test_st: begin
        automatic logic [25:0] intermediary = {1'b0, remainder_dividend[48:24]} + (~{2'b00, b_mantissa[23:0]} + 26'b1);
        if(intermediary[25] == 1'b1) next_state_div_fsm = pa_fpu::div_check_counter_st; // result is negative
        else next_state_div_fsm = pa_fpu::div_set_a0_1_st; // result is positive
      end
      
      pa_fpu::div_set_a0_1_st:
        next_state_div_fsm = pa_fpu::div_check_counter_st;

      pa_fpu::div_check_counter_st:
        if(div_counter == 6'h0) next_state_div_fsm = pa_fpu::div_result_valid_st;
        else next_state_div_fsm = pa_fpu::div_shift_st;
      
      pa_fpu::div_result_valid_st:
        if(start_operation_div_fsm == 1'b0) next_state_div_fsm = pa_fpu::div_idle_st;

      default:
        next_state_div_fsm = pa_fpu::div_idle_st;
    endcase
  end

  // divide fsm
  // output assignments
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operation_done_div_fsm <= 1'b0;
      div_shift              <= 1'b0;
      div_set_a0_1           <= 1'b0;
    end
    else begin
      case(next_state_div_fsm)
        pa_fpu::div_idle_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        pa_fpu::div_start_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        pa_fpu::div_shift_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b1;
          div_set_a0_1           <= 1'b0;
        end
        pa_fpu::div_sub_divisor_test_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        pa_fpu::div_set_a0_1_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_a0_1           <= 1'b1;
        end
        pa_fpu::div_check_counter_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        pa_fpu::div_result_valid_st: begin
          operation_done_div_fsm <= 1'b1;
          div_shift              <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
      endcase  
    end
  end

  // ------------------------------------------------------------------------------------------------
  // sqrt datapath signals
  //          [23:0] sqrt_xn;
  //          [23:0] sqrt_xnp1;
  //           [5:0] sqrt_counter;
  //                 sqrt_div;
  //                 sqrt_shift;
  //                 sqrt_add;
  //                 start_operation_sqrt_fsm;  
  //                 operation_done_sqrt_fsm;   
  // xnp1 = 0.5 * (xn + a/xn)
  // set initial xn guess to a itself
  // activate division fsm of a/xn
  // set b_mantissa = division result
  // set a_mantissa = xn
  // perform addition via add fsm
  // set xn = addition result
  // shift xn right by one
  // decrease counter
  // if count > 0 then goto division step

  // sqrt datapath
  always @(posedge clk, posedge arst) begin
    if(arst) begin
      sqrt_xn <= '0;
      sqrt_xnp1 <= '0;
      sqrt_counter <= '0;
    end
    else begin
      if(next_state_sqrt_fsm == pa_fpu::sqrt_start_st) begin
        sqrt_xn <= a_mantissa[23:0];
        sqrt_counter <= 10;
      end
      if(sqrt_shift) begin
        sqrt_xn <= sqrt_xn >> 1;
        sqrt_counter <= sqrt_counter - 1;
      end
      if(curr_state_sqrt_fsm == pa_fpu::sqrt_result_valid_st) begin
        result_mantissa_sqrt <= sqrt_xnp1;
      end
    end
  end

  // xnp1 = 0.5 * (xn + A/xn)
  // set initial xn guess to a itself
  // activate division fsm of A/xn
  // set a_mantissa = xn
  // set b_mantissa = division result
  // perform addition via add fsm
  // set xn = addition result
  // shift xn right by one
  // decrease counter
  // if count > 0 then goto division step
  // sqrt datapath signals

  // sqrt fsm
  // next state assignments
  always_comb begin
    next_state_sqrt_fsm = curr_state_sqrt_fsm;

    case(curr_state_sqrt_fsm)
      pa_fpu::sqrt_idle_st: 
        if(start_operation_sqrt_fsm) next_state_sqrt_fsm = pa_fpu::sqrt_start_st;

      // set xn to initial guess = a itself
      // set counter for number of steps = 10
      pa_fpu::sqrt_start_st: 
        next_state_sqrt_fsm = pa_fpu::sqrt_shift_st;

      // set a_mantissa = A
      // set b_mantissa = xn
      pa_fpu::sqrt_div_setup_st: begin
        next_state_sqrt_fsm = pa_fpu::sqrt_wait_div_done_st;
      end
      // wait for division to complete.
      pa_fpu::sqrt_wait_div_done_st: begin
        if(operation_done_div_fsm) next_state_sqrt_fsm = pa_fpu::sqrt_addition_st;
        else next_state_sqrt_fsm = pa_fpu::sqrt_wait_div_done_st;
      end
      // set a_mantissa <= xn
      // set b_mantissa <= result_mantissa_div
      pa_fpu::sqrt_addition_st: begin
        
      end
      
      pa_fpu::sqrt_shift_st: begin
        
      end
      
      pa_fpu::sqrt_check_counter_st:
        if(sqrt_counter == 6'h0) next_state_sqrt_fsm = pa_fpu::sqrt_result_valid_st;
        else next_state_sqrt_fsm = pa_fpu::sqrt_div_setup_st;
      
      pa_fpu::sqrt_result_valid_st:
        if(start_operation_sqrt_fsm == 1'b0) next_state_sqrt_fsm = pa_fpu::sqrt_idle_st;

      default:
        next_state_sqrt_fsm = pa_fpu::sqrt_idle_st;
    endcase
  end

  // sqrt fsm
  // output assignments
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operation_done_sqrt_fsm <= 1'b0;
      sqrt_shift              <= 1'b0;
    end
    else begin
      case(next_state_sqrt_fsm)
        pa_fpu::sqrt_idle_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_shift              <= 1'b0;
        end
        pa_fpu::sqrt_start_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_shift              <= 1'b0;
        end
        pa_fpu::sqrt_shift_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_shift              <= 1'b1;
        end
        pa_fpu::sqrt_check_counter_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_shift              <= 1'b0;
        end
        pa_fpu::sqrt_result_valid_st: begin
          operation_done_sqrt_fsm <= 1'b1;
          sqrt_shift              <= 1'b0;
        end
      endcase  
    end
  end

  // main fsm
  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) curr_state_main_fsm <= main_idle_st;
    else curr_state_main_fsm <= next_state_main_fsm;
  end

  // arithmetic fsm
  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) curr_state_arith_fsm <= arith_idle_st;
    else curr_state_arith_fsm <= next_state_arith_fsm;
  end

  // multiply fsm
  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) curr_state_mul_fsm <= mul_idle_st;
    else curr_state_mul_fsm <= next_state_mul_fsm;
  end

  // divide fsm
  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) curr_state_div_fsm <= div_idle_st;
    else curr_state_div_fsm <= next_state_div_fsm;
  end

  // sqrt fsm
  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) curr_state_sqrt_fsm <= sqrt_idle_st;
    else curr_state_sqrt_fsm <= next_state_sqrt_fsm;
  end

endmodule