
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:

            lb t0, 0(a0)     #first letter of word 1
            lb t1, 0(a1)     #first letter of word 2
            
loop:       beq t0, t1, next_letters     #if letters are equal
            bge t0, t1, exit             #if letter of word1 bigger than letter of word2 go to exit
            add a0, zero, zero           #letter of word1 smaller than word2 so set a0 to 0
            jr ra       
            
next_letters:
            beq t0,zero,exit     #if letters are \0
            addi a0,a0,1        
            addi a1,a1,1
            lb t0,0(a0)          #next letter of word 1
            lb t1,0(a1)          #next letter of word 2
            j loop            
        
exit:
            addi a0,zero,1     #word 1 was equal or longer than word 2
            jr   ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
            addi t3, zero, 1     # store value of 1
            beq a1, zero, return #check if size=0
            beq a1, t3, return   #check if size=1
            addi sp, sp, -12
            sw ra, 8(sp)         #store ra because when i call str_ge the ra changes value
            sw a0, 4(sp)         #store size of array on stack because a1 is input on str_ge
            sw a1, 0(sp)         #store address of array on stack because a0 is input on str_ge
            lw a1, 0(a0)         #store on a1 the first word of the array
            lw a0, 4(a0)         # store on a0 the second word of the array
            jal str_ge           #now a0 has either 1 if a1>=a0 or 0 if a1<a0
            addi t3, zero, 1
            beq a0, t3, next_element #if condition is true check the next elements
            lw ra, 8(sp)         #restore ra because it changed due to jal str_ge
            addi sp, sp, 12      #pop elements
            jr ra                #return and we dont change a0 because it already has 0 from jal str_ge(a0<a1)

next_element:
            lw a1, 0(sp)         #restore n from stack
            lw a0, 4(sp)         #restore address of array from stack
            addi a1, a1, -1      #size--;
            addi a0, a0, 4       #&arr[i]->&arr[i+1]
            jal recCheck
            lw ra, 8(sp)         #restroe ra
            addi sp, sp, 12      #pop elements
            jr ra
            
return:      
           addi a0,zero,1   
           jr ra 