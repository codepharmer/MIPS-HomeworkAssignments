.text
    .globl main
    
main:
    la $a0, prompt    # prompt int input
    li $v0, 4	
    syscall
        
         addi $v0, $zero, 5 #placing last number entered in $v0
    syscall       
    
     	add $v1, $zero, $v0 #moving num to $v1
     
     la $a0, blank    # prompt second num input
    li $v0, 4	
    syscall
    
    	addi $v0, $zero, 5 #placing last number entered in $v0
    syscall
    	add $t2, $zero, $v0 #moving num2 to $v2
    
    la $a0, yournum   #cout you r number qwas
    li $v0, 4	
    syscall 
    
    #print num
    add $a0, $zero, $v1 
    addi $v0, $zero, 1 
    syscall #sytem call
    
     la $a0, and #cout and
    li $v0, 4	
    syscall 
    
    #print num2
    add $a0, $zero, $t2 
    addi $v0, $zero, 1 
    syscall #sytem call
    
    
     la $a0, endl #cout endl 
    li $v0, 4	
    syscall 
    
      #print num
    add $a0, $zero, $v1 
    addi $v0, $zero, 1 
    syscall #sytem call
    
     la $a0, minus  #cout - 
    li $v0, 4	
    syscall 
    
    #print num2
    add $a0, $zero, $t2 
    addi $v0, $zero, 1 
    syscall #sytem call
    
     la $a0, plus  #cout + 
    li $v0, 4	
    syscall 
    
    #print num2
    add $a0, $zero, $t2 
    addi $v0, $zero, 1 
    syscall #sytem call
    
      la $a0, timestwo  #cout *2=
    li $v0, 4	
    syscall
    
    add $t3, $zero, $t2 #moving num to $v1
    addi $
    syscall
    
    #a-b+b*2
    

#################################################################
#                                #
#            data segment                #
#                                #
#################################################################

    .data
prompt:    .asciiz "Please enter two nums "
blank: .asciiz "\n"
yournum: .asciiz " Your numbers were "
and: .asciiz " and "
plus: .asciiz "+"
minus: "-"
timestwo: "*2="
endl: "\n"