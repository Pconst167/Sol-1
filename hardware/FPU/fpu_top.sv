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
  logic signed   [ 7:0] a_exp;
  logic                 a_sign;
  logic          [31:0] operand_b;
  logic unsigned [25:0] b_mantissa;
  logic signed   [ 7:0] b_exp;
  logic                 b_sign;
  logic signed   [ 7:0] aexp_no_bias;
  logic signed   [ 7:0] bexp_no_bias;
  logic signed   [ 7:0] ab_exp_diff;
  logic signed   [ 7:0] ba_exp_diff;

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

  logic                 a_is_zero;
  logic                 b_is_zero;

  logic          [23:0] multiplicand;
  logic          [48:0] product_multiplier;  // keeps the product and multiplier. shifted right till product occupies entire space and multiplier disappears
  logic          [ 4:0] mul_cycle_counter;   // this keeps a count of how many times we have performed the product addition cycle. total = 24.

  logic          [ 7:0] status;
  e_fpu_operation       operation; // arithmetic operation to be performed
  logic                 op_written;
  logic                 overflow;

  // multiplication datapath control signals
  logic                 product_add;
  logic                 product_shift;

  logic                 start_operation_ar_fsm;  // ...
  logic                 operation_done_ar_fsm;   // for handshake between main fsm and operation fsm

  logic                 main_write_to_b;
  logic           [3:0] k_select;
  

  pa_fpu::e_arith_state  curr_state_arith_fsm;
  pa_fpu::e_arith_state  next_state_arith_fsm;
  pa_fpu::e_main_state   curr_state_main_fsm;
  pa_fpu::e_main_state   next_state_main_fsm;

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

  assign a_is_zero       = a_exp == 8'h00 && a_mantissa == 23'h0;
  assign b_is_zero       = b_exp == 8'h00 && b_mantissa == 23'h0;

  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operand_a  <= {1'b0, 8'd127, 23'h0};
      operand_b  <= {1'b0, 8'd127, 23'h0};
      operation  <= op_add;  
      op_written <= 1'b0;
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

          4'h8: begin
            operation  <= e_fpu_operation'(databus_in[3:0]);
            op_written <= 1'b1;
          end
        endcase      
      end
      if(next_state_main_fsm == pa_fpu::main_wait_st) op_written <= 1'b0;
      if(next_state_main_fsm == pa_fpu::main_wait_ack_st) operand_a <= result_ieee_packet;
      // coefficients for sine and cosine functions.
      // factorial inverses.
      if(main_write_to_b) 
        case(k_select)
          4'd0: operand_b <= 32'h3f800000; // 1/0! = 1/1
          4'd1: operand_b <= 32'h3f800000; // 1/1! = 1/1
          4'd2: operand_b <= 32'h3f000000; // 1/2! = 1/2
          4'd3: operand_b <= 32'h3e2aaaab; // 1/3! = 1/6
          4'd4: operand_b <= 32'h3d2aaaab; // 1/4! = 1/24
          4'd5: operand_b <= 32'h3c088889; // 1/5! = 1/120
          4'd6: operand_b <= 32'h3ab60b61; // 1/6! = 1/720
          4'd7: operand_b <= 32'h39500d01; // 1/7! = 1/5040
          4'd8: operand_b <= operand_a;
        endcase
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
    logic [1:0] guard_bits;

    if(aexp_no_bias < bexp_no_bias) begin
      if(!a_is_zero) begin
        a_mantissa_after_adjust = a_mantissa >> ba_exp_diff;
        aexp_after_adjust       = aexp_no_bias + ba_exp_diff;
      end
      else begin
        a_mantissa_after_adjust = a_mantissa;
        aexp_after_adjust       = aexp_no_bias;
      end
      b_mantissa_after_adjust = b_mantissa;
      bexp_after_adjust       = bexp_no_bias;
    end   
    else if(bexp_no_bias < aexp_no_bias) begin
      a_mantissa_after_adjust = a_mantissa;
      aexp_after_adjust       = aexp_no_bias;
      if(!b_is_zero) begin
        b_mantissa_after_adjust = b_mantissa >> ab_exp_diff;
        bexp_after_adjust       = bexp_no_bias + ab_exp_diff;
      end
      else begin
        b_mantissa_after_adjust = b_mantissa;
        bexp_after_adjust       = bexp_no_bias;
      end
    end   
    else begin
      a_mantissa_after_adjust = a_mantissa;
      aexp_after_adjust       = aexp_no_bias;
      b_mantissa_after_adjust = b_mantissa;
      bexp_after_adjust       = bexp_no_bias;
    end

    // the _after_adjust variables are used for add and sub operations only
    if(a_sign == 1'b1) a_mantissa_after_adjust = ~a_mantissa_after_adjust + 1;
    if(b_sign == 1'b1) b_mantissa_after_adjust = ~b_mantissa_after_adjust + 1;

    // addition & subtraction
    if(operation == op_add) result_mantissa_add_sub = a_mantissa_after_adjust + b_mantissa_after_adjust;
    else if(operation == op_sub) result_mantissa_add_sub = a_mantissa_after_adjust - b_mantissa_after_adjust;
    if(result_mantissa_add_sub[25:0] == 25'd0) begin
      result_mantissa_before_inv = result_mantissa_add_sub;
      result_mantissa_before_shift1 = result_mantissa_add_sub;
      result_mantissa_before_shift2 = result_mantissa_add_sub;
      result_exp_add_sub = 8'd0; 
      result_sign_add_sub = 1'b0;
    end
    else begin
      if(!a_is_zero) result_exp_add_sub = aexp_after_adjust;
      else result_exp_add_sub = bexp_after_adjust;
      result_mantissa_before_inv = result_mantissa_add_sub;
      result_sign_add_sub = result_mantissa_add_sub[25];
      if(result_sign_add_sub) result_mantissa_add_sub = -result_mantissa_add_sub;
      result_mantissa_before_shift1 = result_mantissa_add_sub;
      if(result_mantissa_add_sub[25]) begin
        result_mantissa_add_sub = result_mantissa_add_sub >> 2;
        result_exp_add_sub = result_exp_add_sub + 2;
      end
      else if(result_mantissa_add_sub[24]) begin
        result_mantissa_add_sub = result_mantissa_add_sub >> 1;
        result_exp_add_sub = result_exp_add_sub + 1;
      end
      else if(curr_state_arith_fsm == pa_fpu::result_valid_st) begin
      //else if(|result_mantissa_add_sub[23:0]) begin // if there is at least one non zero bit, then perform while loop. this needs to be tested otherwise the loop is infinite.
         while(!result_mantissa_add_sub[23]) begin
           result_mantissa_add_sub = result_mantissa_add_sub << 1;
           result_exp_add_sub = result_exp_add_sub - 1;
         end
      end
      //result_mantissa_add_sub[26] = 1'b0;
      result_exp_add_sub = result_exp_add_sub + 8'd127;
    end
  end

  always @(posedge clk, posedge arst) begin
    if(arst) result_ieee_packet <= '0;
    else if(curr_state_arith_fsm == pa_fpu::result_valid_st) begin
      case(operation)
        op_add: 
          result_ieee_packet = {result_sign_add_sub, result_exp_add_sub, result_mantissa_add_sub[22:0]};
        op_sub: 
          result_ieee_packet = {result_sign_add_sub, result_exp_add_sub, result_mantissa_add_sub[22:0]};
        op_mul: 
          result_ieee_packet = {result_sign_multiplication, result_exp_multiplication, result_mantissa_multiplication[22:0]};
        op_square: 
          result_ieee_packet = {result_sign_multiplication, result_exp_multiplication, result_mantissa_multiplication[22:0]};
        op_div: 
          result_ieee_packet = {result_sign_division, result_exp_division, result_mantissa_division[22:0]};
        op_k_pi: 
          result_ieee_packet = 32'h40490fda;
        op_k_piby2: 
          result_ieee_packet = 32'h3fc90fda;
      endcase
    end
  end

  // multiplication datapath
  always @(posedge clk, posedge arst) begin
    if(arst) begin
      multiplicand       <= '0;
      product_multiplier <= '0;
      mul_cycle_counter  <= '0;
    end
    else begin
      if(product_add) begin
        if(product_multiplier[0]) product_multiplier[48:24] <= product_multiplier[48:24] + multiplicand; // product_multiplier is 49 bits rather than 48 so it can also keep the carry out
        mul_cycle_counter <= mul_cycle_counter + 5'd1; // increment counter here so that we can check the counter value in the next state. otherwise would need an extra state after shift_st to check counter == 16.
      end
      if(product_shift) product_multiplier <= product_multiplier >> 1;
      if(next_state_arith_fsm == pa_fpu::mul_start_st) begin
        mul_cycle_counter  <= '0;
        multiplicand       <= a_mantissa[23:0];
        product_multiplier <= {25'b0, b_mantissa[23:0]};  // initiate register, copy b_mantissa, as the multiplier
      end
      // this is tested on current state rather than next state because when the fsm reaches mul_result_set_st, the shift operation is clocked in 
      if(curr_state_arith_fsm == pa_fpu::mul_result_set_st) begin
        result_mantissa_multiplication = product_multiplier[47:24];
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

  // main fsm
  // next state assignments
  always_comb begin
    next_state_main_fsm = curr_state_main_fsm;

    case(curr_state_main_fsm)
      pa_fpu::main_idle_st: 
        if(op_written) next_state_main_fsm = pa_fpu::main_wait_st;
      
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
      busy    <= 1'b0;         
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

  // main fsm
  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) curr_state_main_fsm <= main_idle_st;
    else curr_state_main_fsm <= next_state_main_fsm;
  end

  // arithmetic fsm
  // next state assignments
  always_comb begin
    next_state_arith_fsm = curr_state_arith_fsm;

    case(curr_state_arith_fsm)
      pa_fpu::idle_st: 
        if(start_operation_ar_fsm)
          case(operation)
            pa_fpu::op_add:
              next_state_arith_fsm = pa_fpu::add_start_st;
            pa_fpu::op_sub:
              next_state_arith_fsm = pa_fpu::sub_start_st;
            pa_fpu::op_mul:
              next_state_arith_fsm = pa_fpu::mul_start_st;
            pa_fpu::op_square:
              next_state_arith_fsm = pa_fpu::square_set_b_st;
            pa_fpu::op_div:
              next_state_arith_fsm = pa_fpu::div_start_st;
            pa_fpu::op_k_pi:
              next_state_arith_fsm = pa_fpu::k_start_st;
            pa_fpu::op_k_piby2:
              next_state_arith_fsm = pa_fpu::k_start_st;
          endcase

      // addition states **********************************
      pa_fpu::add_start_st:
        next_state_arith_fsm = result_valid_st;

      // subtraction states **********************************
      pa_fpu::sub_start_st:
        next_state_arith_fsm = result_valid_st;

      // square states
      pa_fpu::square_set_b_st:
        next_state_arith_fsm = pa_fpu::mul_start_st;

      // multiplication states **********************************
      pa_fpu::mul_start_st:
        next_state_arith_fsm = pa_fpu::mul_product_add_st;
      pa_fpu::mul_product_add_st:
        next_state_arith_fsm = pa_fpu::mul_product_shift_st;
      pa_fpu::mul_product_shift_st:
        if(mul_cycle_counter == 5'd24) next_state_arith_fsm = mul_result_set_st;
        else next_state_arith_fsm = mul_product_add_st;
      pa_fpu::mul_result_set_st:
        next_state_arith_fsm = pa_fpu::result_valid_st;

      // division states **********************************
      pa_fpu::div_start_st:
        next_state_arith_fsm = pa_fpu::result_valid_st;

      // k states
      pa_fpu::k_start_st:
        next_state_arith_fsm = result_valid_st;

      pa_fpu::result_valid_st:
        if(start_operation_ar_fsm == 1'b0) next_state_arith_fsm = pa_fpu::idle_st;

      default:
        next_state_arith_fsm = pa_fpu::idle_st;
    endcase
  end

  // arithmetic fsm
  // output assignments
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operation_done_ar_fsm <= 1'b0;
      status                <= '0;
      product_add           <= 1'b0;
      product_shift         <= 1'b0;
      main_write_to_b       <= 1'b0;
      k_select              <= 4'd0;
    end
    else begin
      case(next_state_arith_fsm)
        pa_fpu::idle_st: begin
          operation_done_ar_fsm <= 1'b0;
          status                <= '0;
          product_add           <= 1'b0;
          product_shift         <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::add_start_st: begin
          operation_done_ar_fsm <= 1'b0;
          status                <= '0;
          product_add           <= 1'b0;
          product_shift         <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::sub_start_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::square_set_b_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b1;
          k_select              <= 4'd8;  // copy operand_a to operand_b
        end
        pa_fpu::mul_start_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::mul_product_add_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b1;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::mul_product_shift_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b1;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::mul_result_set_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::div_start_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::div_end_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::k_start_st: begin
          operation_done_ar_fsm <= 1'b0;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
        pa_fpu::result_valid_st: begin
          operation_done_ar_fsm <= 1'b1;
          status  <= '0;
          product_add <= 1'b0;
          product_shift <= 1'b0;
          main_write_to_b       <= 1'b0;
          k_select              <= 4'd0;
        end
      endcase  
    end
  end

  // arithmetic fsm
  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) curr_state_arith_fsm <= idle_st;
    else curr_state_arith_fsm <= next_state_arith_fsm;
  end

endmodule


  // latch for writing operation registers
  /*
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
          operation  = e_fpu_operation'(databus_in[3:0]);
          op_written = 1'b1;
        end
      endcase      
    end
    else if(curr_state_main_fsm == pa_fpu::main_wait_st) op_written = 1'b0;
    else if(next_state_main_fsm == pa_fpu::main_wait_ack_st) begin
      case(operation)
        op_add: 
          operand_a = {result_sign_add_sub, result_exp_add_sub, result_mantissa_add_sub[22:0]};
        op_sub: 
          operand_a = {result_sign_add_sub, result_exp_add_sub, result_mantissa_add_sub[22:0]};
        op_mul: 
          operand_a = {result_sign_multiplication, result_exp_multiplication, result_mantissa_multiplication[22:0]};
        op_div: 
          operand_a = {result_sign_division, result_exp_division, result_mantissa_division[22:0]};
        op_k_pi: 
          operand_a = 32'h40490fda;
        op_k_piby2: 
          operand_a = 32'h3fc90fda;
      endcase
    end
  end
  */