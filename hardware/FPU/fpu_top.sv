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
  logic [31:0] operand_b;
  logic [31:0] result;

  logic [7:0] status;
  logic [3:0] operation; // arithmetic operation to be performed

  logic op_written;

  pa_fpu::e_fpu_state curr_state_fpu_fsm;
  pa_fpu::e_fpu_state next_state_fpu_fsm;

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
      operation  = 4'h0;  
      op_written  = 1'b0;
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
          operation            = databus_in[3:0];
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
      result <= '0;
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
