          .section .startup

          B __start @ RESET INTERRUPT
          B _undef  @ UNDEFINED INSTRUCTION INTERRUPT
          B _swi    @ SOFTWARE INTERRUPT
          B _abort_pref @ ABORT (PREFETCH) INTERRUPT
          B _abort_data @ ABORT (DATA) INTERRUPT
          B _reserved @ RESERVED
          B _irq      @ IRQ INTERRUPT
          B _fiq      @ FIQ INTERRUPT
  
          .end

