.text
.globl main

main:
	la $s0, vowels #arr vowels stored in $s0
	la $s7 vwlsum #stores array sum of of vowels in $s7
	
	move $t0, $zero
	move $t1, $zero  #these make sure all registers are set to zero
	move $t2, $zero
	move $t7, $zero
	move $t8, $zero
	
	
input:	
	la $a0, prompt #input a word
	li $v0, 4
	syscall
	
	
	li $v0, 8	# reads in string
        la $a0, usrwrd 	# load space in usrwrd
        li $a1, 15 #number of bytes
        move $s1, $a0 #word is stored in $s1
        syscall
	
	 
nextChar: #jump to here to check next if next char of word is a/or which vowel
	lb $t2, 0($s0) # $t1 holds vowels and will store which ever vowel is indexed in $s0
	
	
	lb $t1, 0($s1)  #load indexed character from word
	
	
	beq $t1, 10 finalCountdown #break if $t1 contains '\n'
	
	
	
	#how to exit loop 	
	
	beq $t2, $t1 aplus # adds 1 to the total number of a's in the word
	jal iplus1 #this function increments the index in the array and stores the next vowel in $t2
	
	beq $t2, $t1 eplus #these 'beq' branches all check to see if the currnet char == to the vowel being compared against
	jal iplus1

	beq $t2, $t1 iplus #not to be confused with "iplus1" which increments the index
	jal iplus1
	
	beq $t2, $t1 oplus 
	jal iplus1

	beq $t2, $t1 uplus 
	jal iplus1
	
	beq $t2, $t1 yplus 

	add $s1, $s1, 1 #increments index to next letter of the word
	
	jal ireset #resets the vowel arr index
	
	j nextChar
	#if char isn't a vowel jump back to loop
	j finalCountdown

err:
	la $a0, error #no vowels or y in the word
	li $v0, 4
	syscall
	
	j input
	
#counters *MUST* be stored in memory (array)
aplus:
	#la $s7, vwlsum #loads adress of vwlsum into $s7
	
	lw $t0, 0($s7) #loads the first 32 bytes into $s6 (index is 0)
	add $t0, $t0, 1 # adds 1 to 
	
	sw $t0, 0($s7)
	
	lw $t3, 0($s7)
	#$t3=a $t4=e $t5=i $t6=o $t7=u $t8=y $t1 holds current charcter

	add $s1, $s1, 1 #increments index to next letter of the word
	
	
	jal ireset #resets the vowel arr index
	
	j nextChar #now we check if the next char is a vowel
	
eplus:
	lw $t0, 4($s7) #loads the first 32 bytes into $s6 (index is 0)
	add $t0, $t0, 1 # adds 1 to 
	
	sw $t0, 4($s7)
	
	lw $t4, 4($s7)
	
	
	#$t3=a $t4=e $t5=i $t6=o $t7=u $t8=y $t1 holds current charcter

	add $s1, $s1, 1 #increments index to next letter of the word
	
	jal ireset #resets the vowel arr index
	
	j nextChar #now we check if the next char is a vowel
		
iplus:
	lw $t0, 8($s7) #loads the first 32 bytes into $s6 (index is 0)
	add $t0, $t0, 1 # adds 1 to 
	
	sw $t0, 8($s7)
	
	lw $t5, 8($s7)
	#$t3=a $t4=e $t5=i $t6=o $t7=u $t8=y $t1 holds current charcter
	
	add $s1, $s1, 1 #increments index to next letter of the word
	
	jal ireset #resets the vowel arr index
	
	j nextChar #now we check if the next char is a vowel
 
 oplus:
	lw $t0, 12($s7) #loads the first 32 bytes into $s6 (index is 0)
	add $t0, $t0, 1 # adds 1 to 
	
	sw $t0, 12($s7)
	
	lw $t6, 12($s7)
	#$t3=a $t4=e $t5=i $t6=o $t7=u $t8=y $t1 holds current charcter
	
	
	add $s1, $s1, 1 #increments index to next letter of the word
	
	
	jal ireset #resets the vowel arr index
	
	j nextChar #now we check if the next char is a vowel
uplus:
	lw $t0, 16($s7) #loads the first 32 bytes into $s6 (index is 0)
	add $t0, $t0, 1 # adds 1 to 
	
	sw $t0, 16($s7)
	
	lw $t7, 16($s7)
	#$t3=a $t4=e $t5=i $t6=o $t7=u $t8=y $t1 holds current charcter
	
	add $s1, $s1, 1 #increments index to next letter of the word
	
	jal ireset #resets the vowel arr index
	
	j nextChar #now we check if the next char is a vowel

yplus:
	lw $t0, 20($s7) #loads the first 32 bytes into $s6 (index is 0)
	add $t0, $t0, 1 # adds 1 to 
	
	sw $t0, 20($s7) #puts $t0 back into the toal number of y's therby adding 1 tot he total
	
	lw $t8, 20($s7)
	#$t3=a $t4=e $t5=i $t6=o $t7=u $t8=y $t1 holds current charcter
	
	add $s1, $s1, 1 #increments index to next letter of the word
	
	jal ireset #resets the vowel arr index
	
	j nextChar #now we check if the next char is a vowel

