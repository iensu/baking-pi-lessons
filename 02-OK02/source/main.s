.section .init
.globl _start

  /*
  GPIO Controller address
  RPI3: 0x3f200000
  RPIB: 0x20200000
  */

GPIO_BASE = 0x3f200000

_start:

  ldr r0,=GPIO_BASE

  /*
  Enable writing to GPIO pin 17 in order to turn on external GPIO pin
  */
  mov r1, #1
  lsl r1, #21
  str r1, [r0, #4]

  mov r1, #1
  lsl r1, #17                   /* r1 = pin 1 (100000000000000000) */

loop$:
  str r1, [r0, #40]             /* turn on pin 17 */

  mov r2, #4000                 /* delay (0x3f0000), only 0-9 allowed after # */
wait1$:
  sub r2, #1
  cmp r2, #0
  bne wait1$

  str r1, [r0, #28]             /* turn off pin 17 */

  mov r2, #4000                 /* delay (0x3f0000)*/
wait2$:
  sub r2, #1
  cmp r2, #0
  bne wait2$

  b loop$
