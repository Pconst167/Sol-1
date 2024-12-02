onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpu_tb/fpu_top/arst
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate /fpu_tb/fpu_top/databus_in
add wave -noupdate /fpu_tb/fpu_top/databus_out
add wave -noupdate /fpu_tb/fpu_top/addr
add wave -noupdate /fpu_tb/fpu_top/cs
add wave -noupdate /fpu_tb/fpu_top/rd
add wave -noupdate /fpu_tb/fpu_top/wr
add wave -noupdate /fpu_tb/fpu_top/end_ack
add wave -noupdate /fpu_tb/fpu_top/cmd_end
add wave -noupdate /fpu_tb/fpu_top/busy
add wave -noupdate -radix binary /fpu_tb/fpu_top/ieee_packet
add wave -noupdate -radix binary /fpu_tb/fpu_top/operand_a
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp
add wave -noupdate /fpu_tb/fpu_top/a_sign
add wave -noupdate -radix binary /fpu_tb/fpu_top/operand_b
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp
add wave -noupdate /fpu_tb/fpu_top/b_sign
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp_no_bias
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp_no_bias
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/ab_exp_diff
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/ba_exp_diff
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_add
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_add
add wave -noupdate /fpu_tb/fpu_top/result_sign_add
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_sub
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_sub
add wave -noupdate /fpu_tb/fpu_top/result_sign_sub
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_mul
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_mul
add wave -noupdate /fpu_tb/fpu_top/result_sign_mul
add wave -noupdate -radix binary /fpu_tb/fpu_top/product_multiplier
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/mul_cycle_counter
add wave -noupdate /fpu_tb/fpu_top/product_add
add wave -noupdate /fpu_tb/fpu_top/product_shift
add wave -noupdate /fpu_tb/fpu_top/start_operation_mul_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_mul_fsm
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_div
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_div
add wave -noupdate /fpu_tb/fpu_top/result_sign_div
add wave -noupdate -radix binary /fpu_tb/fpu_top/remainder_dividend
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/div_counter
add wave -noupdate /fpu_tb/fpu_top/div_shift
add wave -noupdate /fpu_tb/fpu_top/div_set_a0_1
add wave -noupdate /fpu_tb/fpu_top/start_operation_div_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_div_fsm
add wave -noupdate -radix binary /fpu_tb/fpu_top/sqrt_xn
add wave -noupdate -radix binary /fpu_tb/fpu_top/sqrt_xnp1
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/sqrt_counter
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_sqrt
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_sqrt
add wave -noupdate /fpu_tb/fpu_top/sqrt_div
add wave -noupdate /fpu_tb/fpu_top/sqrt_shift
add wave -noupdate /fpu_tb/fpu_top/sqrt_add
add wave -noupdate /fpu_tb/fpu_top/start_operation_sqrt_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_sqrt_fsm
add wave -noupdate /fpu_tb/fpu_top/operation
add wave -noupdate /fpu_tb/fpu_top/start_operation
add wave -noupdate /fpu_tb/fpu_top/operation_wrt
add wave -noupdate /fpu_tb/fpu_top/new_operation
add wave -noupdate /fpu_tb/fpu_top/start_operation_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate /fpu_tb/fpu_top/curr_state_main_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_arith_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_mul_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_div_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_sqrt_fsm
add wave -noupdate -radix hexadecimal /fpu_tb/fpu_top/ieee_packet
add wave -noupdate -radix binary /fpu_tb/fpu_top/ieee_packet
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {7319 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
configure wave -valuecolwidth 473
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 45
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {24675 ns}
