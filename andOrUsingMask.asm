.text
.globl main
main:

li $t7, 0 #clear $t7 
#as we run through the differnt funtions $t7 will incr which will tell us whether to cout "AND" / "OR"/ "XOR" when outputting the numbers

la $a0, prompt #prompt number input
li $v0, 4
syscall

li $v0, 5 #input number
syscall
move $s1, $v0 #copy number to $s1

li $v0, 5 #input number
syscall

move $s2, $v0 #copy the second number to $s2

#from her until the first funtion, "print_binary", we will just be print the numbers with either "AND", "OR", or "XOR" between them.
#aside for that, the only other code in this part is the JALs which jump to the different functions

################################################################
#we'll start here for outputting both numbers for each function
print_nums:

move $t1, $s1 #move the first number into $t1, that's the register we're using in the print_binary function

la $a0, nl #output a newline
li $v0, 4 
syscall

la $a0, space4 #this will line up the output with the next number
li $v0, 4
syscall
	
jal print_binary #this is the function we use to output the number in binary

la $a0, nl #output a newline
li $v0, 4 
syscall

beqz $t7, say_and #the first time through this loop $t7 will be 0 and we will want to use the "myAnd" function, which is why we will output "AND"
beq $t7, 1, say_or #the second time through this loop $t7 will be 1 and we will want to use the "myOr" function, which is why we will output "OR"
beq $t7, 3, say_xor #the second time through this loop $t7 will be 3 and we will want to use the "myXor" function, which is why we will output "XOR"
say_and:
la $a0, with #to output "AND"
li $v0, 4
syscall
j cont_printnums

say_or:
la $a0, cout_or #to output "OR"
li $v0, 4
syscall

j cont_printnums

say_xor:
la $a0, cout_xor #to output "XOR"
li $v0, 4
syscall

j cont_printnums

cont_printnums:
move $t1, $s2 #as witht he first number, we will move to $t1 toprint the second number in binary

jal print_binary #this is the function we use to output the number in binary

la $a0, line
li $v0, 4
syscall

la $a0, space4 #this will line up the output for the next number
li $v0, 4
syscall
#done outputting number in binary

bnez $t7, jump_or #just to skip myAnd

move $a0, $s1 #numbers being passed to funtion will be stored in $a0 and $a1
move $a1, $s2 #we move n1 to $a0 and n2 to $a1
jal myAnd #jumps to myAnd function

la $a0, nl #output a newline
li $v0, 4 
syscall

jump_or:
bgt $t7, 2 jump_xor #if $t7 is greater than 2 we know that we've already passed through "myOr"

addi $t7, $t7, 1 #after passing the second time we'll skip into myor
beq $t7, 1 print_nums 


move $a0, $s1 #numbers being passed to funtion will be stored in $a0 and $a1
move $a1, $s2 #we move n1 to $a0 and n2 to $a1

jal myOr #jumps to myOr function
la $a0, nl #output a newline
li $v0, 4 
syscall

jump_xor:
addi $t7, $t7, 1 #after passing the second time we'll skip into myor
beq $t7, 3 print_nums 

move $a0, $s1 #numbers being passed to funtion will be stored in $a0 and $a1
move $a1, $s2 #we move n1 to $a0 and n2 to $a1

jal myXor #jumps to myXor function


la $a0, negate #cout \nNot 
li $v0, 4
syscall

la $a0, ($s1) # first number
li $v0, 1
syscall  

la $a0, space # cout " "
li $v0, 4 
syscall

move $a0, $s1
la $s5, 0 #we'll check $s5 in myNot to know if we're checking the first number (in $a0) or the secnd nuumber (in a $a1)
jal myNot

la $a0, negate #cout \nNot 
li $v0, 4
syscall

la $a0, ($s2) # first number
li $v0, 1
syscall  

la $a0, space # cout " "
li $v0, 4 
syscall

move $a1, $s2
la $s5, 1 #we'll check $s5 in myNot to know if we're checking the first number (in $a0) or the secnd nuumber (in a $a1)
jal myNot

la $a0, nl #output a newline
li $v0, 4 
syscall

la $a0, space4 #this will line up the output for the next number
li $v0, 4
syscall

j exit


####################################################################################################################################
#print_binary funtion starts here
print_binary:



li $t0, 0x80000000 #this ois where we load the mask into $t0, the mask basically looks like this right now: 1000 0000 0000 0000
		#as we continue we will keep shifting right the mask one bit at a time
		#so after 1 right shift it will lok like this: 0100 0000 0000 0000
		#after 2 shifts it'll be 0010 0000 0000 0000
		#this will continue until we've compared all 32 bit with the bits in our number

j first_iter #this way we check the first bit on the first iteration 
	#(otherwise the mask would be shifted before we get a chance to check the first bit)
loop:	
	srl $t0, $t0, 1 #shift mask over one bit to compare next bit in number
	beq $t0, 0, continue_program #if the mask has been shifted all the way over program will continue
first_iter:
	and $t9, $t1, $t0 #this will ensure a !0 in $t9 if the bit in this position is set with a 1

	
