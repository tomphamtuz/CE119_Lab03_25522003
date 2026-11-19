.data
n:      .word 14                # n(d) = 11 + 3 = 14
msg1:   .asciiz "F("
msg2:   .asciiz ") = "
newline:.asciiz "\n"

.text
.globl main
main:
        lw    $a0, n
        jal   fib_rec           # doi sang jal fib_iter khi do fib_iter
        move  $s0, $v0

        li    $v0, 4
        la    $a0, msg1
        syscall
        li    $v0, 1
        lw    $a0, n
        syscall
        li    $v0, 4
        la    $a0, msg2
        syscall
        li    $v0, 1
        move  $a0, $s0
        syscall
        li    $v0, 4
        la    $a0, newline
        syscall

        li    $v0, 10
        syscall

# fib_rec: tinh F(n) bang de quy
# Tham so : $a0 = n
# Tra ve  : $v0 = F(n)
# Thanh ghi: $s0, $s1, $ra (cat vao khung 3 word)
fib_rec:
        addi  $sp, $sp, -12     # mo dau: cap khung 3 word
        sw    $ra, 8($sp)       #   cat dia chi tro ve
        sw    $s0, 4($sp)       #   cat $s0
        sw    $s1, 0($sp)       #   cat $s1

        move  $s0, $a0          # giu n

        # truong hop co so: n < 2
        slti  $t0, $s0, 2
        beq   $t0, $zero, fr_rec
        move  $v0, $s0          # F(0) = 0, F(1) = 1
        j     fr_done

fr_rec:
        addi  $a0, $s0, -1      # a0 = n - 1
        jal   fib_rec           # v0 = fib_rec(n - 1)
        move  $s1, $v0          # giu ket qua loi goi 1

        addi  $a0, $s0, -2      # a0 = n - 2
        jal   fib_rec           # v0 = fib_rec(n - 2)
        add   $v0, $s1, $v0     # v0 = fib_rec(n - 1) + fib_rec(n - 2)

fr_done:
        lw    $s1, 0($sp)       # ket thuc: nap lai dung offset
        lw    $s0, 4($sp)
        lw    $ra, 8($sp)
        addi  $sp, $sp, 12      # thu hoi khung
        jr    $ra

# fib_iter: tinh F(n) bang vong lap
# Tham so : $a0 = n    Tra ve : $v0 = F(n)
# Thanh ghi: $t0-$t3 (thu tuc la)
fib_iter:
        move  $v0, $zero        # a = F(0)
        li    $t0, 1            # b = F(1)
        move  $t1, $zero        # i = 0
fi_loop:
        slt   $t2, $t1, $a0
        beq   $t2, $zero, fi_done
        addu  $t3, $v0, $t0     # a + b
        move  $v0, $t0
        move  $t0, $t3
        addiu $t1, $t1, 1
        j     fi_loop
fi_done:
        jr    $ra
