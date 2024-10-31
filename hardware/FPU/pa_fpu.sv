package pa_fpu;

  typedef enum logic[3:0]{
    op_add = 4'h0,
    op_sub = 4'h1,
    op_mul,
    op_div,
    op_sqrt,
    op_sin,
    op_cos,
    op_tan,
    op_ln,
    op_exp
  } e_fpu_operation;

  typedef enum logic[3:0]{
    idle_st,
    add_start_st,
    add_end_st,
    add_result_set_st,
    sub_start_st,
    sub_end_st,
    sub_result_set_st,
    mul_start_st,
    mul_product_add_st,
    mul_product_shift_st,
    mul_result_set_st,
    mul_end_st,
    div_start_st,
    div_end_st,
    result_valid_st,
    end_st
  } e_fpu_state;



endpackage