.section .init
.globl _start

GPIO_BASE = 0x20200000          /* GPIO Controller address */

_start:

  ldr r0,=GPIO_BASE

  /*
  Enable writing to GPIO pin 16
  */
  mov r1, #1
  lsl r1, #18
  str r1, [r0, #4]

  mov r1, #1
  lsl r1, #16                   /* r1 = pin 16 (10000000000000000) */

loop$:
  str r1, [r0, #40]             /* turn on pin 16 */

  mov r2, #4128768              /* delay (0x3f0000), only 0-9 allowed after # */
wait1$:
  sub r2, #1
  cmp r2, #0
  bne wait1$

  str r1, [r0, #28]             /* turn off pin 16 */

  mov r2, #4128768               /* delay (0x3f0000)*/
wait2$:
  sub r2, #1
  cmp r2, #0
  bne wait2$

  b loop$
