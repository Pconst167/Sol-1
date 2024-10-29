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
    add_st,
    sub_st,
    start_mul_st,
    start_div_st,
    end_st
  } e_fpu_state;



endpackage