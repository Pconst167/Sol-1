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
    op_exp
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
    arith_sine_st,
    arith_sine_done_st,
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

  typedef enum logic [3:0]{
    sine_idle_st,
        sine_a_to_acc_st,
        sine_a_squared_st,
        sine_a_cubed_st,
        sine_1_6_to_b_st,
        sine_a_cubed_times_1_6_st,
        sine_a_to_b_st,
        sine_acc_to_a_st,
        sine_a_minus_b_st,
        sine_result_set_st,
        sine_result_valid_st
  } e_sine_states;


endpackage