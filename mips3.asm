.text
.globl main
main:
#only loads with two on first iteration

ldc1 $f6, exp0 #will use if exp is 0

la $a0, prompt
li $v0, 4
syscall

li $v0, 7
syscall
mov.d $f2, $f0

mov.d $f4, $f2

li $v0, 5
syscall
move $s4, $v0 #exp is now in $s4
move $s1, $s4 #save another copy
bgez $s4 not_minus
li $t1, -1
mult $s4, $t1
mflo $s4
not_minus:




jal exp

exit:
li $v0, 10
syscall
exp:
	addi $sp, $sp, -4
	sw $ra, ($sp)

	beq $s4, 1 cont_program
	bnez $s4 not_0
	
	mov.d $f4, $f6
	j cont_program
	not_0:
	mul.d $f4, $f4, $f2 #t2 contains number to be squared

	sub $s4, $s4, 1
	j exp

cont_program: #after done with sring number
	bgez $s1  pos_exp
	div.d $f4, $f6, $f4
	pos_exp:
	mov.d $f12, $f4
	li $v0, 3
	syscall

	lw $ra, ($sp) #restore address of $ra
	addi $sp, $sp, 4 #we need to shift an extra four that that we've shifted before coming into the function
	jr $ra #leave function




.data
prompt: .asciiz "\nPlease input a number and then an exponent.\n"
exp0: .double 1