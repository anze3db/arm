.text
.code 32

.global _swi, _reserved, _undef, _abort_pref, _abort_data, _fiq, _irq  
_swi:
  b _swi
_reserved:
  b _reserved
_abort_pref:
  b _abort_pref
_abort_data:
  b _abort_data
_undef:
  b _undef  
_fiq:
  b _fiq
_irq:
  b _irq
  
.global	__start
__start:

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
                                   
.global _main
/* main program */
_main:
/* user code */
b _prob1
_utr1:

ldr r1, VAR1
str r1, VAR2

_prob8:
mov r0, #2
mov r1, #3
bl multiply16

multiply16:
stmfd r13!, {r1-r5,r14}

ldr r5, =65535
cmp r1, r5
movgt r0, #-1
bgt _end8
cmp r1, #0
movmi r0, #-1
bmi _end8

/* mov r2, #0  product */
ldr r3, =32768 /* power2 */
mov r4, #15 /* exp */

_while8:
cmp r1, r3
addge r2, r0, LSL r4
subge r1, r3

sub r4, #1 
movs r3, r3, LSR #1 
bne _while8

_end8:
mov r0, r2
ldmfd r13!, {r1-r5,pc} 



_prob7:
adr r0, TABLE7
mov r1, #5

bl _subprgr7 

_subprgr7:
stmfd r13!, {r1-r4,r14}

_loop7:
ldrsh r3, [r0], #2
cmp r3, #0
addlt r4, #1
subs r1, #1
bne _loop7
mov r0, r4
ldmfd r13!, {r1-r4,pc} 



_prob6d:
adr r0, TABLE1
ldmia r0, {r1-r5}
adr r0, TABLE2
stmia r0, {r1-r5}

_prob6c:
mov r0, #5
adr r1, TABLE1
adr r2, TABLE2
loop6c:
subs r0, #1 
ldr r3, [r1, r0, LSL #2]
/*str r3, [r2, r0, LSL #2]*/ 
bne loop6c  

_prob6b:
mov r0, #5
adr r1, TABLE1
adr r2, TABLE2
loop6b:
subs r0, #1
ldr r3, [r1], #4
str r3, [r2], #4
bne loop6b

_prob6a:
mov r0, #5
adr r1, TABLE1
adr r2, TABLE2
loop6a:
subs r0, #1
ldr r3, [r1]
str r3, [r2]
add r1, #4
add r2, #4
bne loop6a



_prob5:
mov r0, #3
mov r1, #5

evklid:
cmp r0, r1
subgt r0, r1
suble r1, r0
bne evklid



_prob4:
mov r0, #5
mov r1, #1
mov r2, #2
 
cmp r0, #5
addne r1, r0
subne r1, r2 



_prob3: 
adr r0, spr1
ldr r1, [r0]
ldr r2, [r0,#4]

adr r0, spr2
ldr r3, [r0]
ldr r4, [r0, #4]

adds r5, r1, r3
adc  r6, r2, r4

_prob2:  
movs r0, #0
subs r1, #1
adds r0, #2
    

      
_prob1:
ldr r1, =0x12345678
ldr r1, VAR1

ldr r1, =0x12
ldr r1, VAR2 
mov r1, #0x12

ldrb r1, =128 
ldrb r1, VAR3

ldrsb r2, VAR3

ldrh r1, VAR4

ldrsh r1, VAR4

.utrd1:
ldr r0, STEV1  
str r0, STEV2

/* end user code */

_wait_for_ever:
  b _wait_for_ever


/* variables here */       
STEV1: .word 0x333
STEV2: .word 0x444
  
TABLE7: .hword 1, -1, 2, -4, 0

TABLE1: .word 0x1, 0x2, 0x4, 0x6, 0x10
TABLE2: .space 20

VAR1: .word 0x12345678
VAR2: .word 0x12
VAR3: .byte 128
.align
VAR4: .hword 0xF123
.align
spr1: .word 0xF0000000, 0x00000001
spr2: .word 0x10000000, 0x00000000

/* end variables */


_Lstack_end:
  .long __STACK_END__

.end

