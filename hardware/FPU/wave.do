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
add wave -noupdate /fpu_tb/fpu_top/operation
add wave -noupdate /fpu_tb/fpu_top/operand_a
add wave -noupdate -radix hexadecimal /fpu_tb/fpu_top/operand_b
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp
add wave -noupdate /fpu_tb/fpu_top/a_sign
add wave -noupdate /fpu_tb/fpu_top/b_sign
add wave -noupdate -radix decimal /fpu_tb/fpu_top/aexp_no_bias
add wave -noupdate -radix decimal /fpu_tb/fpu_top/bexp_no_bias
add wave -noupdate -radix decimal /fpu_tb/fpu_top/ab_exp_diff
add wave -noupdate -radix decimal /fpu_tb/fpu_top/ba_exp_diff
add wave -noupdate -radix decimal /fpu_tb/fpu_top/aexp_after_adjust
add wave -noupdate -radix decimal /fpu_tb/fpu_top/bexp_after_adjust
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_after_adjust
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_after_adjust
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate /fpu_tb/fpu_top/end_ack
add wave -noupdate /fpu_tb/fpu_top/cmd_end
add wave -noupdate /fpu_tb/fpu_top/busy
add wave -noupdate /fpu_tb/fpu_top/curr_state_main_fsm
add wave -noupdate /fpu_tb/fpu_top/start_operation_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/start_operation_mul_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_arith_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_mul_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_mul_fsm
add wave -noupdate /fpu_tb/fpu_top/mul_cycle_counter
add wave -noupdate /fpu_tb/fpu_top/product_add
add wave -noupdate /fpu_tb/fpu_top/product_shift
add wave -noupdate -radix binary /fpu_tb/fpu_top/temp_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/temp_mantissa_plus_epsilon
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_add_sub
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_add_sub
add wave -noupdate /fpu_tb/fpu_top/result_sign_add_sub
add wave -noupdate /fpu_tb/fpu_top/result_ieee_packet
add wave -noupdate /fpu_tb/fpu_top/multiplicand
add wave -noupdate /fpu_tb/fpu_top/product_multiplier
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {16703 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 268
configure wave -valuecolwidth 320
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
