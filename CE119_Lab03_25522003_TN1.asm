.data
msg:    .asciiz "Ket qua: "

.text
.globl main
main:
        li    $a0, 5            # x = 5
        jal   outer             # v0 = outer(5)
        move  $s0, $v0
        li    $v0, 4
        la    $a0, msg
        syscall
        move  $a0, $s0
        li    $v0, 1
        syscall
        li    $v0, 10
        syscall

# outer: outer(x) = inner(x) + 1
# Tham so : $a0 = x
# Tra ve  : $v0 = inner(x) + 1
# Thanh ghi: $ra
outer:
        addi  $sp, $sp, -4      # mo dau: cap khung 1 word
        sw    $ra, 0($sp)       #   cat dia chi tro ve
        jal   inner
        addi  $v0, $v0, 1
        lw    $ra, 0($sp)       # ket thuc: nap lai dung offset
        addi  $sp, $sp, 4       #   thu hoi khung
        jr    $ra

# inner: inner(x) = 2 * x
# Tham so : $a0 = x
# Tra ve  : $v0 = 2x
# Thanh ghi: thu tuc la, khong dung $s, nen khong can khung
inner:
        add   $v0, $a0, $a0
        jr    $ra
