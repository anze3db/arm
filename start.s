.text
.code 32
  
.global	_start
_start:

/* select irq mode */
  mrs r0, cpsr
  bic r0, r0, #0x1F   /* clear mode flags */  
  orr r0, r0, #0xD2   /* set irq mode + DISABLE IRQ, FIQ*/
  msr cpsr, r0     

/* init irq stack */
  ldr sp,_Lirqstack_end

/* select System mode 
  CPSR[4:0]	Mode
  --------------
   10000	  User
   10001	  FIQ
   10010	  IRQ
   10011	  SVC
   10111	  Abort
   11011	  Undef
   11111	  System   
*/

  mrs r0, cpsr
  bic r0, r0, #0x1F   /* clear mode flags */  
  orr r0, r0, #0xDF   /* set system mode + DISABLE IRQ, FIQ*/
  msr cpsr, r0     
  
  /* init stack */
  ldr sp,_Lstack_end
                                   
  /* setup system clocks */
  bl clk_init

  /* enable I cache */
  bl enable_I_cache
  
.global _main
/* main program */
_main:
/* user code */
_3:
adr r0, BIG_STEV1
adr r1, BIG_STEV2
adr r2, BIG_REZ
ldm r0, {r3, r4, r5, r6}
ldm r1, {r7, r8, r9, r10}
adds r6, r10
adcs r5, r9
adcs r4, r8
adcs r3, r7
stm r2, {r3, r4, r5, r6}

_2:
ldr r0, STEV1
ldr r1, STEV2
add r1, r0  
str r1, REZ

ldrb r0, STEV1b
ldrb r1, STEV2b
add r1, r0
strb r1, REZb

ldrh r0, STEV1h
ldrh r1, STEV2h
add r1, r0
strh r1, REZh

_1:
ldr r2, STEV1
str r2, STEV2

/* end user code */

_wait_for_ever:
  b _wait_for_ever


/* variables here */
.align 4
BIG_STEV1: .word 0x1, 0x2, 0x3, 0xFFFFFFFB
BIG_STEV2: .word 0x9, 0x8, 0x7, 0x6
BIG_REZ:   .space 16

REZ:   .space 4
STEV1: .word 0x333
STEV2: .word 0x444

REZb:  .space 1
STEV1b: .byte 0x2
STEV2b: .byte 0x3
.align 4
REZh:  .space 2
STEV1h: .hword 0x5
STEV2h: .hword 0x6
/* end variables */

  .align
_Lstack_end:
  .long __STACK_END__- 2*13*4  @ space for 26 registers on IRQ stack
_Lirqstack_end:
  .long __STACK_END__

.end

