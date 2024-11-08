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
    op_k_pi,
    op_k_piby2,
    op_2pi
  } e_fpu_operation;

  typedef enum logic[3:0]{
    idle_st,
    add_start_st,
    sub_start_st,
    mul_start_st,
    square_set_b_st,
    mul_product_add_st,
    mul_product_shift_st,
    mul_result_set_st,
    mul_end_st,
    div_start_st,
    div_end_st,
    result_valid_st,

    k_start_st
  } e_arith_state;

  typedef enum logic[3:0]{
    main_idle_st,
    main_wait_st,
    main_finish_st,
    main_wait_ack_st,

    main_
  } e_main_state;


endpackage