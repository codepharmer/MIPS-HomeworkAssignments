.text
.globl main
main:

li $v0, 7
syscall
mov.d $f4, $f0

li $v0, 7
syscall
mov.d $f6, $f0

div.d $f0, $f4, $f6

movf.d $f0, $f0
mov.d $f12, $f0

li $v0, 3
syscall
li $v0, 10
syscall

.data