and $t9, $t1, $t0 #this will store a one in $t9 if the bit in this position is set with a 1

bgtz $t9,  one #if $t9 doesn't contain a 0 we know to output a one

li $t9, 0 #...otherwise we load with $t9 with a zero 
 j print #and jumpt to pront (skipping the "one" label)
 
one:
li $t9, 1 #loads $t9 with a 1

print:

la $a0, ($t9)
li $v0, 1
syscall

addi $t4, $t4, 1 #using this to place a space every four bits
beq $t4, 4, gap

cont_output: #jumps here from the "gap" label 

j loop #this wil jump back to the beginning of the loop and repeate until all bits are printed

exit:
li $v0, 10
syscall

gap:
	la $a0, space
	li $v0, 4
	syscall
	
	li $t4, 0 #reset counter 
	j cont_output

continue_program:
jr $ra
#print_binary funtion ends here
####################################################################################################################################



#####################################################################################################################################
#myAnd function begins here
myAnd:
#this fucntion is very similar to print_binary function, except that we're comparing two bits with mask on each iteration
#we will only output a 1 if they're both 1
li $t9, 0 #make sure $t9 is clear

li $t0, 0x80000000 #creating mask to use in myAnd

bltz $s1, skip_one_and #if the number is <0 then the sign bit will be 1. 
			#the output will show a 0 in place of the sign bit, therefore we'll skip the comparison for the first test and just outpt a 0
bltz $s2, skip_one_and #same as above
j first_iter_and #this way we check the first bit on the first iteration 
	#(otherwise the mask would be shifted before we get a chance to check the first bit)
	
loop_and:	
	srl $t0, $t0, 1 #shift mask over one bit to compare next bit in number
	beq $t0, 0, continue_program_and #if the mask has been shifted all the way over program will continue
first_iter_and:
	and $t9, $a0, $t0 #this will ensure a !0 in $t9 if the bit in this position is set with a 1
	and $t8, $a1, $t0 #this will ensure a !0 in $t8 if the bit in this position is set with a 1
	beqz $t8, skip_one_and #if $t8 contains a zero then we know the output for anding these two bits will be zero
	beq $t9, $t8 one_and
skip_one_and:
li $v0, 0 #...otherwise we load with $t9 with a zero 
j print_and #and jumpt to pront (skipping the "andone" label)
 
one_and:
li $v0, 1 #loads $t9 with a 1

print_and:
move $t2, $a0 #number must be in $a0 in order to print sw we will to temp register

la $a0, ($v0)
li $v0, 1
syscall
move $a0, $t2 #move number back from temp

addi $t4, $t4, 1 #using this to place a space every four bits
beq $t4, 4, gap_and #will output a space and jmpt back to continue output in myAnd

cont_output_and:

j loop_and

continue_program_and: #once sent to this label the program will jump to $ra which is back in main
 jr $ra #we will continue to the next function
 
gap_and:
	move $t2, $a0 #move number in to temp so we can use a0 to rint a number
	
	la $a0, space
	li $v0, 4
	syscall
	
	move $a0, $t2 #move number back from $t2 to $a0
	li $t4, 0 #reset counter 
j cont_output_and

#myAnd function ends here	
###############################################################################################################

###############################################################################################################
#myor function begins here	

myOr:
li $t9, 0 #clear $t9
li $t0, 0x80000000

bltz $s1, skip_one_or #if the number is <0 then the sign bit will be 1. 
			#the output will show a 0 in place of the sign bit, therefore we'll skip the comparison for the first test and just outpt a 0
bltz $s2, skip_one_or #same as above
j first_iter_or #this way we check the first bit on the first iteration 
	#(otherwise the mask would be shifted before we get a chance to check the first bit)
	
loop_or:	
	srl $t0, $t0, 1 #shift mask over one bit to compare next bit in number
	beq $t0, 0, continue_program_or #if the mask has been shifted all the way over program will continue
first_iter_or:
	and $t9, $a0, $t0 #this will ensure a !0 in $t9 if the bit in this position is set with a 1
	and $t8, $a1, $t0 #if the register is !0 we know this nth bit in our number is set with a 1
	bnez $t8, one_or #if either one of there registers contain a one we'll output a one
	bnez $t9, one_or
skip_one_or:
li $v0, 0 #...otherwise we load with $t9 with a zero 
j print_or #and jumpt to pront (skipping the "one_or" label)
 
one_or:
li $v0, 1 #loads $t9 with a 1
print_or:
move $t2, $a0 #number must be in $a0 in order to print so we will move to temp register

la $a0, ($v0)
li $v0, 1
syscall

move $t2, $a0 #move number back to $a0

addi $t4, $t4, 1 #using this to place a space every four bits
beq $t4, 4, gap_or #will output a space and jmpt back to continue output in myAnd

cont_output_or:

j loop_or

continue_program_or: #once sent to this label the program will jump to $ra which is back in main
 jr $ra #we will continue to the next function
 
gap_or:
	move $t2, $a0 #mve $a0, to $t2 so we can use $a0 for output
	
	la $a0, space
	li $v0, 4
	syscall
	move $a0, $t2 #move num back

	li $t4, 0 #reset counter 
