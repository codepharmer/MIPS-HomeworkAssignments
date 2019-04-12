 	.text
	.globl main
main: 
    la       	 $a0,prompt   	#prompt two numbers input
    li       	 $v0,4
    syscall
    li       	 $v0,5		
    syscall
    move      	$t1,$v0		#save first num in t1
    li       	 $v0,5		
    syscall
    
    move      	$t7,$v0		#second num in t7
    
    jal       gcd		#call gcd
    li $v0, 10
    syscall
 
gcd:
	addi $sp,$sp,-12	#allocate room in stack for return address and parameter
	sw $ra,8($sp)		#save return address
	sw $t7, 4($sp)
	sw $t1,0($sp)		#and parameter

			
	beqz	$t7, returnGCD     # if (a%b == 0) then return 'a' as GCD
	
	
	
	div	$t1,$t7
	move $t1, $t7
	mfhi	$t7	#remainder is in hi
	
	jal	gcd		#next number

return:
		
	addi $sp,$sp,12		#advance stack pointer, but eave room for three nums
	lw $ra,8($sp)		#restore return address
	lw $a0,0($sp)		#and value of n just used to print			#and go to next line
	jr $ra			#return to where came from 
returnGCD:	
	
	la $a0, gcdIs
	li $v0, 4
	syscall
	
	move     	$a0,$t1		#output number just got
	li		$v0,1
    	syscall
    	
    	la $a0, y
	li $v0, 4
	syscall
    	
    	j	return		#and exit
	.data
prompt: .asciiz "Enter two numbers to find a GCD: "
space: .asciiz "\n"
gcdIs: .asciiz "\nThe greatest common divisor for your two numbers is: "
y: .asciiz "\nThanks for playing!\n Have a great day:)\n"
  
