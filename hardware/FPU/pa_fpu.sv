package pa_fpu;

  typedef enum logic[3:0]{
    op_add = 4'h0,
    op_sub = 4'h1,
    op_mul,
    op_square,
    op_div,
    op_sqrt,
    op_sin,
    op_cos,
    op_tan,
    op_ln,
    op_exp,
    op_int_to_float,
    op_float_to_int
  } e_fpu_operations;

  typedef enum logic[3:0]{
    main_idle_st,
    main_wait_st,
    main_finish_st,
    main_wait_ack_st
  } e_main_states;

  typedef enum logic[3:0]{
    arith_idle_st,
    arith_add_st,
    arith_sub_st,
    arith_mul_st,
    arith_mul_done_st,
    arith_div_st,
    arith_div_done_st,
    arith_result_valid_st
  } e_arith_states;

  typedef enum logic [2:0]{
    mul_idle_st,
    mul_start_st,
    mul_product_add_st,
    mul_product_shift_st,
    mul_result_set_st,
    mul_result_valid_st
  } e_mul_states;

  typedef enum logic [2:0]{
    div_idle_st,
    div_start_st,
    div_shift_st,
    div_sub_divisor_test_st,
    div_set_a0_1_st,
    div_check_counter_st,
    div_result_valid_st
  } e_div_states;

  typedef enum logic [2:0]{
    sqrt_idle_st,
    sqrt_start_st,
    sqrt_div_setup_st,
    sqrt_wait_div_done_st,
    sqrt_addition_setup_st,
    sqrt_shift_st,
    sqrt_check_counter_st,
    sqrt_result_valid_st
  } e_sqrt_states;

endpackage