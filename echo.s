.equ UART_BASE, 0x10000000
.equ UART_LINE_STATUS, 0x10000005

.section .init
.global _start
_start:
    li s1, UART_BASE
    li s2, UART_LINE_STATUS

wait:
    lb s3, 0(s2)      # UART read line status
    andi s3, s3, 0x1  # RX ready bit
    beqz s3, wait     # Loop when not ready

    lb s3, 0(s1)      # UART read data
    sb s3, 0(s1)      # UART write data
    bnez s3, wait

    la s2, message    # s2 := <message>
    addi s3, s2, 14   # s3 := s2 + 14
done:
    lb s4, 0(s2)      # s4 := (s2)
    sb s4, 0(s1)      # (s1) := s4
    addi s2, s2, 1    # s2 := s2 + 1
    blt s2, s3, done  # if s2 < s3

.section .data
message:
  .string "\nDone!\n"
