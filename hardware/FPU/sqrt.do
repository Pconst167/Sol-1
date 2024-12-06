onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpu_tb/fpu_top/arst
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate -radix binary -childformat {{{/fpu_tb/fpu_top/operand_a[31]} -radix binary} {{/fpu_tb/fpu_top/operand_a[30]} -radix binary} {{/fpu_tb/fpu_top/operand_a[29]} -radix binary} {{/fpu_tb/fpu_top/operand_a[28]} -radix binary} {{/fpu_tb/fpu_top/operand_a[27]} -radix binary} {{/fpu_tb/fpu_top/operand_a[26]} -radix binary} {{/fpu_tb/fpu_top/operand_a[25]} -radix binary} {{/fpu_tb/fpu_top/operand_a[24]} -radix binary} {{/fpu_tb/fpu_top/operand_a[23]} -radix binary} {{/fpu_tb/fpu_top/operand_a[22]} -radix binary} {{/fpu_tb/fpu_top/operand_a[21]} -radix binary} {{/fpu_tb/fpu_top/operand_a[20]} -radix binary} {{/fpu_tb/fpu_top/operand_a[19]} -radix binary} {{/fpu_tb/fpu_top/operand_a[18]} -radix binary} {{/fpu_tb/fpu_top/operand_a[17]} -radix binary} {{/fpu_tb/fpu_top/operand_a[16]} -radix binary} {{/fpu_tb/fpu_top/operand_a[15]} -radix binary} {{/fpu_tb/fpu_top/operand_a[14]} -radix binary} {{/fpu_tb/fpu_top/operand_a[13]} -radix binary} {{/fpu_tb/fpu_top/operand_a[12]} -radix binary} {{/fpu_tb/fpu_top/operand_a[11]} -radix binary} {{/fpu_tb/fpu_top/operand_a[10]} -radix binary} {{/fpu_tb/fpu_top/operand_a[9]} -radix binary} {{/fpu_tb/fpu_top/operand_a[8]} -radix binary} {{/fpu_tb/fpu_top/operand_a[7]} -radix binary} {{/fpu_tb/fpu_top/operand_a[6]} -radix binary} {{/fpu_tb/fpu_top/operand_a[5]} -radix binary} {{/fpu_tb/fpu_top/operand_a[4]} -radix binary} {{/fpu_tb/fpu_top/operand_a[3]} -radix binary} {{/fpu_tb/fpu_top/operand_a[2]} -radix binary} {{/fpu_tb/fpu_top/operand_a[1]} -radix binary} {{/fpu_tb/fpu_top/operand_a[0]} -radix binary}} -subitemconfig {{/fpu_tb/fpu_top/operand_a[31]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[30]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[29]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[28]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[27]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[26]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[25]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[24]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[23]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[22]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[21]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[20]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[19]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[18]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[17]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[16]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[15]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[14]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[13]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[12]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[11]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[10]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[9]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[8]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[7]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[6]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[5]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[4]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[3]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[2]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[1]} {-height 20 -radix binary} {/fpu_tb/fpu_top/operand_a[0]} {-height 20 -radix binary}} /fpu_tb/fpu_top/operand_a
add wave -noupdate /fpu_tb/fpu_top/a_sign
add wave -noupdate -radix binary /fpu_tb/fpu_top/operand_b
add wave -noupdate /fpu_tb/fpu_top/b_sign
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp_no_bias
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp_no_bias
add wave -noupdate -radix decimal /fpu_tb/fpu_top/ab_exp_diff
add wave -noupdate -radix decimal /fpu_tb/fpu_top/ba_exp_diff
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp_adjusted
add wave -noupdate -radix binary -childformat {{{/fpu_tb/fpu_top/a_mantissa[25]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[24]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[23]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[22]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[21]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[20]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[19]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[18]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[17]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[16]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[15]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[14]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[13]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[12]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[11]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[10]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[9]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[8]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[7]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[6]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[5]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[4]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[3]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[2]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[1]} -radix binary} {{/fpu_tb/fpu_top/a_mantissa[0]} -radix binary}} -subitemconfig {{/fpu_tb/fpu_top/a_mantissa[25]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[24]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[23]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[22]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[21]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[20]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[19]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[18]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[17]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[16]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[15]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[14]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[13]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[12]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[11]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[10]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[9]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[8]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[7]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[6]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[5]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[4]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[3]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[2]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[1]} {-height 20 -radix binary} {/fpu_tb/fpu_top/a_mantissa[0]} {-height 20 -radix binary}} /fpu_tb/fpu_top/a_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_add
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_add
add wave -noupdate /fpu_tb/fpu_top/result_sign_add
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_div
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_div
add wave -noupdate /fpu_tb/fpu_top/result_sign_div
add wave -noupdate -radix binary /fpu_tb/fpu_top/remainder_dividend
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/div_counter
add wave -noupdate /fpu_tb/fpu_top/div_shift
add wave -noupdate /fpu_tb/fpu_top/div_set_a0_1
add wave -noupdate /fpu_tb/fpu_top/start_operation_div_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/start_operation_div_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_div_fsm
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/sqrt_counter
add wave -noupdate /fpu_tb/fpu_top/sqrt_div_A_by_xn_start
add wave -noupdate /fpu_tb/fpu_top/start_operation_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_main_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_arith_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_div_fsm
add wave -noupdate /fpu_tb/fpu_top/start_operation_sqrt_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_sqrt_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_sqrt_fsm
add wave -noupdate -radix binary /fpu_tb/fpu_top/sqrt_xn_mantissa
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/sqrt_xn_exp
add wave -noupdate /fpu_tb/fpu_top/sqrt_xn_sign
add wave -noupdate -radix binary /fpu_tb/fpu_top/sqrt_A_mantissa
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/sqrt_A_exp
add wave -noupdate /fpu_tb/fpu_top/sqrt_A_sign
add wave -noupdate /fpu_tb/fpu_top/sqrt_xn_A_wrt
add wave -noupdate /fpu_tb/fpu_top/sqrt_xn_a_wrt
add wave -noupdate /fpu_tb/fpu_top/sqrt_xn_add_wrt
add wave -noupdate /fpu_tb/fpu_top/sqrt_A_a_wrt
add wave -noupdate /fpu_tb/fpu_top/sqrt_a_xn_wrt
add wave -noupdate /fpu_tb/fpu_top/sqrt_a_A_wrt
add wave -noupdate /fpu_tb/fpu_top/sqrt_b_xn_wrt
add wave -noupdate /fpu_tb/fpu_top/sqrt_b_div_wrt
add wave -noupdate -radix hexadecimal /fpu_tb/fpu_top/ieee_packet
add wave -noupdate -radix binary /fpu_tb/fpu_top/ieee_packet
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {50250 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
configure wave -valuecolwidth 433
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
WaveRestoreZoom {0 ns} {111300 ns}
