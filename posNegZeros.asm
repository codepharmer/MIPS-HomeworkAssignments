.text
.globl main

main:
	la $a0, prompt #asks user to enter a num which will be used terminate the program
	li $v0, 4 #cout<<prompt
	syscall
	
	#stores sentintal
	li $v0, 5 #cin>> sentinal
	syscall
	move $s1, $v0 #$s1 will hold sentinal
	
	move $s2, $zero #ensure $s2 is empty thi will store postive sum
	move $s3, $zero #ensure $s3 is empty this will hold total num of postitives
	
	move $s4, $zero #ensure $s4 is empty this will store the sum of negative nums
	move $s5, $zero #ensure $s5 is empty this will hold total num of negatives
	
	move $s6, $zero #ensure $s6 is empty this will hold total num of zeros
	
	#now we have have our registers set up and we'll start computing :)
	la $a0, enterNum #asks user to input a number
	li $v0, 4	
	syscall	
loop:								
	
	li $v0, 5 #cin>> num
	syscall
	
	beq $v0, $s1 results #if this number is the sentinal we will immediately output the results
	
	move $t1, $v0 #$t1 will hold the num for now

	#checks if num == sentinal
	

bgt $t1, $zero, pos#checks if num is positive
#sends to postive loop

blt $t1, $zero, nega#checks if num is negagive
#sends to negative loop

beqz $t1, zero#otherwise num is 0

#positive num += postive numSum
#postivenums num += 1

#negative num += negative numSum
#negativenums num += 1
pos:
	add $s2, $s2, $t1 #adds the current num to sum of positive num
	add $s3, $s3, 1 #incr total positive numbers by 1
	j loop
nega:
	add $s4, $s4, $t1
	add $s5, $s5, 1
	j loop
zero:
	add $s6, $s6, 1
	
	j loop
results:

	#for positive nums
	
	la $a0, posSum #cout<<"sum of positive nums is"
	li $v0, 4
	syscall
	
	move $a0, $s2 #cout<<positive_sum
	li $v0, 1
	syscall
	
	la $a0, totalPos #cout<<"total num of postive numbers enterd is "
	li $v0, 4
	syscall
	
	move $a0, $s3 #cout<<number_of_postive_numbers
	li $v0, 1
	syscall
	
	#for negative nums
	
	la $a0, negSum #cout<<"sum of negative nums is"
	li $v0, 4
	syscall
	
	move $a0, $s4 #cout<<negative_sum
	li $v0, 1
	syscall
	
	la $a0, totalNeg #cout<<"total num of negative numbers enterd is "
	li $v0, 4
	syscall
	
	move $a0, $s5 #cout<<number_of_negative_numbers
	li $v0, 1
	syscall
	
	#for zeros
	
	la $a0, totalZeros #cout<<"sum of negative nums is"
	li $v0, 4
	syscall
	
	move $a0, $s6 #cout<<number_of_negative_numbers
	li $v0, 1
	syscall
	
	la $a0, period #cout<<"sum of negative nums is"
	li $v0, 4
	syscall
exit:	
	li $v0, 10
	syscall
.data

prompt: .asciiz "Please enter a sentinal (used to terminate the program later on).\nNo zeros please:)\n"
enterNum: .asciiz "Please enter a number (sentinal if you'd like to terminate).\n"
posSum: .asciiz "The sum of all positive numbers was "
totalPos: .asciiz ".\nThe total number of positive numbers entered was "
negSum: .asciiz ".\nThe sum of all negative numbers was "
totalNeg:  .asciiz ".\nThe total number of negative numbers entered was "
totalZeros: .asciiz ".\nThe total number of zeros entered was "
period: .asciiz ".\nWe thank you for your participation and appreciate your business.\nMay you have a most wonderful day:)\n"
