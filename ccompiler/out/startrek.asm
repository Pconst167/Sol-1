; --- FILENAME: games/startrek.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; return (0); 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_starbases: .fill 1, 0
_base_y: .fill 1, 0
_base_x: .fill 1, 0
_starbases_left: .fill 1, 0
_c_data: 
.db 
.db 
.db $0,$0,$0,$ffff,$ffff,$ffff,$0,$1,$1,$1,$0,$1,$1,$1,$0,$ffff,$ffff,$ffff,$0,$1,$1,
.fill 9, 0
_docked: .fill 1, 0
_energy: .fill 2, 0
_energy0: .dw 3000
_map_data: .fill 162, 0
_kdata_data: .fill 12, 0
_klingons: .fill 1, 0
_total_klingons: .fill 1, 0
_klingons_left: .fill 1, 0
_torps: .fill 1, 0
_torps0: .db 10
_quad_y: .fill 2, 0
_quad_x: .fill 2, 0
_shield: .fill 2, 0
_stars: .fill 1, 0
_time_start: .fill 2, 0
_time_up: .fill 2, 0
_damage_data: .fill 18, 0
_d4: .fill 2, 0
_ship_y: .fill 2, 0
_ship_x: .fill 2, 0
_stardate: .fill 2, 0
_quad_data: .fill 64, 0
_quadname_data: .fill 12, 0
_inc_1_data: .db "reports:\n  Incorrect course data, sir!\n", 0
_inc_1: .dw _inc_1_data
_quad_name_data: 
.dw 
.dw _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11, _s12, _s13, _s14, _s15, _s16, 
.fill 34, 0
_device_name_data: 
.dw 
.dw _s0, _s17, _s18, _s19, _s20, _s21, _s22, _s23, _s24, 
.fill 18, 0
_dcr_1_data: .db "Damage Control report:", 0
_dcr_1: .dw _dcr_1_data
_s0: .db "", 0
_s1: .db "Antares", 0
_s2: .db "Rigel", 0
_s3: .db "Procyon", 0
_s4: .db "Vega", 0
_s5: .db "Canopus", 0
_s6: .db "Altair", 0
_s7: .db "Sagittarius", 0
_s8: .db "Pollux", 0
_s9: .db "Sirius", 0
_s10: .db "Deneb", 0
_s11: .db "Capella", 0
_s12: .db "Betelgeuse", 0
_s13: .db "Aldebaran", 0
_s14: .db "Regulus", 0
_s15: .db "Arcturus", 0
_s16: .db "Spica", 0
_s17: .db "Warp engines", 0
_s18: .db "Short range sensors", 0
_s19: .db "Long range sensors", 0
_s20: .db "Phaser control", 0
_s21: .db "Photon tubes", 0
_s22: .db "Damage control", 0
_s23: .db "Shield control", 0
_s24: .db "Library computer", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