iplus1:
	
	add $s0, $s0, 1 # index += 1
	lb $t2, 0($s0) #stores next vowel in $t2
	
	jr $ra	# Jumps back to where it left off, this time testing against the next vowel
ireset:
	
	la $s0, vowels # resets the vowel index loading address of vowels to $s0
	
	lb $t2, 0($s0) #loading $t2 with the byte located at the first index of vowels

	jr $ra
	

finalCountdown: #almost there!!
	
	move $t0, $zero #clear $t0
	#we will sum up the total vowels in the word and store in $t0
	lw $t1, 0($s7) #load total number of a's into $t1
	add $t0, $t0, $t1
	lw $t1, 4($s7) #load total number of e's into $t1
	add $t0, $t0, $t1
	lw $t1, 8($s7) #load total number of i's into $t1
	add $t0, $t0, $t1
	lw $t1, 12($s7) #load total number of o's into $t1
	add $t0, $t0, $t1
	lw $t1, 16($s7) #load total number of u's into $t1
	add $t0, $t0, $t1
	#lw $t1, 20($s7) #load total number of y's into $t1
	#add $t0, $t0, $t1
	# If the word contains vowels the total number of vowels is in here, 
	#otherwise the total of vowels is in $t8, the register holding the sum of y's
	
	beqz $t0, yisvowel #will skip to "y is a vowel" if there are no other vowels in the word
	
	
	la $a0, space
	li $v0, 4
	syscall	
	
	la $a0, totalvowels 
	li $v0, 4
	syscall	
	
	la $a0, ($t0)
	li $v0, 1
	syscall
	
	la $a0, space 
	li $v0, 4
	syscall
	
	la $a0, ithad 
	li $v0, 4
	syscall

	
	lw $s1, 0($s7) #load total number of a's into $s1
	beqz $s1, totalEs #if there are no A's in the word program branches to check for E's
	jal numAs
	totalEs:
	lw $s1, 4($s7) #load total number of e's into $t1
	beqz $s1, totalIs
	jal numEs
	totalIs:
	lw $s1, 8($s7) #load total number of e's into $t1
	beqz $s1, totalOs
	jal numIs
	totalOs:
	lw $s1, 12($s7) #load total number of e's into $t1
	beqz $s1, totalUs
	jal numOs
	totalUs:
	lw $s1, 16($s7) #load total number of e's into $t1
	beqz $s1, noUs
	jal numUs
	
	noUs:
	
	la $a0, thanks
	li $v0, 4
	syscall
	
	li $v0, 10 #exit
	syscall
	
	
yisvowel:
	lw $t8, 20($s7)
	beqz $t8, err
	
	la $a0, onlyY # cout Y was the vowel in this word
	li $v0, 4
	syscall
	
	
	la $a0, ($t8) # cout total number of y's
	li $v0, 1
	syscall
	
	la $a0, ys #other jibberish
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
numAs:	

 	 #the following labels output the total occurances of each vowel

	la $a0, As #cout total num of a's is...
	li $v0, 4
	syscall
	la $a0, ($s1) #load the total number of a's which is currentky in s1
	li $v0, 1
	syscall
	
	jr $ra

numEs:	

	la $a0, Es
	li $v0, 4
	syscall
	la $a0, ($s1)
	li $v0, 1
	syscall
	jr $ra

numIs:	

	la $a0, Is
	li $v0, 4
	syscall
	la $a0, ($s1)
	li $v0, 1
	syscall
	jr $ra

numOs:	

	la $a0, Os
	li $v0, 4
	syscall
	la $a0, ($s1)
	li $v0, 1
	syscall
	jr $ra

numUs:	

	la $a0, Us
	li $v0, 4
	syscall
	la $a0, ($s1)
	li $v0, 1
	syscall
	jr $ra

	



.data
vowels: .byte  'a','e','i','o','u','y' #loads these vowls into 'vowels'
usrwrd: .space 16 # assigns 16 bytes to the usrword (one for enter)
.align 2 #necessary to keep things in check (otherwise vwlsum will run into some serious issues)
vwlsum: .space 24


prompt: .asciiz "Please input a word. (Lowercase please)\n"
space: .asciiz "\n"
error: .asciiz "\nHmmm.... are you sure this isn't some kind of trick?? \nThis word doesn't seem to contain any vowels nor can I find any y's.\nTry a different word\n"
onlyY: .asciiz "\n Only y was a vowel. \"Why??\" yes y :P\n How many? It seems that there were a total of "
ys: .asciiz "y's. Thanks for your participation, please come back soon, it gets boring around here :p \n"
totalvowels: .asciiz "\nThe total number of vowels in this word is: "
ithad: .asciiz "Here's the total number of each vowel.\n"
As: .asciiz "\nThe number of A's were: "
Es: .asciiz "\nThe number of E's were: "
Is: .asciiz "\nThe number of I's were: "
Os: .asciiz "\nThe number of O's were: "
Us: .asciiz "\nThe number of U's were: "
iternum: .asciiz "\nNext iteration:\n "
check: .asciiz "-\n"
iniplus1: .asciiz "\nCurrently in iplus1!!!\n"
thanks: .asciiz "\nThanks for your participation in this experimental AI platform :) \nPlease come back soon.\n"