j cont_output_or

#myOr ends here
###################################################################################################################################


###################################################################################################################################
#myXor starts here
myXor:
li $t9, 0 #clear $t9
li $t0, 0x80000000

bltz $s1, skip_one_xor #if the number is <0 then the sign bit will be 1. 
			#the output will show a 0 in place of the sign bit, therefore we'll skip the comparison for the first test and just outpt a 0
bltz $s2, skip_one_xor #same as above
j first_iter_xor #this way we check the first bit on the first iteration 
	#(otherwise the mask would be shifted before we get a chance to check the first bit)
	
loop_xor:	
	srl $t0, $t0, 1 #shift mask over one bit to compare next bit in number
	beq $t0, 0, continue_program_xor #if the mask has been shifted all the way over program will continue
first_iter_xor:
	and $t9, $a0, $t0 #this will ensure a !0 in $t9 if the bit in this position is set with a 1
	and $t8, $a1, $t0 #if the register is !0 we know this nth bit in our number is set with a 1
	beq $t8, $t9, skip_one_xor #if they're either both 1 or both zero we'll output a zero
	bnez $t8, one_xor #now that we know they're not both ones if one of these registers contain a one we'll output a 1
	bnez $t9, one_xor
	
skip_one_xor:
li $v0, 0 #...otherwise we load with $t9 with a zero 
j print_xor #and jumpt to pront (skipping the "one_or" label)

one_xor:
li $v0, 1 #loads $t9 with a 1
print_xor:
move $t2, $a0 #move number n1 to temp register in order to output current bit

la $a0, ($v0) #load either 1 or 0 into $a0 
li $v0, 1 # and print
syscall

move $a0, $t2 #move number n1 back to $a0

addi $t4, $t4, 1 #using this to place a space every four bits
beq $t4, 4, gap_xor #will output a space and jmpt back to continue output in myAnd

cont_output_xor:

j loop_xor

continue_program_xor: #once sent to this label the program will jump to $ra which is back in main
 jr $ra #we will continue to the next function
 
gap_xor: #this is where we jump to space every fourth bit
	move $t2, $a0 #move n1 to temp 
	
	la $a0, space
	li $v0, 4
	syscall
	move $a0, $t2 #move n1 back
	
	li $t4, 0 #reset counter 
j cont_output_xor

#myXor ends here
##################################################################################################################

#################################################################################################################
#myNOt starts here
myNot:
li $t4, 0 #clear $t4 for n2
li $t0, 0x80000000 #this ois where we load the mask into $t0, the mask basically looks like this right now: 1000 0000 0000 0000
		#as we continue we will keep shifting right the mask one bit at a time
		#so after 1 right shift it will lok like this: 0100 0000 0000 0000
		#after 2 shifts it'll be 0010 0000 0000 0000
		#this will continue until we've compared all 32 bit with the bits in our number
		
j first_iter_not #this way we check the first bit on the first iteration 
	#(otherwise the mask would be shifted before we get a chance to check the first bit)
loop_not:	
	srl $t0, $t0, 1 #shift mask over one bit to compare next bit in number
	beq $t0, 0, continue_program_not #if the mask has been shifted all the way over program will continue
first_iter_not:
	beq $s5, 1, n2 #if $s5 is loaded with 1 we know that we're up to n2 right now
	n1:		#otherwise we're working with n1
	and $t9, $a0, $t0 #this will ensure a !0 in $t9 if the bit in this position is set with a 0
	j cont_not
	n2: 
	and $t9, $a1, $t0 #this will ensure a !0 in $t9 if the bit in this position is set with a 0
cont_not:
beqz $t9,  one_not #if $t9 contains a zero we output a one

li $v0, 0 #...otherwise we load with $t9 with a zero 
 j print_not #and jumpt to pront (skipping the "one" label)
 
one_not:
li $v0, 1 #loads $t9 with a 1

print_not:

move $t2, $a0 #we need to do this for n1 which is stored in  $a0

la $a0, ($v0)
li $v0, 1
syscall

move $a0, $t2 #and move it back

addi $t4, $t4, 1 #using this to place a space every four bits
beq $t4, 4, gap_not

cont_output_not: #jumps here from the "gap" label 

j loop_not #this wil jump back to the beginning of the loop and repeate until all bits are printed

#exit:
li $v0, 10
syscall

gap_not:
	move $t2, $a0 #move $a0 to $t2 (only necessary for n1
	la $a0, space
	li $v0, 4
	syscall
	
	move $a0, $t2 #still only for n1
	
	li $t4, 0 #reset counter 
	j cont_output_not

continue_program_not:
jr $ra
#myNot function ends here
##################################################################################################################################################


.data
prompt: .asciiz "Please enter a number kind person:\n"
nl: .asciiz "\n"
space: .asciiz " "
space4: .asciiz "     "
with: .asciiz " AND "
line: .asciiz "\n     _______________________________________\n"
cout_or: .asciiz " OR  "
cout_xor: .asciiz " XOR "
negate: .asciiz "\nNOT "




