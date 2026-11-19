.data
n:      .word 20                # do voi n = 20 theo yeu cau de bai
msg1:   .asciiz "F("
msg2:   .asciiz ") = "
newline:.asciiz "\n"

.text
.globl main
main:
        lw    $a0, n
        jal   fib_opt
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

# fib_opt: tinh F(n) toi uu truong hop co so truoc khi cap khung
# Tham so : $a0 = n
# Tra ve  : $v0 = F(n)
# Thanh ghi: $s0, $s1, $ra (chi cat vao khung khi n >= 2)
fib_opt:
        # kiem tra truong hop co so truoc khi cap khung
        slti  $t0, $a0, 2
        beq   $t0, $zero, fo_rec
        move  $v0, $a0          # F(0) = 0, F(1) = 1
        jr    $ra               # tra ve ngay, khong cap khung

fo_rec:
        addi  $sp, $sp, -12     # mo dau: cap khung 3 word khi n >= 2
        sw    $ra, 8($sp)
        sw    $s0, 4($sp)
        sw    $s1, 0($sp)

        move  $s0, $a0

        addi  $a0, $s0, -1
        jal   fib_opt
        move  $s1, $v0

        addi  $a0, $s0, -2
        jal   fib_opt
        add   $v0, $s1, $v0

        lw    $s1, 0($sp)       # ket thuc: nap lai dung offset
        lw    $s0, 4($sp)
        lw    $ra, 8($sp)
        addi  $sp, $sp, 12      # thu hoi khung
        jr    $ra
