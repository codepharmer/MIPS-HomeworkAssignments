#work out cont  program thing
.text
.globl main
main:


#one that does input one that does output.

#and one that does the comparisons



	jal allwork #this function will do all the work

exit: #always good to have an exit label
	li $v0, 10 
	syscall

#jump back
allwork: #inside of here is all the cool stuff
	addi $sp, $sp, -4 #shift the stack pinter 4 bits (a word, enough space to hold the address in $ra)
	sw $ra, ($sp)  #store the address in in the stack

	jal input #this function does all the input
	jal comparison #this function compares which number is the largest
	jal sqr_nums
	jal check_if_right

	addi $sp, $sp, 4
	lw $ra, ($sp)
	jr $ra
############################################################################################################################
#...one that does input...
input:
	addi $sp, $sp, -4
	sw $ra, ($sp) 
	la $a0 ,prompt
	li $v0, 4
	syscall

	li $v0, 5 #input the first number
	syscall

	move $s1, $v0 #move it to $s1

	li $v0, 5 #input the second number
	syscall

	move $s2, $v0 #move it to $s2
	li $v0, 5
	syscall
	move $s3, $v0 #move the third number input to $s3

	#move $t2, $s1 #we'll be using this in the exponential function

	lw $ra, ($sp) #restore address for $ra
	addi $sp, $sp, 4 #shift the stack pointer back to its position coming into this function
	jr $ra #jump out of function
##########################################################################################################################



##############################################################################################################################
comparison:
	addi $sp, $sp, -4 
	sw $ra, ($sp) #just in case we need to call another funtion while inside of this one 
	
	#while determining the largest side we'll see if two sides are equal and larger than the third, if this is the case we know
	#the sides given do not make a right triangle
	beq $s1, $s2 a_equals_b # $s1 or 'a' holds and $s2 holds 'b'. If they are qual we will send them to label aequalsb
	# Note: If the program didnn't branch to the above label we know that the statement !( a == b == c ) is true
	beq $s1, $s3 a_equals_c # $s3 holds 'c'. 
	#If $s1 equals $s3  j a_equals_c
	beq $s2, $s3 b_equals_c # branches to b_equals_c if b == c
	#if the program is still passing through at this point we know that that a, b, and c are all unique
	bgt $s1, $s2 agtb # branch if a is greater than b
	bgt $s2, $s1 bgta # branch if b is greater than a
	bgt $s3, $s1 cBig # branch if c is greater than a then using logic we can deduce that c is the largest
agtb: 
	bgt $s1, $s3 aBig # if (a > c) a is largest 
	j cBig #otherwise c is largest
bgta:
	bgt $s2, $s3 bBig # if (b > c) b is largest 
	j cBig #else c is largest
a_equals_b:
	beq $s1, $s3 equal #if a == c then a == b == c and number of + - and '0' are equivalent
	bgt $s1, $s3 a_and_bBig # if a > c then a > c and b > c
	j cBig # c is largest but a and b are equivalent
a_and_bBig:
	#not a right triangle
	li $s1, 0
	li $s2, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4 #shift stack pointer back to where it was before the function
	jr $ra
	
	#la $a0, not_right # a == b and larger than c There were an equal number of postive and negative entries at "
	#li $v0, 4
	#syscall
	#j exit #sides do not make a right triangle so we are done
cBig:
	#so $s3 already contains largest number

	#j ump to cont the program
	j after_comparison
equal:
	#not a right triangle
	lw $ra, ($sp)
	addi $sp, $sp, 4 #shift stack pointer back to where it was before the function
	jr $ra
	#the following code does the same thing
	la $a0, not_right # a == b == c
	li $v0, 4
	syscall
	
	j exit
a_equals_c:
	bgt $s1, $s2 a_and_cBig #if a > b, a == c and both are larger than b
	j bBig

a_and_cBig:
	#not a right triangle

	j after_comparison
bBig:
	move $t1, $s2 #move b to temp register
	move $s2, $s3 #move c to b 
	move $s3, $t1 #move complter switch so largest number is in $s3
	
	j after_comparison
