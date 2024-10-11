package pa_fpu;

  typedef enum logic[3:0]{
    op_add,
    op_sub,
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
    start_add_st,
    start_sub_st,
    start_mul_st,
    start_div_st,
    end_st
  } e_fpu_state;



endpackage