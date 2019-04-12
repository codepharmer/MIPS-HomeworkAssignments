.text
    .globl main
    
main:
    la $a0, prompt    # prompt int input
    li $v0, 4	
    syscall
        
         addi $v0, $zero, 5
    syscall       # au revoir...
    
    #print num
    add $a0, $zero, $v0 #putting num from ^ in $a0 which will be in next sycall
    addi $v0, $zero, 1 
    syscall #sytem call

#################################################################
#                                #
#            data segment                #
#                                #
#################################################################

    .data
prompt:    .asciiz "Input int \n "