b_equals_c:
	bgt $s2, $s1 b_and_cBig #if b==c and are larger than then we branch to b_and_cBig
	j aBig
b_and_cBig:
	#not a right triangle
	lw $ra, ($sp)
	addi $sp, $sp, 4 #shift stack pointer back to where it was before the function
	jr $ra
	#the following code gets us there faster
	la $a0, not_right # b == c > a
	li $v0, 4
	syscall
	
	j exit
	aBig:
	move $t1, $s1 #move a to temp register
	move $s1, $s3 #move c to a 
	move $s3, $t1 #complete the switch so largest number is in $s3
	j after_comparison
after_comparison: #jumps here after greatest side has been determined

	lw $ra, ($sp) #restore $ra address
	addi $sp, $sp, 4 #shift stack pointer back to where it was before the function
	jr $ra #leave function
#################################################################################################################

#################################################################################################################
sqr_nums:
	addi $sp, $sp, -4 #shiift the stack pointer
	sw $ra, ($sp) #so that we can call another function from this one

	li $t1, 1 #we use $t1 in sqr
	move $t1, $s1 #move n1 to $t2, the register we sqr in "sqr"
	move $t2, $s1
	jal sqr
	move $s1, $t1 #move the sqr of the original n into $s1

	move $t1, $s2 #move n2 to $t2, the register we sqr in "sqr"
	move $t2, $s2
	jal sqr
	move $s2, $t1 #move the sqr of the original n into $s2

	move $t1, $s3 #move n2 to $t3, the register we sqr in "sqr"
	move $t2, $s3
	jal sqr
	move $s3, $t1 #move the sqr of the original n into $s3

	lw $ra, ($sp) #so that we can call another function from this one
	addi $sp, $sp, 4 #shiift the stack pointer
	jr $ra
#################################################################################################################

#############################################################################################################################################
#...you must have a function that does exponentiation

sqr: #use this function to sqr numbers (used this name for convenience)
	li $s4, 2 #we use $s4 as the exponent 
#only loads with two on first iteration
sqr_main:
	addi $sp, $sp, -4
	sw $ra, ($sp)

	beq $s4, 1 cont_program
	beq $s4, 0 exp0

	mult $t1, $t2 #t2 contains number to be squared
	mflo $t1
	sub $s4, $s4, 1
	j sqr_main

cont_program: #after done with sring number

	lw $ra, ($sp) #restore address of $ra
	addi $sp, $sp, 8 #we need to shift an extra four that that we've shifted before coming into the function
	jr $ra #leave function


exp0:
	li $t1, 1 #anything to the 0th == 1
	li $s4, 1 #will break out of loop upon return
j sqr
######################################################################################################################################################

######################################################################################################################
check_if_right:
	addi $sp, $sp, -4 #getting into the habbit of shifting pointer at the beginning of a function
	sw $ra, ($sp) #and then storing address of $ra
	add $t1, $s1, $s2 # t1 = a^2 + b^2
	beq $t1, $s3 is_right #the triangle is right
	j not_right #the triangle isn't wrong, it's just not right
	lw $ra ($sp) #restore $ra
	addi $sp, $sp, 4 #shift pointer back
	jr $ra #jump out of function


is_right: #the output for when the triangle is a right triangle
	la $a0, y_right #cout this is a right angle
	li $v0, 4
	syscall
	lw $ra ($sp) #restore $ra
	#addi $sp, $sp, 12 #shift pointer back
	jr $ra #jump out of function
	
#jump out of function


not_right:
	la $a0, n_right #cout this isn't a right angle
	li $v0, 4
	syscall
	lw $ra ($sp) #restore $ra
	#addi $sp, $sp, 12 #shift pointer back
	jr $ra #jump out of function
	

#####################################################################################################################################






.data
prompt: .asciiz "\nPlease enter three numbers.\n"
n_right: .asciiz "\nThe sides given do not make up a right triangle.\n"
y_right: .asciiz "\nCongratulations!!!!! \nThe length of these sides together create a right triangle! :D \n"









