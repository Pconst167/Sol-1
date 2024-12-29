// FPU Prototype
// This is an FPU unit that will perform addition, subtraction, multiplication, division, square root, and transcendental functions
// It is written in SystemVerilog here for prototyping purposes.
// Totally non-optimized and for prototyping and studying purposes only!
//
// Created P. Constantino 2024
//

/*
  sqrt: newton-raphson
    xn = 0.5(xn + A/xn)

  dot product:
    a dot b 
    = a0b0 + a1b1 + ... + anbn 
    = |a||b|cos(arg(a,b))

  cross product:
    a cross b 
    = (a2b3 - a3b2)i + (a3b1 - a1b3)j + (a1b2 - a2b1)k
    = |a||b|sin(arg(a,b))n where n is the unit vector normal to both a & b

  Slow converging series. Look at chebyshev polynomials.
    sin(x)    = x - x^3/3! + x^5/5! - x^7/7! + ...
    cos(x)    = 1 - x^2/2 + x^4/4! - x^6/6! + ...
    exp(x)    = 1 + x + x^2/2 + x^3/3! + x^4/4! + x^5/5! + ...
    ln(1+x)   = x - x^2/2 + x^3/3 - x^4/4 + x^5/5 - ...  (|x| < 1)
    arctan(x) = x - x^3/3 + x^5/5 - x^7/7 + ... (slow convergence)


  approximating log2:
    take exponent - 127 as starting point. exponent is the approximate log2
    because mantissa is < 1, log of mantissa is approximately equal to the mantissa itself plus a constant sigma = 0.0430357.
    hence an aproximation is (exponent - 127) + mantissa + sigma.
    log(x) = log((1+m)2^e) = e + 1 + m = e + m + sigma

  integer to float:
    exponent = 31 - #leading zeroes.
    mantissa placed on msb side with leading 1 removed

  float to integer:
    if exponent < 0, return 0
    else truncate the number 1.mantissa after #exponent places and that is the integer
    example: 1.1101010 * 2^3 = 1110. 

  operations:
    add
    sub
    mul
    div
    sqrt
    log2

    1/a
    int2float
    float2int

  chebyshev polynomials:
    Tn   = cos(nx)
    Tn+1 = 2xTn - Tn-1
    T0 = 1, T1 = x, T2 = 2x^2-1, T3 = 4x^3 - 3x, T4 = 8x^4 - 8x^2 + 1

  Chebyshev approximations
    f           range       c0       c1          c2          c3           c4             c5
    sinπx       [-0.5,0.5]  0	      1.1336	    0           -0.13807	   0	            0.0045584
    cosπx       [-0.5,0.5]  0.472	  0	         -0.4994	    0	           0.027985	      0
    sqrt        [1,4]	     1.542	  0.49296    -0.040488	  0.0066968	  -0.0013836	    0.00030211
    log2        [1,2]	     0.54311	0.49505	   -0.042469	  0.0048576	  -0.00062481	    8.3994e-05
    exp         [0,1]	     1.7534	  0.85039	    0.10521	    0.0087221	   0.00054344	    2.7075e-05
    (2/π)*atan  [-1,1]	     0	      0.5274	    0	          -0.030213	   0	            0.0034855

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
  logic            [25:-2] a_mantissa; // 24 bits plus 2 upper guard bits for dealing with signed arithmetic
                                       // plus 3 lower guard bits
  logic            [25:-2] a_mantissa_adjusted;
  logic             [ 7:0] a_exp;
  logic                    a_sign;
  logic             [31:0] operand_b;
  logic            [25:-2] b_mantissa;  // 24 bits plus 2 upper guard bits for dealing with signed arithmetic
                                        // plus 3 lower guard bits
  logic            [25:-2] b_mantissa_adjusted;
  logic             [ 7:0] b_exp;
  logic                    b_sign;
  logic             [ 7:0] ab_exp_diff;

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
  logic             [ 4:0] mul_counter;   // this keeps a count of how many times we have performed the product addition cycle. total = 24.
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
  logic              [4:0] div_counter;
  logic                    div_shift;
  logic                    div_set_q0;
  logic                    start_operation_div_fsm;  
  logic                    operation_done_div_fsm;   

  // sqrt datapath
  logic             [23:0] sqrt_xn_mantissa;   // 24 bits plus 2 upper guard bits for dealing with signed arithmetic
                                               // plus 3 lower guard bits
  logic              [7:0] sqrt_xn_exp;
  logic                    sqrt_xn_sign;
  logic             [23:0] sqrt_A_mantissa;  // 24 bits plus 2 upper guard bits for dealing with signed arithmetic
                                             // plus 3 lower guard bits
  logic              [7:0] sqrt_A_exp;
  logic                    sqrt_A_sign;
  logic              [3:0] sqrt_counter;

  // fsm control
  logic                    start_operation_sqrt_fsm;  
  logic                    operation_done_sqrt_fsm;   
  logic                    sqrt_div_A_by_xn_start;
  logic                    sqrt_xn_A_wrt;
  logic                    sqrt_xn_a_approx_wrt;
  logic                    sqrt_xn_a_wrt;
  logic                    sqrt_xn_add_wrt;
  logic                    sqrt_A_a_wrt;
  logic                    sqrt_a_xn_wrt;
  logic                    sqrt_a_A_wrt;
  logic                    sqrt_b_xn_wrt;
  logic                    sqrt_b_div_wrt;

  // float2int
  logic             [31:0] result_float2int;

  pa_fpu::e_fpu_op         operation; // arithmetic operation to be performed
  logic                    start_operation;

  // other datapath control signals
  logic                    operation_wrt; // when needing to internally change the operator
  pa_fpu::e_fpu_op         new_operation; // arithmetic operation to be performed

  logic                    start_operation_ar_fsm;  // ...
  logic                    operation_done_ar_fsm;   // for handshake between main fsm and arithmetic fsm
  logic                    start_operation_div_ar_fsm;  

  // logarithm
  logic             [30:0] log2_a_exp; 
  logic             [30:0] log2_m;     
  logic             [30:0] log2_sigma;
  logic             [30:0] log2;       
  logic              [7:0] log2_exp;       
  logic                    log2_sign;

  // status
  logic              [4:0] status; // invalid operation, div by zero, overflow, underflow, inexact 

  // fsm states
  pa_fpu::e_main_st        curr_state_main_fsm;
  pa_fpu::e_main_st        next_state_main_fsm;
  pa_fpu::e_arith_st       curr_state_arith_fsm;
  pa_fpu::e_arith_st       next_state_arith_fsm;
  pa_fpu::e_mul_st         curr_state_mul_fsm;
  pa_fpu::e_mul_st         next_state_mul_fsm;
  pa_fpu::e_div_st         curr_state_div_fsm;
  pa_fpu::e_div_st         next_state_div_fsm;
  pa_fpu::e_sqrt_st        curr_state_sqrt_fsm;
  pa_fpu::e_sqrt_st        next_state_sqrt_fsm;


  // todo
  // microcode sequencer

  assign ab_exp_diff = a_exp - b_exp;

  assign start_operation_div_fsm = start_operation_div_ar_fsm || sqrt_div_A_by_xn_start;

  // ---------------------------------------------------------------------------------------

  // a_mantissa, a_exp and b_mantissa, b_exp register writing
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      a_mantissa <= '0;
      a_exp      <= '0;
      a_sign     <= '0;
      b_mantissa <= '0;
      b_exp      <= '0;
      b_sign     <= '0;
    end   
    else begin
      if(next_state_arith_fsm == pa_fpu::arith_load_operands_st) begin
        a_mantissa <= {operand_a[30:23] != 8'd0, operand_a[22:0], 3'b0};
        a_exp      <= operand_a[30:23];
        a_sign     <= operand_a[31];
        b_mantissa <= {operand_b[30:23] != 8'd0, operand_b[22:0], 3'b0};
        b_exp      <= operand_b[30:23];
        b_sign     <= operand_b[31];
      end
      if(sqrt_a_xn_wrt) begin
        a_mantissa <= {sqrt_xn_mantissa, 3'b0};
        a_exp      <= sqrt_xn_exp;
        a_sign     <= sqrt_xn_sign;
      end
      else if(sqrt_a_A_wrt) begin
        a_mantissa <= {sqrt_A_mantissa, 3'b0};
        a_exp      <= sqrt_A_exp;
        a_sign     <= sqrt_A_sign;
      end
      if(sqrt_b_xn_wrt) begin
        b_mantissa <= {sqrt_xn_mantissa, 3'b0};
        b_exp      <= sqrt_xn_exp;
        b_sign     <= sqrt_xn_sign;
      end
      else if(sqrt_b_div_wrt) begin
        b_mantissa <= {result_mantissa_div, 3'b0};
        b_exp      <= result_exp_div;
        b_sign     <= result_sign_div;
      end
    end
  end

  // ---------------------------------------------------------------------------------------

  always_ff @(posedge clk, posedge arst) begin
    if(arst) ieee_packet <= '0;
    else if(curr_state_arith_fsm == pa_fpu::arith_result_valid_st) begin
      case(operation)
        op_add: 
          ieee_packet <= {result_sign_add, result_exp_add, result_mantissa_add[22:0]};
        op_sub: 
          ieee_packet <= {result_sign_sub, result_exp_sub, result_mantissa_sub[22:0]};
        op_mul: 
          ieee_packet <= {result_sign_mul, result_exp_mul, result_mantissa_mul[22:0]};
        op_square: 
          ieee_packet <= {result_sign_mul, result_exp_mul, result_mantissa_mul[22:0]};
        op_div: 
          ieee_packet <= {result_sign_div, result_exp_div, result_mantissa_div[22:0]};
        op_sqrt: 
          ieee_packet <= {1'b0, sqrt_xn_exp, sqrt_xn_mantissa[22:0]};
        op_log2: 
          ieee_packet <= {log2_sign, log2_exp, log2[29:7]};
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

          4'h8: operation  <= e_fpu_op'(databus_in[3:0]);
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

  // logarithm to base 2
  always_comb begin
    // aliasing the floating point number as a new number such that (exponent-127) is the integral part, and mantissa is the fractional part
    // then adding a fractional error term gives the approximate log2 of the floating point.
    log2      = {operand_a[30:23] - 8'd127, operand_a[22:0]} + {8'b0, 23'b00001011000001000110011};
    log2_exp  = 7;
    log2_sign = 1'b0;
    if(log2[30]) begin
      log2 = -log2;
      log2_sign = 1'b1;
    end
    while(log2[30] == 1'b0) begin
      if(log2 == '0) break;
      log2_exp = log2_exp - 1;
      log2 = log2 << 1;
    end
    log2_exp = log2_exp + 8'd127;
  end

  // ---------------------------------------------------------------------------------------
  // addition & subtraction combinational datapath

  // if aexp < bexp, then increase aexp and right-shift a_mantissa by same number
  // else if aexp > bexp, then increase bexp and right-shift b_mantissa by same number
  // else, exponents are the same
  always_comb begin
    logic sticky;

    if(a_exp < b_exp) begin
      sticky = 0;
      for(int i = 0; i <= -ab_exp_diff - 3; i++) 
        if(a_mantissa[i] == 1) begin
          sticky = 1;
          break;
        end
      a_mantissa_adjusted     = a_mantissa >> -ab_exp_diff;
      a_mantissa_adjusted[-2] = sticky;
      a_exp_adjusted          = b_exp;

      b_mantissa_adjusted     = b_mantissa;
      b_exp_adjusted          = b_exp;
    end   
    else if(b_exp < a_exp) begin
      sticky = 0;
      for(int i = 0; i <= ab_exp_diff - 3; i++) 
        if(b_mantissa[i] == 1) begin
          sticky = 1;
          break;
        end
      a_mantissa_adjusted     = a_mantissa;
      a_exp_adjusted          = a_exp;

      b_mantissa_adjusted     = b_mantissa >> ab_exp_diff;
      b_mantissa_adjusted[-2] = sticky;
      b_exp_adjusted          = a_exp;
    end   
    else begin
      a_mantissa_adjusted = a_mantissa;
      a_exp_adjusted      = a_exp;
      b_mantissa_adjusted = b_mantissa;
      b_exp_adjusted      = b_exp;
    end
    // the _adjusted variables are used for add and sub operations only
    // negate mantissas if signs are negative
    if(a_sign == 1'b1) a_mantissa_adjusted = -a_mantissa_adjusted;
    if(b_sign == 1'b1) b_mantissa_adjusted = -b_mantissa_adjusted;
  end

  // addition datapath
  always_comb begin
    result_mantissa_add = a_mantissa_adjusted + b_mantissa_adjusted;
    result_exp_add = b_exp_adjusted;
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
  end

  // subtraction datapath
  always_comb begin
    result_mantissa_sub = a_mantissa_adjusted - b_mantissa_adjusted;
    result_exp_sub = b_exp_adjusted;
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
          next_state_arith_fsm = arith_load_operands_st;

      pa_fpu::arith_load_operands_st:
        case(operation)
          pa_fpu::op_add:
            next_state_arith_fsm = pa_fpu::arith_add_st;
          pa_fpu::op_sub:
            next_state_arith_fsm = pa_fpu::arith_sub_st;
          pa_fpu::op_mul:
            next_state_arith_fsm = pa_fpu::arith_mul_st;
          pa_fpu::op_div:
            next_state_arith_fsm = pa_fpu::arith_div_st;
          pa_fpu::op_sqrt:
            next_state_arith_fsm = pa_fpu::arith_sqrt_st;
          pa_fpu::op_log2:
            next_state_arith_fsm = pa_fpu::arith_log2_st;
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

      pa_fpu::arith_sqrt_st:
        if(operation_done_sqrt_fsm == 1'b1) next_state_arith_fsm = pa_fpu::arith_sqrt_done_st;
      pa_fpu::arith_sqrt_done_st:
        if(operation_done_sqrt_fsm == 1'b0) next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_log2_st:
        next_state_arith_fsm = arith_result_valid_st;

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
      start_operation_div_ar_fsm <= 1'b0;
      start_operation_sqrt_fsm <= 1'b0;
    end
    else begin
      case(next_state_arith_fsm)
        pa_fpu::arith_idle_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_load_operands_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_add_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_sub_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_mul_st: begin
          operation_done_ar_fsm   <= 1'b0;
          start_operation_mul_fsm <= 1'b1;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_mul_done_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_div_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b1;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_div_done_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_sqrt_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b1;
        end
        pa_fpu::arith_sqrt_done_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_log2_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_result_valid_st: begin
          operation_done_ar_fsm <= 1'b1;
          start_operation_mul_fsm <= 1'b0;
          start_operation_div_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
      endcase  
    end
  end

  // ---------------------------------------------------------------------------------------

  // multiplication datapath
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      product_multiplier <= '0;
      mul_counter  <= '0;
    end
    else begin
      if(product_add) begin
        if(product_multiplier[0]) product_multiplier[48:24] <= product_multiplier[48:24] + a_mantissa[23:0]; // product_multiplier is 49 bits rather than 48 so it can also keep the carry out
        mul_counter <= mul_counter + 5'd1; // increment counter here so that we can check the counter value in the next state. otherwise would need an extra state after shift_st to check counter == 16.
      end
      if(product_shift) product_multiplier <= product_multiplier >> 1;
      if(next_state_mul_fsm == pa_fpu::mul_start_st) begin
        mul_counter  <= '0;
        product_multiplier <= {25'b0, b_mantissa[23:0]};  // initiate register, copy b_mantissa, as the multiplier
      end
      // this is tested on current state rather than next state because when the fsm reaches mul_result_set_st, the shift operation is clocked in 
      if(curr_state_mul_fsm == pa_fpu::mul_result_set_st) begin
        automatic logic [23:0] m = product_multiplier[47:24];
        automatic logic [7:0]  e = (a_exp - 8'd127) + b_exp;
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
        if(mul_counter == 5'd24) next_state_mul_fsm = mul_result_set_st;
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
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      remainder_dividend <= '0;
      div_counter        <= '0;
    end
    else begin
      if(next_state_div_fsm == pa_fpu::div_start_st) begin
        div_counter <= '0;
        remainder_dividend <= {2'b00, a_mantissa[23:0], 23'd0}; // dividend in lower half
      end
      if(div_shift) 
        remainder_dividend <= remainder_dividend << 1;
      if(div_set_q0) begin
        remainder_dividend[0] <= 1'b1;
        remainder_dividend[48:24] <= {1'b0, remainder_dividend[48:24]} + ~{2'b00, b_mantissa[23:0]} + 26'b1;
      end
      if(next_state_div_fsm == pa_fpu::div_sub_divisor_test_st)  
        div_counter <= div_counter + 1;
      if(curr_state_div_fsm == pa_fpu::div_result_valid_st) begin
        automatic logic [7:0] e = (a_exp - b_exp) + 8'd127;
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
        if(intermediary[25] == 1'b1) begin
          if(div_counter == 5'd24) next_state_div_fsm = pa_fpu::div_result_valid_st;
          else next_state_div_fsm = pa_fpu::div_shift_st;
        end
        else next_state_div_fsm = pa_fpu::div_set_q0_st; // result is positive
      end
      
      pa_fpu::div_set_q0_st:
        if(div_counter == 5'd24) next_state_div_fsm = pa_fpu::div_result_valid_st;
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
      div_set_q0           <= 1'b0;
    end
    else begin
      case(next_state_div_fsm)
        pa_fpu::div_idle_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_q0           <= 1'b0;
        end
        pa_fpu::div_start_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_q0           <= 1'b0;
        end
        pa_fpu::div_shift_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b1;
          div_set_q0           <= 1'b0;
        end
        pa_fpu::div_sub_divisor_test_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_q0           <= 1'b0;
        end
        pa_fpu::div_set_q0_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_set_q0           <= 1'b1;
        end
        pa_fpu::div_result_valid_st: begin
          operation_done_div_fsm <= 1'b1;
          div_shift              <= 1'b0;
          div_set_q0           <= 1'b0;
        end
      endcase  
    end
  end

  // ------------------------------------------------------------------------------------------------

  // sqrt datapath
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      sqrt_xn_mantissa <= '0;
      sqrt_xn_exp      <= '0;
      sqrt_xn_sign     <= '0;
      sqrt_A_mantissa  <= '0;
      sqrt_A_exp       <= '0;
      sqrt_A_sign      <= '0;
      sqrt_counter     <= '0;
    end
    else begin
      if(next_state_sqrt_fsm == pa_fpu::sqrt_start_st) begin
        sqrt_counter <= 0;
      end
      else if(next_state_sqrt_fsm == pa_fpu::sqrt_mov_xn_a_dec_exp_st) begin
        sqrt_counter <= sqrt_counter + 4'd1;
      end
      if(sqrt_xn_A_wrt) begin
        sqrt_xn_mantissa <= sqrt_A_mantissa;
        sqrt_xn_exp      <= sqrt_A_exp;
        sqrt_xn_sign     <= 1'b0;
      end
      else if(sqrt_xn_a_approx_wrt) begin
        sqrt_xn_mantissa <= a_mantissa[25:0]; 
        //sqrt_xn_exp      <= a_exp - 8'd1;
        // 9'b110000001 = -127 with 1 bit extended for signed arithmetic
        //sqrt_xn_exp      <= (({1'b0, a_exp} + 9'b110000001) >> 1) + 9'd127 ; // divide a_exp by 2. hence initial approx to A = m*2^E  is  m*e^(E/2) which is very close to its square root.
        // a_exp is biased. shifting it by 1 divides the bias 127 by 2 as well, hence add back 127/2 = 63
        sqrt_xn_exp      <= (a_exp >> 1) + 9'd63 ; // divide a_exp by 2. hence initial approx to A = m*2^E  is  m*e^(E/2) which is very close to its square root.
        sqrt_xn_sign     <= a_sign;
      end
      else if(sqrt_xn_a_wrt) begin
        sqrt_xn_mantissa <= a_mantissa[25:0];
        sqrt_xn_exp      <= a_exp;
        sqrt_xn_sign     <= a_sign;
      end
      else if(sqrt_xn_add_wrt) begin
        sqrt_xn_mantissa <= result_mantissa_add;
        sqrt_xn_exp      <= result_exp_add - 8'd1;
        sqrt_xn_sign     <= result_sign_add;
      end
      if(sqrt_A_a_wrt) begin
        sqrt_A_mantissa <= a_mantissa[25:0];
        sqrt_A_exp      <= a_exp;
        sqrt_A_sign     <= a_sign;
      end
    end
  end

  // sqrt fsm
  // next state assignments
  // xn = 0.5(xn + A/xn)
  always_comb begin
    next_state_sqrt_fsm = curr_state_sqrt_fsm;

    case(curr_state_sqrt_fsm)
      pa_fpu::sqrt_idle_st: 
        if(start_operation_sqrt_fsm) next_state_sqrt_fsm = pa_fpu::sqrt_start_st;
      // set A = a_mantissa (A = number whose sqrt is requested)
      // set xn to initial guess 
      // set counter for number of steps
      pa_fpu::sqrt_start_st: 
        next_state_sqrt_fsm = pa_fpu::sqrt_div_setup_st;
      // set a_mantissa = A, a_exp = A_exp
      // set b_mantissa = xn, b_exp = xn_exp
      pa_fpu::sqrt_div_setup_st: begin
        next_state_sqrt_fsm = pa_fpu::sqrt_wait_div_done_st;
      end
      // wait for division to complete.
      pa_fpu::sqrt_wait_div_done_st: begin
        if(operation_done_div_fsm) next_state_sqrt_fsm = pa_fpu::sqrt_addition_st;
        else next_state_sqrt_fsm = pa_fpu::sqrt_wait_div_done_st;
      end
      // set a_mantissa <= xn, a_exp = xn_exp
      // set b_mantissa <= result_mantissa_div, b_exp = result_exp_div
      pa_fpu::sqrt_addition_st: begin
        next_state_sqrt_fsm = pa_fpu::sqrt_mov_xn_a_dec_exp_st;
      end
      // perform addition during this clock cycle
      // set xn = result_mantissa_add, while decreasing xn_exp by 1
      // dec sqrt_counter when entering this state
      // check sqrt_counter == 4
      pa_fpu::sqrt_mov_xn_a_dec_exp_st: begin
        if(sqrt_counter == 4'd4) next_state_sqrt_fsm = pa_fpu::sqrt_result_valid_st;
        else next_state_sqrt_fsm = pa_fpu::sqrt_div_setup_st;
      end
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
      sqrt_div_A_by_xn_start  <= 1'b0;
      sqrt_xn_A_wrt           <= 1'b0;
      sqrt_xn_a_approx_wrt    <= 1'b0;
      sqrt_xn_a_wrt           <= 1'b0;
      sqrt_xn_add_wrt         <= 1'b0;
      sqrt_A_a_wrt            <= 1'b0;
      sqrt_a_xn_wrt           <= 1'b0;
      sqrt_a_A_wrt            <= 1'b0;
      sqrt_b_xn_wrt           <= 1'b0;
      sqrt_b_div_wrt          <= 1'b0;
    end
    else begin
      case(next_state_sqrt_fsm)
        pa_fpu::sqrt_idle_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_div_A_by_xn_start  <= 1'b0;
          sqrt_xn_A_wrt           <= 1'b0;
          sqrt_xn_a_approx_wrt    <= 1'b0;
          sqrt_xn_a_wrt           <= 1'b0;
          sqrt_xn_add_wrt         <= 1'b0;
          sqrt_A_a_wrt            <= 1'b0;
          sqrt_a_xn_wrt           <= 1'b0;
          sqrt_a_A_wrt            <= 1'b0;
          sqrt_b_xn_wrt           <= 1'b0;
          sqrt_b_div_wrt          <= 1'b0;
        end
        // set A = a_mantissa (A = number whose sqrt is requested)
        // set xn to initial guess
        // set counter for number of steps
        pa_fpu::sqrt_start_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_div_A_by_xn_start  <= 1'b0;
          sqrt_xn_A_wrt           <= 1'b0;
          sqrt_xn_a_wrt           <= 1'b0;
          sqrt_xn_a_approx_wrt    <= 1'b1;
          sqrt_xn_add_wrt         <= 1'b0;
          sqrt_A_a_wrt            <= 1'b1;
          sqrt_a_xn_wrt           <= 1'b0;
          sqrt_a_A_wrt            <= 1'b0;
          sqrt_b_xn_wrt           <= 1'b0;
          sqrt_b_div_wrt          <= 1'b0;
        end
        // set a_mantissa = A, a_exp = A_exp
        // set b_mantissa = xn, b_exp = xn_exp
        pa_fpu::sqrt_div_setup_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_div_A_by_xn_start  <= 1'b0;
          sqrt_xn_A_wrt           <= 1'b0;
          sqrt_xn_a_wrt           <= 1'b0;
          sqrt_xn_a_approx_wrt    <= 1'b0;
          sqrt_xn_add_wrt         <= 1'b0;
          sqrt_A_a_wrt            <= 1'b0;
          sqrt_a_xn_wrt           <= 1'b0;
          sqrt_a_A_wrt            <= 1'b1;
          sqrt_b_xn_wrt           <= 1'b1;
          sqrt_b_div_wrt          <= 1'b0;
        end
        // wait for division to complete.
        pa_fpu::sqrt_wait_div_done_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_div_A_by_xn_start  <= 1'b1; // request division operation
          sqrt_xn_A_wrt           <= 1'b0;
          sqrt_xn_a_wrt           <= 1'b0;
          sqrt_xn_a_approx_wrt    <= 1'b0;
          sqrt_xn_add_wrt         <= 1'b0;
          sqrt_A_a_wrt            <= 1'b0;
          sqrt_a_xn_wrt           <= 1'b0;
          sqrt_a_A_wrt            <= 1'b0;
          sqrt_b_xn_wrt           <= 1'b0;
          sqrt_b_div_wrt          <= 1'b0;
        end
        // set a_mantissa <= xn, a_exp = xn_exp
        // set b_mantissa <= result_mantissa_div, b_exp = result_exp_div
        // perform addition during this clock cycle
        pa_fpu::sqrt_addition_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_div_A_by_xn_start  <= 1'b0;
          sqrt_xn_A_wrt           <= 1'b0;
          sqrt_xn_a_wrt           <= 1'b0;
          sqrt_xn_a_approx_wrt    <= 1'b0;
          sqrt_xn_add_wrt         <= 1'b0;
          sqrt_A_a_wrt            <= 1'b0;
          sqrt_a_xn_wrt           <= 1'b1;
          sqrt_a_A_wrt            <= 1'b0;
          sqrt_b_xn_wrt           <= 1'b0;
          sqrt_b_div_wrt          <= 1'b1;
        end
        // transfer addition result to xn, while decreasing xn_exp by 1
        // inc sqrt_counter
        pa_fpu::sqrt_mov_xn_a_dec_exp_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_div_A_by_xn_start  <= 1'b0;
          sqrt_xn_A_wrt           <= 1'b0;
          sqrt_xn_a_wrt           <= 1'b0;
          sqrt_xn_a_approx_wrt    <= 1'b0;
          sqrt_xn_add_wrt         <= 1'b1;
          sqrt_A_a_wrt            <= 1'b0;
          sqrt_a_xn_wrt           <= 1'b0;
          sqrt_a_A_wrt            <= 1'b0;
          sqrt_b_xn_wrt           <= 1'b0;
          sqrt_b_div_wrt          <= 1'b0;
        end
        pa_fpu::sqrt_result_valid_st: begin
          operation_done_sqrt_fsm <= 1'b1;
          sqrt_div_A_by_xn_start  <= 1'b0;
          sqrt_xn_A_wrt           <= 1'b0;
          sqrt_xn_a_wrt           <= 1'b0;
          sqrt_xn_a_approx_wrt    <= 1'b0;
          sqrt_xn_add_wrt         <= 1'b0;
          sqrt_A_a_wrt            <= 1'b0;
          sqrt_a_xn_wrt           <= 1'b0;
          sqrt_a_A_wrt            <= 1'b0;
          sqrt_b_xn_wrt           <= 1'b0;
          sqrt_b_div_wrt          <= 1'b0;
        end
      endcase  
    end
  end

  // todo
  // float2int
  // if exponent < 0, return 0
  // else truncate the number 1.mantissa after #exponent places and that is the integer
  // example: 1.1101010 * 2^3 = 1110. 
  always_comb begin
    logic [7:0] shift;
    if(a_exp - 8'd127 < 0) result_float2int = 32'b0;
    else begin
      shift = a_exp - 8'd127;
      result_float2int = {1'b1, a_mantissa[25:0]};
    end
  end


  // sin x
  // x - x^3/6 + x^5/120 - x^7/5040
  // 

  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      curr_state_main_fsm  <= main_idle_st;
      curr_state_arith_fsm <= arith_idle_st;
      curr_state_mul_fsm   <= mul_idle_st;
      curr_state_div_fsm   <= div_idle_st;
      curr_state_sqrt_fsm  <= sqrt_idle_st;
    end
    else begin
      curr_state_main_fsm  <= next_state_main_fsm;
      curr_state_arith_fsm <= next_state_arith_fsm;
      curr_state_mul_fsm   <= next_state_mul_fsm;
      curr_state_div_fsm   <= next_state_div_fsm;
      curr_state_sqrt_fsm  <= next_state_sqrt_fsm;
    end
  end

/*
  always_comb begin
    logic [2:0] sum;
    logic [3:0] op;

    sum = 0;
    sum = sum + op[3];
    sum = sum + op[3] && op[2];
    sum = sum + op[3] && op[2] && op[1];
    sum = sum + op[3] && op[2] && op[1] && op[0];

    if(op[3] && op[2] && op[1] && op[0]) sum = 4;
    else if(op[3] && op[2] && op[1]) sum = 3;
    else if(op[3] && op[2]) sum = 2;
    else if(op[3]) sum = 1;
    else sum = 0;

    casex(op)
      4'b0000: sum = 4;
      4'b000x: sum = 3;
      4'b00xx: sum = 2;
      4'b0xxx: sum = 1;
      4'bxxxx: sum = 0;
    endcase

    sum = 0;
    if(op == 4'b0) sum = 4;
    else while(op[3] == 1'b0) begin
      sum = sum + 1;
      op = op << 1;
    end
  end
*/

endmodule