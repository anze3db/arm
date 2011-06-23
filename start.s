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
_6:
ldrsh r1, _6STEV1 
ldrb  r2, _6STEV2
ldrsb r3, _6STEV3
add r2, r3
sub r2, r1

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

_7:
ldr r2, _7STEV2
ldr r3, _7STEV3
ldr r1, _7STEV1 /* mov r1, #0 */
adds r1,r2,r3
str r1, _7STEV1
/* Z=1, C=1 */

_8:
ldr r1, _7STEV3
tst r1, #0x80000000
mvnne r1, r1
addne r2, r1, #1
str r1, STEV3
str r2, STEV2

_9:
mov r0, #128
mov r1, #0
adr r2, TABELA
_9zanka:   
subs r0, #1
str r1, [r2, r0, lsl #2]
bne _9zanka


_10:
ldr r1, STEV1
ldr r2, STEV2
cmp r2, r1
movgt r1, r2

_15:
mov r0, #10
ldr r1, =123345
mov r2, #4
bl podpr15
b _wait_for_ever

podpr15:
stmfd sp!, {r3-r4, lr}
ldr r3, =0xFFFFFFFF
mvn r3, r3, lsr r2

mov r4, r1, ror r2
and r4, r3

mov r0, r0, lsr r2
orr r0, r4 
mov r1, r1, lsr r2   

ldmfd sp!, {r3-r4, pc}

/* variables here */
.align 4
TABELA: .space 128

_7STEV1: .space 4
_7STEV2: .word  0x7FFFFFFF
_7STEV3: .word  0x8000

_6STEV1: .hword -10
_6STEV2: .byte 0x64
_6STEV3: .byte -2

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

