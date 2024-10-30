// FPU Prototype
// This is an FPU unit that will perform addition, subtraction, multiplication, division, square root, and transcendental functions
// It is written in SystemVerilog here for prototyping purposes, and after that will be built in hardware for the Sol-1 system
//
// Created Paulo Constantino 2024

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

  logic agtb;
  logic bgta;

  logic [31:0] operand_a;
  logic unsigned [24:0] a_mantissa;
  logic [ 7:0] a_exp;
  logic        a_sign;
  logic [31:0] operand_b;
  logic unsigned [24:0] b_mantissa;
  logic [ 7:0] b_exp;
  logic        b_sign;
  logic [31:0] result;
  logic unsigned [47:0] result_mantissa;
  logic unsigned [47:0] result_mantissa_before_shift;
  logic unsigned [47:0] result_mantissa_before_inv;
  logic [ 7:0] result_exp;
  logic        result_sign;
  logic [ 7:0] aexp_no_bias;
  logic [ 7:0] bexp_no_bias;

  logic [ 7:0] ab_exp_diff;
  logic [ 7:0] ba_exp_diff;

  logic [ 7:0] status;
  e_fpu_operation operation; // arithmetic operation to be performed

  logic op_written;

  logic [7:0] aexp_after_adjust;
  logic [7:0] bexp_after_adjust;
  logic [47:0] a_mantissa_after_adjust;
  logic [47:0] b_mantissa_after_adjust;
  logic [47:0] a_mantissa_after_adjust_abs;
  logic [47:0] b_mantissa_after_adjust_abs;

  logic overflow;

  pa_fpu::e_fpu_state curr_state_fpu_fsm;
  pa_fpu::e_fpu_state next_state_fpu_fsm;

  assign a_mantissa      = {!(a_exp == 8'd0), operand_a[22:0]};
  assign a_exp           = operand_a[30:23];
  assign a_sign          = operand_a[31];
  assign b_mantissa      = {!(b_exp == 8'd0), operand_b[22:0]};
  assign b_exp           = operand_b[30:23];
  assign b_sign          = operand_b[31];

  assign result[22:0]    = result_mantissa[22:0];
  assign result[30:23]   = result_exp;
  assign result[31]      = result_sign;

  assign aexp_no_bias    = a_exp - 127;
  assign bexp_no_bias    = b_exp - 127;

  assign ab_exp_diff     = aexp_no_bias - bexp_no_bias;
  assign ba_exp_diff     = bexp_no_bias - aexp_no_bias;

  assign agtb            = a_mantissa > b_mantissa;
  assign bgta            = b_mantissa > a_mantissa;

  // if aexp < bexp, then increase aexp and right-shift a_mantissa by same number
  // else if aexp > bexp, then increase bexp and right-shift b_mantissa by same number
  // else, exponents are the same and we are ok
  always_comb begin
    if(aexp_no_bias  < bexp_no_bias) begin
      a_mantissa_after_adjust = a_mantissa >> ba_exp_diff;
      b_mantissa_after_adjust = b_mantissa;
      aexp_after_adjust       = aexp_no_bias + ba_exp_diff;
      bexp_after_adjust       = bexp_no_bias;
    end   
    else if(aexp_no_bias  > bexp_no_bias) begin
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

    a_mantissa_after_adjust_abs = a_mantissa_after_adjust;
    b_mantissa_after_adjust_abs = b_mantissa_after_adjust;

    // the _after_adjust variables are used for add and sub operations only
    if(a_sign == 1'b1) 
      a_mantissa_after_adjust = ~a_mantissa_after_adjust + 1;
    if(b_sign == 1'b1) 
      b_mantissa_after_adjust = ~b_mantissa_after_adjust + 1;

    if(operation == op_add) begin
      result_mantissa            = a_mantissa_after_adjust + b_mantissa_after_adjust;
      if(result_mantissa[23:0] == 23'd0) begin
        result_exp = 8'd0; 
        result_mantissa_before_inv   = result_mantissa;
        result_mantissa_before_shift = result_mantissa;
        result_sign                  = 1'b0;
      end
      else begin
        result_mantissa_before_inv = result_mantissa;
        result_exp                 = aexp_after_adjust;
        result_sign                = result_mantissa[24];
        if(result_sign) result_mantissa = -result_mantissa;
        result_mantissa_before_shift = result_mantissa;
        if(result_mantissa[24]) begin 
          result_mantissa = result_mantissa >> 1;
          result_exp = result_exp + 1;
        end
        if(op_written) 
          while(!result_mantissa[23]) begin
            result_mantissa = result_mantissa << 1;
            result_exp = result_exp - 1;
          end
        result_exp = result_exp + 8'd127;
      end
    end
    else if(operation == op_sub) begin
      result_mantissa = a_mantissa_after_adjust - b_mantissa_after_adjust; 
      result_exp      = aexp_after_adjust;
      result_mantissa_before_inv = result_mantissa;
      result_sign = a_sign == 0 && b_sign == 0 && b_mantissa_after_adjust > a_mantissa_after_adjust ||
                    a_sign == 1 && b_sign == 0 ||
                    a_sign == 1 && b_sign == 1 && a_mantissa_after_adjust > b_mantissa_after_adjust;
      if(result_mantissa[24]) begin
        result_mantissa = -result_mantissa;
        result_sign = 1'b1;
      end
      else result_sign = 1'b0;
      result_mantissa_before_shift = result_mantissa;
      while(!result_mantissa[23]) begin
        result_mantissa = result_mantissa << 1;
        result_exp = result_exp - 1;
      end
      result_exp = result_exp + 8'd127;
    end
    else if(operation == op_mul) begin
      result_exp  = aexp_no_bias + bexp_no_bias;
      result_sign = a_sign ^ b_sign;
      result_mantissa = a_mantissa[23:0] * b_mantissa[23:0];
      result_mantissa_before_inv = result_mantissa;
      result_mantissa_before_shift = result_mantissa;
      if(result_mantissa[47] == 1'b1) begin
        result_exp = result_exp + 8'd1; // if MSB is 1, then increment exp by one to normalize because in this case, we have two digits before the decimal point, and so really the result we had was 10.xxx or 11.xxx for example, and so the final result needs to be multiplied by 2
      end
      else if(result_mantissa[47] == 1'b0) begin
        result_mantissa = result_mantissa << 1; // if the MSB of result is a 0, then shift left the result to normalize. in this case, nothing is changed in the mantissa or exponent. we only shift here because of the way we are copying the mantissa from the result variable to the final packet.
      end
      result_mantissa[23:0] = result_mantissa[47:24]; // transfer contents of register just to make it standard     
      result_mantissa[47:24] = '0;  // and zero out MSBs
      result_exp = result_exp + 8'd127; // normalize exponent
    end
    else if(operation == op_div) begin
      result_exp  = aexp_no_bias - bexp_no_bias;
      result_sign = a_sign ^ b_sign;
      result_mantissa = (a_mantissa[23:0] << 23) / b_mantissa;
      result_mantissa_before_shift = result_mantissa;
      if(result_mantissa[23] == 1'b0) begin
        result_mantissa = result_mantissa << 1;
        result_exp = result_exp - 1;
      end
      result_exp = result_exp + 8'd127; // normalize exponent
    end
  end

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

        4'h9: databus_out = result[7:0];
        4'hA: databus_out = result[15:8];
        4'hB: databus_out = result[23:16];
        4'hC: databus_out = result[31:24];

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

      pa_fpu::add_start_st:
        next_state_fpu_fsm = result_valid_st;

      pa_fpu::sub_start_st:
        next_state_fpu_fsm = result_valid_st;

      pa_fpu::mul_start_st:
        next_state_fpu_fsm = pa_fpu::mul_end_st;

      pa_fpu::mul_end_st:
        next_state_fpu_fsm = pa_fpu::result_valid_st;

      pa_fpu::div_start_st:
        next_state_fpu_fsm = pa_fpu::div_end_st;

      pa_fpu::div_end_st:
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
    end
    else begin
      case(next_state_fpu_fsm)
        pa_fpu::idle_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b0;         
          status  <= '0;
        end
        pa_fpu::add_start_st: begin
          cmd_end <= 1'b1;
          busy    <= 1'b0;         
          status  <= '0;
        end
        pa_fpu::sub_start_st: begin
          cmd_end <= 1'b1;
          busy    <= 1'b0;         
          status  <= '0;
        end
        pa_fpu::mul_start_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
        end
        pa_fpu::mul_end_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
        end
        pa_fpu::div_start_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
        end
        pa_fpu::div_end_st: begin
          cmd_end <= 1'b0;
          busy    <= 1'b1;         
          status  <= '0;
        end
        pa_fpu::result_valid_st: begin
          cmd_end <= 1'b1;
          busy    <= 1'b1;         
          status  <= '0;
        end
      endcase  
    end
  end

  // Next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) 
      curr_state_fpu_fsm <= idle_st;
    else 
      curr_state_fpu_fsm <= next_state_fpu_fsm;
  end

endmodule


/*
*** a = multiplicand,  tdr = product register left,  b = multiplier
*** output: ab = result

mdrl = 0 (reset counter)
tdr = 0 (reset product register left byte)


0xAC, "mul a, b"{       a,b 16 bits each, result is 
mdrl = 0 (reset counter)
tdr = 0 (reset product register left byte)
  0{
    next = next_offset
    offset = 1
    alu_op = y
    alu_mode = logic
    mdrl_wrt = true
    tdrl_wrt = true
    tdrh_wrt = true
  }

mdrl = mdrl + 1
  1{
    next = next_offset
    offset = 1
    alu_x = mdrl
    alu_op = plus
    mdrl_wrt = true
    immediate = 1
  }

bl AND 0x01   ( test product[0] )
save u_zf
  2{
    next = next_offset
    offset = 1
    uzf_in_src = alu_zf  
    alu_x = bl
    alu_op = and
    alu_mode = logic
    immediate = 1
  }

if u_zf == 1 jump +3 (means product[0] is 0)
else +1
also clear u-cf, so that if we are jumping the addition, the carry will
be clear and wont interfere with the shift.
  3{
    next = next_branch
    offset = 3  
    cond_flags_src = micro_flags
    ucf_in_src = alu_final_cf
    alu_op = plus
    alu_cf_out_inv = true
  }

tdrl = al + tdrl
  4{
    next = next_offset
    offset = 1
    ucf_in_src = alu_final_cf
    alu_op = plus
    alu_cf_out_inv = true
    alu_y = tdrl  
    tdrl_wrt = true
  }

tdrh = ah + tdrh
  5{
    next = next_offset
    offset = 1
    ucf_in_src = alu_final_cf
    alu_x = ah
    alu_op = plus
    alu_cf_in = ucf
    alu_cf_in_inv = true
    alu_cf_out_inv = true
    alu_y = tdrh  tdrh_wrt = true
  }

shr tdrh by one position
save u_cf (ALU_0)
  6{
    next = next_offset
    offset = 1
    ucf_in_src = alu_out_0
    shift_src = ucf
    zbus_out_src = shifted_right
    alu_x = tdrh
    alu_op = x
    alu_mode = logic
    tdrh_wrt = true
  }

shr tdrl by one position
save u_cf (ALU_0)
  7{
    next = next_offset
    offset = 1
    ucf_in_src = alu_out_0
    shift_src = ucf
    zbus_out_src = shifted_right
    alu_x = tdrl
    alu_op = x
    alu_mode = logic
    tdrl_wrt = true
  }

shr bh by one position
u_cf enters MSB of bh (fromTDRL LSB drop)
save u_cf (ALU_0)
  8{
    next = next_offset
    offset = 1
    ucf_in_src = alu_out_0
    shift_src = ucf
    zbus_out_src = shifted_right
    alu_x = bh
    alu_op = x
    alu_mode = logic
    bh_wrt = true
  }

shr bl by one position
u_cf enters MSB of bl (from BH LSB drop)
  9{
    next = next_offset
    offset = 1
    shift_src = ucf
    zbus_out_src = shifted_right
    alu_x = bl
    alu_op = x
    alu_mode = logic
    bl_wrt = true
  }

mdrl - 16 (compare)
save u_zf
  10{
    next = next_offset
    offset = 1
    uzf_in_src = alu_zf  
    alu_x = mdrl
    alu_op = minus
    alu_cf_in_inv = true
    immediate = 16
  }

if not zero, jump -10
else +1
  11{
    next = next_branch
    offset = -10
    condition_inv = true
    cond_flags_src = micro_flags
  }

al = tdrl 
  12{
    next = next_offset
    offset = 1
    alu_op = y
    alu_mode = logic
    alu_y = tdrl  
    al_wrt = true
  }

ah = tdrh
  13{
    next = next_fetch
    alu_op = y
    alu_mode = logic
    alu_y = tdrh  ah_wrt = true
  }
*/