.section .init
.globl _start

GPIO_BASE = 0x20200000          /* GPIO Controller address */

_start:

  ldr r0,=GPIO_BASE

  /*
  Enable output to pin 16.

  GPIO controller consists of 24 bytes for controlling the 54 GPIO pins,
  these blocks are referred to as 'function select'.

  | Bytes |  Pins | Field name | Description       |
  |-------+-------+------------+-------------------|
  |   0-3 |   0-9 | GPFSEL0    | Function select 0 |
  |   4-7 | 10-19 | GPFSEL1    | Function select 1 | <-
  |  8-11 | 20-29 | GPFSEL2    | Function select 2 |
  | 12-15 | 30-39 | GPFSEL3    | Function select 3 |
  | 16-19 | 40-49 | GPFSEL4    | Function select 4 |
  | 20-23 | 50-53 | GPFSEL5    | Function select 5 |
  |-------+-------+------------+-------------------|

  Within a 4 byte block there are 3 bits per GPIO pin:

  | Bit layout |   000 |    000 |   000 |   000 |   000 |   000 |   000 |  000 | 000 | 000 | 000 |
  | Bit range  | 32-30 | 29--27 | 26-24 | 23-21 | 20-18 | 17-15 | 14-12 | 11-9 | 8-6 | 5-3 | 2-0 |
  | Pin        |     - |      9 |     8 |     7 |     6 |     5 |     4 |    3 |   2 |   1 |   0 |

  To access pin 16 we need to access the 18th bit in the function select 1 block,
  i.e address GPIO_BASE + GPFSEL1 (4 * 8) + GPIO pin (3 * 6).
  */
  mov r1, #1
  lsl r1, #18                   /* left shift r1 to pin 6 (1 000 000 000 000 000 000) */
  str r1, [r0, #4]              /* store the value of r1 in GPIO_BASE offset by 4 (1 byte/offset) */

  /*
  Turn on pin 16 (by turning it off accroding to the documentation :/)

  | Bytes | Field name | Description             |
  |-------+------------+-------------------------|
  | 40-43 | GPCLR0     | GPIO Pin Output Clear 0 | <-
  | 44-47 | GPCLR1     | GPIO Pin Output Clear 1 |
  |-------+------------+-------------------------|
  */
  mov r1, #1
  lsl r1, #16                   /* message to turn off pin 16 (10000000000000000) */
  str r1, [r0, #40]             /* Send to 0x28 (40) GPCLR0 (GPIO Pin Output Clear 0) */

loop$:
  b loop$
