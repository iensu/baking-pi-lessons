GPIO_BASE_RPB = 0x2020000
GPIO_BASE_RP3 = 0x3f20000

/*
  | Register | Name            | Description                                                 |
  |----------+-----------------+-------------------------------------------------------------|
  | r0-r7    | Low registers   | General purpose registers                                   |
  | r8-r12   | High registers  | General purpose registers                                   |
  | sp (r13) | Stack pointer   | Points to the current top of the stack                      |
  | lr (r14) | Link register   | Address to branch back to when a function is finished       |
  | pc (r15) | Program counter | Contains the address of the next instruction to be executed |
  |----------+-----------------+-------------------------------------------------------------|

  Source: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0553a/CHDBIBGJ.html
*/

.globl GetGpioAddress
GetGpioAddress:
  ldr r0, =GPIO_BASE_RPB
  mov pc, lr                    @ go back to instruction following the branch instruction


.globl SetGpioFunction
SetGpioFunction:
  pinNum  .req r0
  pinFunc .req r1

  cmp   pinNum, #53
  cmpls pinFunc, #7
  movhi pc, lr

  push   {lr}
  mov    r2, pinNum
  .unreq pinNum
  pinNum .req r2

  bl    GetGpioAddress

  gpioAddr .req r0

  findFunctionLoop$:
    cmp   pinNum, #9
    subhi pinNum, #10
    addhi gpioAddr, #4
    bhi   findFunctionLoop$

  add pinNum, pinNum, lsl #1
  lsl pinFunc, pinNum
  str pinFunc, [gpioAddr]

  .unreq gpioAddr
  .unreq pinFunc
  .unreq pinNum

  pop {pc}


.globl SetGpio
SetGpio:
  pinNum .req r0
  pinVal .req r1

  cmp pinNum, #53
  movhi pc, lr

  push {lr}
  mov r2, pinNum
  .unreq pinNum
  pinNum .req r2

  bl GetGpioAddress

  gpioAddr .req r0
  pinBank .req r3

  lsr pinBank, pinNum, #5
  lsl pinBank, #2
  add gpioAddr, pinBank
  .unreq pinBank

  and pinNum, #31
  setBit .req r3
  mov setBit, #1
  lsl setBit, pinNum
  .unreq pinNum

  teq pinVal, #0
  .unreq pinVal

  streq setBit, [gpioAddr, #40]
  streq setBit, [gpioAddr, #28]
  .unreq setBit
  .unreq gpioAddr

  pop {pc}
