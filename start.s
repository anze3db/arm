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
_1:
ldr r2, STEV1
str r2, STEV2

/* end user code */

_wait_for_ever:
  b _wait_for_ever


/* variables here */
STEV1: .word 0x1234
STEV2: .word 0x4321
/* end variables */

  .align
_Lstack_end:
  .long __STACK_END__- 2*13*4  @ space for 26 registers on IRQ stack
_Lirqstack_end:
  .long __STACK_END__

.end

