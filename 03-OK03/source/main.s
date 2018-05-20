.section .init
.globl _start

  b main

.section .text

Wait:
  delay .req r0
  mov delay, #0x3f0000

  wait$:
    sub delay, #1
    cmp delay, #0
    bne wait$

  .unreq delay
  mov pc, lr


main:
  mov sp, #0x8000

  pinNum  .req r0
  pinFunc .req r1
  mov     pinNum,  #16
  mov     pinFunc, #1

  bl SetGpioFunction

  .unreq pinNum
  .unreq pinFunc

  loop$:

    pinNum .req r0
    pinVal .req r1
    mov    pinNum, #16
    mov    pinVal, #0

    bl SetGpio

    .unreq pinNum
    .unreq pinVal

    bl Wait

    pinNum .req r0
    pinVal .req r1
    mov    pinNum, #16
    mov    pinVal, #1

    bl SetGpio

    .unreq pinNum
    .unreq pinVal

    bl Wait

    b loop$
