; --- FILENAME: programs/wumpus.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int c; 
  sub sp, 2
; c = getlet("INSTRUCTIONS (Y-N): "); 
  lea d, [bp + -1] ; $c
  push d
_ternary1_cond:
; --- START FUNCTION CALL
_ternary1_cond:
  mov b, _s0 ; "INSTRUCTIONS (Y-N): "
  swp b
  push b
  call getlet
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (c == 'Y') { 
_if1_cond:
_ternary2_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000059
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if1_exit
_if1_TRUE:
; print_instructions(); 
_ternary2_cond:
; --- START FUNCTION CALL
  call print_instructions
  jmp _if1_exit
_if1_exit:
; do {  
_do2_block:
; game_setup(); 
_ternary3_cond:
; --- START FUNCTION CALL
  call game_setup
; game_play(); 
_ternary3_cond:
; --- START FUNCTION CALL
  call game_play
; } while (getlet("NEW GAME (Y-N): ") != 'N'); 
_do2_cond:
_ternary3_cond:
; --- START FUNCTION CALL
_ternary3_cond:
  mov b, _s1 ; "NEW GAME (Y-N): "
  swp b
  push b
  call getlet
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000004e
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 1
  je _do2_block
_do2_exit:
; return 0; 
_ternary3_cond:
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

getnum:
  enter 0 ; (push bp; mov bp, sp)
; int n; 
  sub sp, 2
; print(prompt); 
_ternary3_cond:
; --- START FUNCTION CALL
_ternary3_cond:
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; n = scann(); 
  lea d, [bp + -1] ; $n
  push d
_ternary3_cond:
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; return n; 
_ternary3_cond:
  lea d, [bp + -1] ; $n
  mov b, [d]
  mov c, 0
  leave
  ret

getlet:
  enter 0 ; (push bp; mov bp, sp)
; char c = '\n'; 
  sub sp, 1
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + 0] ; $c
  push d
_ternary3_cond:
  mov32 cb, $0000000a
  pop d
  mov [d], bl
