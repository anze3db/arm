.text
.code 32

.global _start, _swi, _reserved, _undef, _abort_pref, _abort_data, _fiq
  B	_start             /* RESET INTERRUPT */
  B	_undef             /* UNDEFINED INSTRUCTION INTERRUPT */
  B	_swi               /* SOFTWARE INTERRUPT */
  B	_abort_pref        /* ABORT (PREFETCH) INTERRUPT */
  B	_abort_data        /* ABORT (DATA) INTERRUPT */
  B	_reserved          /* RESERVED */
  LDR r15, [r15, #-0x0F20]    /* IRQ INTERRUPT */
  B	_fiq  		         /* FIQ INTERRUPT */

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

              
.end

