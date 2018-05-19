.section .init
.globl _start

GPIO_BASE = 0x20200000

_start:

  ldr r0,=GPIO_BASE

  mov r1, #1
  lsl r1, #18
  str r1, [r0, #4]

  mov r1, #1
  lsl r1, #16
  str r1, [r0, #40]

loop$:
  b loop$
