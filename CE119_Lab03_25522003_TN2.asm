.data
str1:   .asciiz "kien truc may tinh"
str2:   .asciiz "mips"
str3:   .asciiz ""
str4:   .asciiz "a bc def"
str5:   .asciiz "thanh ghi s phai duoc bao toan"

bar:    .asciiz "|"
newline:.asciiz "\n"

.text
.globl main
main:
        la    $a0, str1
        jal   run_test
        la    $a0, str2
        jal   run_test
        la    $a0, str3
        jal   run_test
        la    $a0, str4
        jal   run_test
        la    $a0, str5
        jal   run_test

        li    $v0, 10
        syscall

# run_test: goi reverse_words va in ket qua giua hai ky tu |
# Tham so : $a0 = dia chi chuoi
# Tra ve  : khong
# Thanh ghi: $s0, $ra
run_test:
        addi  $sp, $sp, -8      # mo dau: cap khung 2 word
        sw    $ra, 4($sp)
        sw    $s0, 0($sp)

        move  $s0, $a0
        jal   reverse_words

        li    $v0, 4
        la    $a0, bar
        syscall
        move  $a0, $s0
        li    $v0, 4
        syscall
        li    $v0, 4
        la    $a0, bar
        syscall
        li    $v0, 4
        la    $a0, newline
        syscall

        lw    $s0, 0($sp)       # ket thuc: nap lai dung offset
        lw    $ra, 4($sp)
        addi  $sp, $sp, 8       # thu hoi khung
        jr    $ra

# strlen: dem so ky tu truoc byte 0
# Tham so : $a0 = dia chi chuoi .asciiz
# Tra ve  : $v0 = so ky tu
# Thanh ghi: $t0, $t1 (thu tuc la, khong dung ngan xep)
strlen:
        move  $t0, $a0
        li    $v0, 0
strlen_loop:
        lb    $t1, 0($t0)
        beq   $t1, $zero, strlen_done
        addi  $v0, $v0, 1
        addi  $t0, $t0, 1
        j     strlen_loop
strlen_done:
        jr    $ra

# rev_range: dao tai cho doan [$a0, $a1]
# Tham so : $a0 = dia chi dau, $a1 = dia chi cuoi
# Tra ve  : khong
# Thanh ghi: $t0, $t1, $t2 (thu tuc la, khong dung ngan xep)
rev_range:
rev_loop:
        sltu  $t2, $a0, $a1
        beq   $t2, $zero, rev_done
        lb    $t0, 0($a0)
        lb    $t1, 0($a1)
        sb    $t1, 0($a0)
        sb    $t0, 0($a1)
        addi  $a0, $a0, 1
        addi  $a1, $a1, -1
        j     rev_loop
rev_done:
        jr    $ra

# reverse_words: dao thu tu tu tai cho
# Tham so : $a0 = dia chi chuoi
# Tra ve  : khong
# Thanh ghi: $s0, $s1, $s2, $ra (cat vao khung 4 word)
reverse_words:
        addi  $sp, $sp, -16     # mo dau: cap khung 4 word
        sw    $ra, 12($sp)      #   cat dia chi tro ve
        sw    $s0, 8($sp)       #   cat dia chi chuoi
        sw    $s1, 4($sp)       #   cat dau tu hien tai
        sw    $s2, 0($sp)       #   cat con tro duyet

        move  $s0, $a0
        jal   strlen
        ble   $v0, 1, rw_done

        # dao toan bo chuoi
        move  $a0, $s0
        add   $a1, $s0, $v0
        addi  $a1, $a1, -1
        jal   rev_range

        # dao lai tung tu
        move  $s1, $s0
        move  $s2, $s0
rw_loop:
        lb    $t0, 0($s2)
        beq   $t0, $zero, rw_last
        li    $t1, 32           # ky tu ' '
        beq   $t0, $t1, rw_word
        addi  $s2, $s2, 1
        j     rw_loop

rw_word:
        move  $a0, $s1
        addi  $a1, $s2, -1
        jal   rev_range
        addi  $s2, $s2, 1
        move  $s1, $s2
        j     rw_loop

rw_last:
        move  $a0, $s1
        addi  $a1, $s2, -1
        jal   rev_range

rw_done:
        lw    $s2, 0($sp)       # ket thuc: nap lai dung offset
        lw    $s1, 4($sp)
        lw    $s0, 8($sp)
        lw    $ra, 12($sp)
        addi  $sp, $sp, 16      # thu hoi khung
        jr    $ra