; --- END LOCAL VAR INITIALIZATION
; print(prompt); 
_ternary3_cond:
; --- START FUNCTION CALL
_ternary3_cond:
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; while (c == '\n') { 
_while3_cond:
_ternary4_cond:
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while3_exit
_while3_block:
; c = getchar(); 
  lea d, [bp + 0] ; $c
  push d
_ternary4_cond:
; --- START FUNCTION CALL
  call getchar
  pop d
  mov [d], bl
  jmp _while3_cond
_while3_exit:
; return toupper(c); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call toupper
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

print_instructions:
  enter 0 ; (push bp; mov bp, sp)
; print("Welcome to 'hunt the wumpus'\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s2 ; "Welcome to 'hunt the wumpus'\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("The wumpus lives in a cave of 20 rooms. Each room\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s3 ; "The wumpus lives in a cave of 20 rooms. Each room\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("has 3 tunnels leading to other rooms.\n");  
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s4 ; "has 3 tunnels leading to other rooms.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("Look at a dodecahedron to see how this works.\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s5 ; "Look at a dodecahedron to see how this works.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s6 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" Hazards:\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s7 ; " Hazards:\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" Bottomless pits: Two rooms have bottomless pits in them\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s8 ; " Bottomless pits: Two rooms have bottomless pits in them\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" If you go there, you fall into the pit (& lose!)\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s9 ; " If you go there, you fall into the pit (& lose!)\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s10 ; " SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s11 ; " GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s12 ; " ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" WUMPUS:\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s13 ; " WUMPUS:\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s14 ; " THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s15 ; " FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s16 ; " HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" ARROW OR YOU ENTERING HIS ROOM.\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s17 ; " ARROW OR YOU ENTERING HIS ROOM.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s18 ; " IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s19 ; " OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" ARE, HE EATS YOU UP AND YOU LOSE!\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s20 ; " ARE, HE EATS YOU UP AND YOU LOSE!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s6 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" YOU:\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s21 ; " YOU:\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s22 ; " EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s23 ; " MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s24 ; " ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s25 ; " EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s26 ; "   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s27 ; "   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   AT RANDOM TO THE NEXT ROOM.\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s28 ; "   AT RANDOM TO THE NEXT ROOM.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s29 ; "     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("     IF THE ARROW HITS YOU, YOU LOSE.\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s30 ; "     IF THE ARROW HITS YOU, YOU LOSE.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" WARNINGS:\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s31 ; " WARNINGS:\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s32 ; " WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" THE COMPUTER SAYS:\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s33 ; " THE COMPUTER SAYS:\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" WUMPUS:  'I SMELL A WUMPUS'\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s34 ; " WUMPUS:  'I SMELL A WUMPUS'\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" BAT   :  'BATS NEARBY'\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s35 ; " BAT   :  'BATS NEARBY'\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" PIT   :  'I FEEL A DRAFT'\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s36 ; " PIT   :  'I FEEL A DRAFT'\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s6 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

show_room:
  enter 0 ; (push bp; mov bp, sp)
; int room, k; 
  sub sp, 2
  sub sp, 2
; print("\n"); 
_ternary4_cond:
; --- START FUNCTION CALL
_ternary4_cond:
  mov b, _s6 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; for (k = 0; k < 3; k++) { 
_for4_init:
  lea d, [bp + -3] ; $k
  push d
_ternary5_cond:
  mov32 cb, $00000000
  pop d
  mov [d], b
_for4_cond:
_ternary5_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for4_exit
_for4_block:
; room = cave[loc[	    0   ]][k]; 
  lea d, [bp + -1] ; $room
  push d
_ternary5_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary5_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary5_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary5_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; if (room == loc[	1      ]) { 
_if5_cond:
_ternary6_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary6_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_else
_if5_TRUE:
; print("I SMELL A WUMPUS!\n"); 
_ternary6_cond:
; --- START FUNCTION CALL
_ternary6_cond:
  mov b, _s37 ; "I SMELL A WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if5_exit
_if5_else:
; if (room == loc[	2    ] || room == loc[	3    ]) { 
_if6_cond:
_ternary7_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary7_cond:
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary7_cond:
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if6_else
_if6_TRUE:
; print("I FEEL A DRAFT\n"); 
_ternary7_cond:
; --- START FUNCTION CALL
_ternary7_cond:
  mov b, _s38 ; "I FEEL A DRAFT\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if6_exit
_if6_else:
; if (room == loc[	4     ] || room == loc[	5     ]) { 
_if7_cond:
_ternary8_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary8_cond:
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary8_cond:
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if7_exit
_if7_TRUE:
; print("BATS NEARBY!\n"); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov b, _s39 ; "BATS NEARBY!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if7_exit
_if7_exit:
_if6_exit:
_if5_exit:
_for4_update:
_ternary8_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, a
  jmp _for4_cond
_for4_exit:
; print("YOU ARE IN ROOM "); print_unsigned(loc[	    0   ]+1); print("\n"); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov b, _s40 ; "YOU ARE IN ROOM "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[	    0   ]+1); print("\n"); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary8_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov b, _s6 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("TUNNELS LEAD TO ");  
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov b, _s41 ; "TUNNELS LEAD TO "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(cave[loc[	    0   ]][0]+1); print(", "); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary8_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary8_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary8_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(", "); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov b, _s42 ; ", "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(cave[loc[	    0   ]][1]+1); print(", "); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary8_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary8_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary8_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(", "); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov b, _s42 ; ", "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(cave[loc[	    0   ]][2]+1); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary8_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary8_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary8_cond:
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print("\n\n"); 
_ternary8_cond:
; --- START FUNCTION CALL
_ternary8_cond:
  mov b, _s43 ; "\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

move_or_shoot:
  enter 0 ; (push bp; mov bp, sp)
; int c = -1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $c
  push d
_ternary8_cond:
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; while ((c != 'S') && (c != 'M')) { 
_while8_cond:
_ternary9_cond:
_ternary9_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000053
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
_ternary9_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000004d
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while8_exit
_while8_block:
; c = getlet("SHOOT OR MOVE (S-M): "); 
  lea d, [bp + -1] ; $c
  push d
_ternary9_cond:
; --- START FUNCTION CALL
_ternary9_cond:
  mov b, _s44 ; "SHOOT OR MOVE (S-M): "
  swp b
  push b
  call getlet
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _while8_cond
_while8_exit:
; return (c == 'S') ? 1 : 0; 
_ternary9_cond:
_ternary9_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000053
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary9_FALSE
_ternary9_TRUE:
_ternary10_cond:
  mov32 cb, $00000001
  jmp _ternary9_exit
_ternary9_FALSE:
_ternary10_cond:
  mov32 cb, $00000000
_ternary9_exit:
  leave
  ret

move_wumpus:
  enter 0 ; (push bp; mov bp, sp)
; int k; 
  sub sp, 2
; k = rand2() % 4; 
  lea d, [bp + -1] ; $k
  push d
_ternary10_cond:
; --- START FUNCTION CALL
  call rand2
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000004
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; if (k < 3) { 
_if11_cond:
_ternary12_cond:
  lea d, [bp + -1] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if11_exit
_if11_TRUE:
; loc[	1      ] = cave[loc[	1      ]][k]; 
  mov d, _loc_data ; $loc
  push a
  push d
_ternary12_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary12_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary12_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary12_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary12_cond:
  lea d, [bp + -1] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if11_exit
_if11_exit:
; if (loc[	1      ] == loc[	    0   ]) { 
_if12_cond:
_ternary13_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary13_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary13_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if12_exit
_if12_TRUE:
; print("TSK TSK TSK - WUMPUS GOT YOU!\n"); 
_ternary13_cond:
; --- START FUNCTION CALL
_ternary13_cond:
  mov b, _s45 ; "TSK TSK TSK - WUMPUS GOT YOU!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; finished = 	2    ; 
  mov d, _finished ; $finished
  push d
_ternary13_cond:
  mov32 cb, $00000002
  pop d
  mov [d], b
  jmp _if12_exit
_if12_exit:
  leave
  ret

shoot:
  enter 0 ; (push bp; mov bp, sp)
; int path[5]; 
  sub sp, 10
; int scratchloc = -1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $scratchloc
  push d
_ternary13_cond:
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int len, k; 
  sub sp, 2
  sub sp, 2
; finished = 	     0   ; 
  mov d, _finished ; $finished
  push d
_ternary13_cond:
  mov32 cb, $00000000
  pop d
  mov [d], b
; len = -1; 
  lea d, [bp + -13] ; $len
  push d
_ternary13_cond:
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; while (len < 1 || len > 5) { 
_while13_cond:
_ternary14_cond:
  lea d, [bp + -13] ; $len
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _while13_exit
_while13_block:
; len = getnum("\nNUMBER OF ROOMS (1-5): "); 
  lea d, [bp + -13] ; $len
  push d
_ternary14_cond:
; --- START FUNCTION CALL
_ternary14_cond:
  mov b, _s46 ; "\nNUMBER OF ROOMS (1-5): "
  swp b
  push b
  call getnum
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _while13_cond
_while13_exit:
; k = 0; 
  lea d, [bp + -15] ; $k
  push d
_ternary14_cond:
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (k < len) { 
_while14_cond:
_ternary15_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while14_exit
_while14_block:
; path[k] = getnum("ROOM #") - 1; 
  lea d, [bp + -9] ; $path
  push a
  push d
_ternary15_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary15_cond:
; --- START FUNCTION CALL
_ternary15_cond:
  mov b, _s47 ; "ROOM #"
  swp b
  push b
  call getnum
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if ((k>1) && (path[k] == path[k - 2])) { 
_if15_cond:
_ternary16_cond:
_ternary16_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
_ternary16_cond:
  lea d, [bp + -9] ; $path
  push a
  push d
_ternary16_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
_ternary16_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if15_exit
_if15_TRUE:
; print("ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n"); 
_ternary16_cond:
; --- START FUNCTION CALL
_ternary16_cond:
  mov b, _s48 ; "ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; continue;  
  jmp _while14_cond ; while continue
  jmp _if15_exit
_if15_exit:
; k++; 
_ternary16_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -15] ; $k
  mov [d], b
  mov b, a
  jmp _while14_cond
_while14_exit:
; scratchloc = loc[	    0   ]; 
  lea d, [bp + -11] ; $scratchloc
  push d
_ternary16_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary16_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for (k = 0; k < len; k++) { 
_for16_init:
  lea d, [bp + -15] ; $k
  push d
_ternary17_cond:
  mov32 cb, $00000000
  pop d
  mov [d], b
_for16_cond:
_ternary17_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for16_exit
_for16_block:
; if ((cave[scratchloc][0] == path[k]) || 
_if17_cond:
_ternary18_cond:
_ternary18_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary18_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary18_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
_ternary18_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
_ternary18_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary18_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary18_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
_ternary18_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
_ternary18_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary18_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary18_cond:
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
_ternary18_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if17_else
_if17_TRUE:
; scratchloc = path[k]; 
  lea d, [bp + -11] ; $scratchloc
  push d
_ternary18_cond:
  lea d, [bp + -9] ; $path
  push a
  push d
_ternary18_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if17_exit
_if17_else:
; scratchloc = cave[scratchloc][rand2()%3]; 
  lea d, [bp + -11] ; $scratchloc
  push d
_ternary18_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary18_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary18_cond:
; --- START FUNCTION CALL
  call rand2
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000003
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if17_exit:
; if (scratchloc == loc[	1      ]) { 
_if19_cond:
_ternary20_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary20_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_else
_if19_TRUE:
; print("AHA! YOU GOT THE WUMPUS!\n"); 
_ternary20_cond:
; --- START FUNCTION CALL
_ternary20_cond:
  mov b, _s49 ; "AHA! YOU GOT THE WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; finished = 	     1   ; 
  mov d, _finished ; $finished
  push d
_ternary20_cond:
  mov32 cb, $00000001
  pop d
  mov [d], b
  jmp _if19_exit
_if19_else:
; if (scratchloc == loc[	    0   ]) { 
_if20_cond:
_ternary21_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary21_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if20_exit
_if20_TRUE:
; print("OUCH! ARROW GOT YOU!\n"); 
_ternary21_cond:
; --- START FUNCTION CALL
_ternary21_cond:
  mov b, _s50 ; "OUCH! ARROW GOT YOU!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; finished = 	2    ; 
  mov d, _finished ; $finished
  push d
_ternary21_cond:
  mov32 cb, $00000002
  pop d
  mov [d], b
  jmp _if20_exit
_if20_exit:
_if19_exit:
; if (finished != 	     0   ) { 
_if21_cond:
_ternary22_cond:
  mov d, _finished ; $finished
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if21_exit
_if21_TRUE:
; return; 
  leave
  ret
  jmp _if21_exit
_if21_exit:
_for16_update:
_ternary22_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -15] ; $k
  mov [d], b
  mov b, a
  jmp _for16_cond
_for16_exit:
; print("MISSED\n"); 
_ternary22_cond:
; --- START FUNCTION CALL
_ternary22_cond:
  mov b, _s51 ; "MISSED\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; move_wumpus(); 
_ternary22_cond:
; --- START FUNCTION CALL
  call move_wumpus
; if (--arrows <= 0) { 
_if22_cond:
_ternary23_cond:
  mov d, _arrows ; $arrows
  mov b, [d]
  dec b
  mov d, _arrows ; $arrows
  mov [d], b
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if22_exit
_if22_TRUE:
; finished = 	2    ; 
  mov d, _finished ; $finished
  push d
_ternary23_cond:
  mov32 cb, $00000002
  pop d
  mov [d], b
  jmp _if22_exit
_if22_exit:
  leave
  ret

move:
  enter 0 ; (push bp; mov bp, sp)
; int scratchloc; 
  sub sp, 2
; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
_ternary23_cond:
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; while (scratchloc == -1) { 
_while23_cond:
_ternary24_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while23_exit
_while23_block:
; scratchloc = getnum("\nWHERE TO: ")- 1; 
  lea d, [bp + -1] ; $scratchloc
  push d
_ternary24_cond:
; --- START FUNCTION CALL
_ternary24_cond:
  mov b, _s52 ; "\nWHERE TO: "
  swp b
  push b
  call getnum
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (scratchloc < 0 || scratchloc > 19) { 
_if24_cond:
_ternary25_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000013
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
_ternary25_cond:
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; continue; 
  jmp _while23_cond ; while continue
  jmp _if24_exit
_if24_exit:
; if ((cave[loc[	    0   ]][0] != scratchloc) & 
_if25_cond:
_ternary26_cond:
_ternary26_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary26_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary26_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary26_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  push a
  mov a, b
_ternary26_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary26_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary26_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary26_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  and b, a ; &
  mov a, b
_ternary26_cond:
  mov d, _cave_data ; $cave
  push a
  push d
_ternary26_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary26_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
_ternary26_cond:
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  and b, a ; &
  mov a, b
_ternary26_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary26_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  and b, a ; &
  pop a
  cmp b, 0
  je _if25_exit
_if25_TRUE:
; print("NOT POSSIBLE\n"); 
_ternary26_cond:
; --- START FUNCTION CALL
_ternary26_cond:
  mov b, _s53 ; "NOT POSSIBLE\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
_ternary26_cond:
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; continue; 
  jmp _while23_cond ; while continue
  jmp _if25_exit
_if25_exit:
  jmp _while23_cond
_while23_exit:
; loc[	    0   ] = scratchloc; 
  mov d, _loc_data ; $loc
  push a
  push d
_ternary26_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary26_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while ((scratchloc == loc[	4     ]) || (scratchloc == loc[	5     ])) { 
_while26_cond:
_ternary27_cond:
_ternary27_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary27_cond:
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
_ternary27_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary27_cond:
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _while26_exit
_while26_block:
; print("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"); 
_ternary27_cond:
; --- START FUNCTION CALL
_ternary27_cond:
  mov b, _s54 ; "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; scratchloc = loc[	    0   ] = rand2()%20; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov d, _loc_data ; $loc
  push a
  push d
_ternary27_cond:
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary27_cond:
; --- START FUNCTION CALL
  call rand2
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000014
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  pop d
  mov [d], b
  jmp _while26_cond
_while26_exit:
; if (scratchloc == loc[	1      ]) { 
_if28_cond:
_ternary29_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary29_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if28_exit
_if28_TRUE:
; print("... OOPS! BUMPED A WUMPUS!\n"); 
_ternary29_cond:
; --- START FUNCTION CALL
_ternary29_cond:
  mov b, _s55 ; "... OOPS! BUMPED A WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; move_wumpus(); 
_ternary29_cond:
; --- START FUNCTION CALL
  call move_wumpus
  jmp _if28_exit
_if28_exit:
; if (scratchloc == loc[	2    ] || scratchloc == loc[	3    ]) { 
_if29_cond:
_ternary30_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary30_cond:
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary30_cond:
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if29_exit
_if29_TRUE:
; print("YYYYIIIIEEEE . . . FELL IN PIT\n"); 
_ternary30_cond:
; --- START FUNCTION CALL
_ternary30_cond:
  mov b, _s56 ; "YYYYIIIIEEEE . . . FELL IN PIT\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; finished = 	2    ; 
  mov d, _finished ; $finished
  push d
_ternary30_cond:
  mov32 cb, $00000002
  pop d
  mov [d], b
  jmp _if29_exit
_if29_exit:
  leave
  ret

rand2:
  enter 0 ; (push bp; mov bp, sp)
; rand_val=rand_val+rand_inc; 
  mov d, _rand_val ; $rand_val
  push d
_ternary30_cond:
  mov d, _rand_val ; $rand_val
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _rand_inc ; $rand_inc
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; rand_inc++; 
_ternary30_cond:
  mov d, _rand_inc ; $rand_inc
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _rand_inc ; $rand_inc
  mov [d], b
  mov b, a
; return rand_val; 
_ternary30_cond:
  mov d, _rand_val ; $rand_val
  mov b, [d]
  mov c, 0
  leave
  ret

game_setup:
  enter 0 ; (push bp; mov bp, sp)
; int j, k; 
  sub sp, 2
  sub sp, 2
; int v; 
  sub sp, 2
; for (j = 0; j < 	6    ; j++) { 
_for30_init:
  lea d, [bp + -1] ; $j
  push d
_ternary31_cond:
  mov32 cb, $00000000
  pop d
  mov [d], b
_for30_cond:
_ternary31_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000006
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for30_exit
_for30_block:
; loc[j] = -1; 
  mov d, _loc_data ; $loc
  push a
  push d
_ternary31_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary31_cond:
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; while (loc[j] < 0) { 
_while31_cond:
_ternary32_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary32_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while31_exit
_while31_block:
; v = rand2(); 
  lea d, [bp + -5] ; $v
  push d
_ternary32_cond:
; --- START FUNCTION CALL
  call rand2
  pop d
  mov [d], b
; loc[j] = v % 20; 
  mov d, _loc_data ; $loc
  push a
  push d
_ternary32_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary32_cond:
  lea d, [bp + -5] ; $v
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000014
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; for (k=0; k < j - 1; k++) { 
_for33_init:
  lea d, [bp + -3] ; $k
  push d
_ternary34_cond:
  mov32 cb, $00000000
  pop d
  mov [d], b
_for33_cond:
_ternary34_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for33_exit
_for33_block:
; if (loc[j] == loc[k]) { 
_if34_cond:
_ternary35_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary35_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
_ternary35_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if34_exit
_if34_TRUE:
; loc[j] = -1; 
  mov d, _loc_data ; $loc
  push a
  push d
_ternary35_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary35_cond:
  mov32 cb, $ffffffff
  pop d
  mov [d], b
  jmp _if34_exit
_if34_exit:
_for33_update:
_ternary35_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, a
  jmp _for33_cond
_for33_exit:
  jmp _while31_cond
_while31_exit:
_for30_update:
_ternary35_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $j
  mov [d], b
  mov b, a
  jmp _for30_cond
_for30_exit:
  leave
  ret

game_play:
  enter 0 ; (push bp; mov bp, sp)
; arrows = 5; 
  mov d, _arrows ; $arrows
  push d
_ternary35_cond:
  mov32 cb, $00000005
  pop d
  mov [d], b
; print("HUNT THE WUMPUS\n"); 
_ternary35_cond:
; --- START FUNCTION CALL
_ternary35_cond:
  mov b, _s57 ; "HUNT THE WUMPUS\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; if (debug) { 
_if35_cond:
_ternary36_cond:
  mov d, _debug ; $debug
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if35_exit
_if35_TRUE:
; print("Wumpus is at "); print_unsigned(loc[	1      ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov b, _s58 ; "Wumpus is at "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[	1      ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary36_cond:
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(", pits at "); print_unsigned(loc[	2    ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov b, _s59 ; ", pits at "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[	2    ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary36_cond:
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(" & "); print_unsigned(loc[	3    ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov b, _s60 ; " & "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[	3    ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary36_cond:
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(", bats at "); print_unsigned(loc[	4     ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov b, _s61 ; ", bats at "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[	4     ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary36_cond:
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(" & "); print_unsigned(loc[	5     ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov b, _s60 ; " & "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[	5     ]+1); 
_ternary36_cond:
; --- START FUNCTION CALL
_ternary36_cond:
  mov d, _loc_data ; $loc
  push a
  push d
_ternary36_cond:
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
  jmp _if35_exit
_if35_exit:
; finished = 	     0   ; 
  mov d, _finished ; $finished
  push d
_ternary36_cond:
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (finished == 	     0   ) { 
_while36_cond:
_ternary37_cond:
  mov d, _finished ; $finished
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while36_exit
_while36_block:
; show_room(); 
_ternary37_cond:
; --- START FUNCTION CALL
  call show_room
; if (move_or_shoot()) { 
_if37_cond:
_ternary38_cond:
; --- START FUNCTION CALL
  call move_or_shoot
  cmp b, 0
  je _if37_else
_if37_TRUE:
; shoot(); 
_ternary38_cond:
; --- START FUNCTION CALL
  call shoot
  jmp _if37_exit
_if37_else:
; move(); 
_ternary38_cond:
; --- START FUNCTION CALL
  call move
_if37_exit:
  jmp _while36_cond
_while36_exit:
; if (finished == 	     1   ) { 
_if38_cond:
_ternary39_cond:
  mov d, _finished ; $finished
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if38_exit
_if38_TRUE:
; print("HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n"); 
_ternary39_cond:
; --- START FUNCTION CALL
_ternary39_cond:
  mov b, _s62 ; "HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if38_exit
_if38_exit:
; if (finished == 	2    ) { 
_if39_cond:
_ternary40_cond:
  mov d, _finished ; $finished
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if39_exit
_if39_TRUE:
; print("HA HA HA - YOU LOSE!\n"); 
_ternary40_cond:
; --- START FUNCTION CALL
_ternary40_cond:
  mov b, _s63 ; "HA HA HA - YOU LOSE!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if39_exit
_if39_exit:
; int c; 
  sub sp, 2
; c = getlet("NEW GAME (Y-N): "); 
  lea d, [bp + -1] ; $c
  push d
_ternary40_cond:
; --- START FUNCTION CALL
_ternary40_cond:
  mov b, _s1 ; "NEW GAME (Y-N): "
  swp b
  push b
  call getlet
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (c == 'N') { 
_if40_cond:
_ternary41_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000004e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if40_exit
_if40_TRUE:
; exit(); 
_ternary41_cond:
; --- START FUNCTION CALL
  call exit
  jmp _if40_exit
_if40_exit:
  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
_puts_L1_print:
  mov al, [d]
  cmp al, 0
  jz _puts_END_print
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1_print
_puts_END_print:
; --- END INLINE ASM SEGMENT
  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; char c; 
  sub sp, 1
; --- BEGIN INLINE ASM SEGMENT
  mov al, 1
  syscall sys_io      ; receive in AH
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM SEGMENT
; return c; 
_ternary41_cond:
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret

toupper:
  enter 0 ; (push bp; mov bp, sp)
; if (ch >= 'a' && ch <= 'z')  
_if41_cond:
_ternary42_cond:
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000061
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000007a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if41_else
_if41_TRUE:
; return ch - 'a' + 'A'; 
_ternary42_cond:
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000061
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $00000041
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if41_exit
_if41_else:
; return ch; 
_ternary42_cond:
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
_if41_exit:
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -6] ; $i
  push d
_ternary42_cond:
  mov32 cb, $00000000
  pop d
  mov [d], b
; if(num == 0){ 
_if42_cond:
_ternary43_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if42_exit
_if42_TRUE:
; putchar('0'); 
_ternary43_cond:
; --- START FUNCTION CALL
_ternary43_cond:
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if42_exit
_if42_exit:
; while (num > 0) { 
_while43_cond:
_ternary44_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while43_exit
_while43_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
_ternary44_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
_ternary44_cond:
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
_ternary44_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
_ternary45_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
_ternary46_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  jmp _while43_cond
_while43_exit:
; while (i > 0) { 
_while46_cond:
_ternary47_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while46_exit
_while46_block:
; i--; 
_ternary47_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
_ternary47_cond:
; --- START FUNCTION CALL
_ternary47_cond:
  lea d, [bp + -4] ; $digits
  push a
  push d
_ternary47_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while46_cond
_while46_exit:
  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  mov al, 0
  syscall sys_io      ; char in AH
; --- END INLINE ASM SEGMENT
  leave
  ret

scann:
  enter 0 ; (push bp; mov bp, sp)
; int m; 
  sub sp, 2
; --- BEGIN INLINE ASM SEGMENT
  enter 8
  push si
  push b
  push c
  push d
  lea d, [bp +- 7]
  call _gets_scann
  call _strlen_scann      ; get string length in C
  dec c
  mov si, d
  mov a, c
  shl a
  mov d, table_power_scann
  add d, a
  mov c, 0
mul_loop_scann:
  lodsb      ; load ASCII to al
  cmp al, 0
  je mul_exit_scann
  sub al, $30    ; make into integer
  mov ah, 0
  mov b, [d]
  mul a, b      ; result in B since it fits in 16bits
  mov a, b
  mov b, c
  add a, b
  mov c, a
  sub d, 2
  jmp mul_loop_scann
mul_exit_scann:
  mov a, c
  pop d
  pop c
  pop b
  pop si
  leave
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM SEGMENT
; return m; 
_ternary47_cond:
  lea d, [bp + -1] ; $m
  mov b, [d]
  mov c, 0
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_strlen_scann:
  push d
  mov c, 0
_strlen_L1_scann:
  cmp byte [d], 0
  je _strlen_ret_scann
  inc d
  inc c
  jmp _strlen_L1_scann
_strlen_ret_scann:
  pop d
  ret
_gets_scann:
  push a
  push d
_gets_loop_scann:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_loop_scann      ; if no char received, retry
  cmp ah, 27
  je _gets_ansi_esc_scann
  cmp ah, $0A        ; LF
  je _gets_end_scann
  cmp ah, $0D        ; CR
  je _gets_end_scann
  cmp ah, $5C        ; '\\'
  je _gets_escape_scann
  cmp ah, $08      ; check for backspace
  je _gets_backspace_scann
  mov al, ah
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_backspace_scann:
  dec d
  jmp _gets_loop_scann
_gets_ansi_esc_scann:
  mov al, 1
  syscall sys_io        ; receive in AH without echo
  cmp al, 0          ; check error code (AL)
  je _gets_ansi_esc_scann    ; if no char received, retry
  cmp ah, '['
  jne _gets_loop_scann
_gets_ansi_esc_2_scann:
  mov al, 1
  syscall sys_io          ; receive in AH without echo
  cmp al, 0            ; check error code (AL)
  je _gets_ansi_esc_2_scann  ; if no char received, retry
  cmp ah, 'D'
  je _gets_left_arrow_scann
  cmp ah, 'C'
  je _gets_right_arrow_scann
  jmp _gets_loop_scann
_gets_left_arrow_scann:
  dec d
  jmp _gets_loop_scann
_gets_right_arrow_scann:
  inc d
  jmp _gets_loop_scann
_gets_escape_scann:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_escape_scann      ; if no char received, retry
  cmp ah, 'n'
  je _gets_LF_scann
  cmp ah, 'r'
  je _gets_CR_scann
  cmp ah, '0'
  je _gets_NULL_scann
  cmp ah, $5C  
  je _gets_slash_scann
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_slash_scann:
  mov al, $5C
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_LF_scann:
  mov al, $0A
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_CR_scann:
  mov al, $0D
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_NULL_scann:
  mov al, $00
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_end_scann:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  pop a
  ret
table_power_scann:
.dw 1
.dw 10
.dw 100
.dw 1000
.dw 10000
; --- END INLINE ASM SEGMENT
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  syscall sys_terminate_proc
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_arrows: .fill 2, 0
_debug: .dw $0000
_rand_val: .dw $001d
_rand_inc: .dw $0001
_loc_data: .fill 12, 0
_finished: .fill 2, 0
_cave_data: 
.dw 
.dw 
.dw $0001,$0004,$0007,$0000,$0002,$0009,$0001,$0003,$000b,$0002,$0004,$000d,$0000,$0003,$0005,$0004,$0006,$000e,$0005,$0007,$0010,$0000,$0006,$0008,$0007,$0009,$0011,$0001,$0008,$000a,
.dw 
.dw 
.dw $0009,$000b,$0012,$0002,$000a,$000c,$000b,$000d,$0013,$0003,$000c,$000e,$0005,$000d,$000f,$000e,$0010,$0013,$0006,$000f,$0011,$0008,$0010,$0012,$000a,$0011,$0013,$000c,$000f,$0012,
.dw 
.dw 
_s0: .db "INSTRUCTIONS (Y-N): ", 0
_s1: .db "NEW GAME (Y-N): ", 0
_s2: .db "Welcome to 'hunt the wumpus'\n", 0
_s3: .db "The wumpus lives in a cave of 20 rooms. Each room\n", 0
_s4: .db "has 3 tunnels leading to other rooms.\n", 0
_s5: .db "Look at a dodecahedron to see how this works.\n", 0
_s6: .db "\n", 0
_s7: .db " Hazards:\n", 0
_s8: .db " Bottomless pits: Two rooms have bottomless pits in them\n", 0
_s9: .db " If you go there, you fall into the pit (& lose!)\n", 0
_s10: .db " SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n", 0
_s11: .db " GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n", 0
_s12: .db " ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n", 0
_s13: .db " WUMPUS:\n", 0
_s14: .db " THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n", 0
_s15: .db " FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n", 0
_s16: .db " HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n", 0
_s17: .db " ARROW OR YOU ENTERING HIS ROOM.\n", 0
_s18: .db " IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n", 0
_s19: .db " OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n", 0
_s20: .db " ARE, HE EATS YOU UP AND YOU LOSE!\n", 0
_s21: .db " YOU:\n", 0
_s22: .db " EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n", 0
_s23: .db " MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n", 0
_s24: .db " ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n", 0
_s25: .db " EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n", 0
_s26: .db "   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n", 0
_s27: .db "   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n", 0
_s28: .db "   AT RANDOM TO THE NEXT ROOM.\n", 0
_s29: .db "     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n", 0
_s30: .db "     IF THE ARROW HITS YOU, YOU LOSE.\n", 0
_s31: .db " WARNINGS:\n", 0
_s32: .db " WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n", 0
_s33: .db " THE COMPUTER SAYS:\n", 0
_s34: .db " WUMPUS:  'I SMELL A WUMPUS'\n", 0
_s35: .db " BAT   :  'BATS NEARBY'\n", 0
_s36: .db " PIT   :  'I FEEL A DRAFT'\n", 0
_s37: .db "I SMELL A WUMPUS!\n", 0
_s38: .db "I FEEL A DRAFT\n", 0
_s39: .db "BATS NEARBY!\n", 0
_s40: .db "YOU ARE IN ROOM ", 0
_s41: .db "TUNNELS LEAD TO ", 0
_s42: .db ", ", 0
_s43: .db "\n\n", 0
_s44: .db "SHOOT OR MOVE (S-M): ", 0
_s45: .db "TSK TSK TSK - WUMPUS GOT YOU!\n", 0
_s46: .db "\nNUMBER OF ROOMS (1-5): ", 0
_s47: .db "ROOM #", 0
_s48: .db "ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n", 0
_s49: .db "AHA! YOU GOT THE WUMPUS!\n", 0
_s50: .db "OUCH! ARROW GOT YOU!\n", 0
_s51: .db "MISSED\n", 0
_s52: .db "\nWHERE TO: ", 0
_s53: .db "NOT POSSIBLE\n", 0
_s54: .db "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n", 0
_s55: .db "... OOPS! BUMPED A WUMPUS!\n", 0
_s56: .db "YYYYIIIIEEEE . . . FELL IN PIT\n", 0
_s57: .db "HUNT THE WUMPUS\n", 0
_s58: .db "Wumpus is at ", 0
_s59: .db ", pits at ", 0
_s60: .db " & ", 0
_s61: .db ", bats at ", 0
_s62: .db "HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n", 0
_s63: .db "HA HA HA - YOU LOSE!\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
