.equ UART_BASE, 0x10000000
.equ UART_LINE_STATUS, 0x10000005

.section .init
.global _start
_start:
    li sp, 0x88000000  # Initialise stack

    call getc
    mv s1, a0         # Keep track of the first digit
    mv s2, zero
    mv t0, a0         # Current digit

loop:
    call getc
    mv t1, a0         # Next digit
    li t2, '\n'
    beq t1, t2, end   # Reached end of line (only 1 line)
    beqz t1, end      # Reached end of input

    bne t0, t1, skip

    # t1 == t0
    addi t0, t0, -'0' # ASCII to int
    add s2, s2, t0    # Sum

skip:
    mv t0, t1         # current digit is next digit
    j loop

end:
    bne t0, s1, end_skip

    # s1 == t0
    addi t0, t0, -'0' # ASCII to int
    add s2, s2, t0    # Sum

end_skip:
    mv a0, s2
    call putu

end_loop:
    j end_loop

# Blocks and returns char - a0
getc:
getc_wait:
    li a0, UART_LINE_STATUS
    lb a0, 0(a0)       # UART read line status
    andi a0, a0, 0x1   # RX ready bit
    beqz a0, getc_wait # Loop while not ready

    li a0, UART_BASE
    lb a0, 0(a0)       # UART read data
    ret

# Prints - a0
putc:
    li t0, UART_BASE
    sb a0, 0(t0)       # UART write data
    ret

# Print unsigned integer - a0
putu:
    addi sp, sp, -16 # Allocate 16 bytes for the string
    sw ra, 12(sp)

    mv a1, zero      # count number of chars (no overflow check)
    li a2, 10        # load divisor

putu_loop:
    rem a3, a0, a2   # a3 = a0 % 10
    addi a3, a3, '0' # int to ASCII

    add a4, sp, a1
    sb a3, 0(a4)
    addi a1, a1, 1

    div a0, a0, a2   # a0 = a0 / 10
    bnez a0, putu_loop
    
putu_print_loop:
    addi a1, a1, -1
    add a4, sp, a1
    lb a0, 0(a4)
    call putc

    bnez a1, putu_print_loop

    lw ra, 12(sp)
    addi sp, sp, 16
    ret
