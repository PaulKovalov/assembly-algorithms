; This program is a translation of the similar one from the two address machine
; I firstly wrote the program for the two-address machine, so this one is similar
; The difference is that instead of MOV I use LDA & STA here
; as well as use LDA, CMP to compare two variables insted of comparing them in JMP command

; For more detailed comments please check the two-address version
.org 0
input_word: .dw 1000
input_length: .dw 0
curr_input_value: .dw 0
curr_input_address: .dw 0
tree: .dw 1494
curr_child_value: .dw 0
curr_child_address: .dw 0
curr_children_number: .dw 0
step: .dw 2

BEGIN:
; write input which is 1 -> 2 -> 3
LDA #1                  ; value of the first input node
STA @input_word
CALL add_step_input
LDA #1004
STA @input_word
CALL add_step_input
LDA #2                  ; value of the second input node
STA @input_word
CALL add_step_input
LDA #1008
STA @input_word
CALL add_step_input
LDA #3                  ; value of the third input node
STA @input_word
LDA #1000
STA input_word

; create tree, the structure of the tree is 0->1, 1->2, 1->4, 2->3, 2->5, 4-> 6 
LDA #0
STA @tree
CALL add_step
LDA #1
STA @tree
CALL add_step
LDA #1500
STA @tree
CALL add_step
LDA #1
STA @tree
CALL add_step
LDA #2
STA @tree
CALL add_step
LDA #1508
STA @tree
CALL add_step
LDA #1524
STA @tree
CALL add_step
LDA #2
STA @tree
CALL add_step
LDA #2
STA @tree
CALL add_step
LDA #1516
STA @tree
CALL add_step
LDA #1520
STA @tree
CALL add_step
LDA #3
STA @tree
CALL add_step
LDA #0
STA @tree
CALL add_step
LDA #5
STA @tree
CALL add_step
LDA #0
STA @tree
CALL add_step
LDA #4
STA @tree
CALL add_step
LDA #0
STA @tree
LDA #1494
STA tree

; procedure that compares input and the tree
check_in_tree:
LDA @input_word
STA curr_input_value ; get the current input value
CALL add_step
LDA @tree
STA curr_children_number ; get the number of children of the current tree node

; procedure that iterates over all children of the curent node and compares their value with the current input
find_next:
CALL add_step
LDA @tree
STA curr_child_address
LDA @curr_child_address
STA curr_child_value
LDA curr_child_value
CMP curr_input_value
JE input_next
LDA curr_children_number
SUB #1
STA curr_children_number
LDA #0
CMP curr_children_number
JE finish_fail
JMP find_next 
                
input_next: ; procedure to get the next nodes of the input and the tree: input_word = input_word->child
CALL add_step_input
LDA @input_word
STA input_word
LDA #0          ; check if the address of the next input node is 0. If it is then the input is finished and it is found
CMP input_word
JE finish_ok
LDA curr_child_address
STA tree
JMP check_in_tree

add_step: ; utility to add step to the tree
LDA step
ADD tree
STA tree
RET

add_step_input: ; utility to add step to the input_word
LDA step
ADD input_word
STA input_word
RET 

finish_ok: ; prints 1, called when input matches the tree
LDA #1
OUT #1
HALT

finish_fail: ; prints 1, called when input matches the tree
LDA #0
OUT #1
HALT

.END BEGIN

// this one is without coments so you could launch it
.org 0
input_word: .dw 1000
input_length: .dw 0
curr_input_value: .dw 0
curr_input_address: .dw 0
tree: .dw 1494
curr_child_value: .dw 0
curr_child_address: .dw 0
curr_children_number: .dw 0
step: .dw 2

BEGIN:

LDA #1
STA @input_word
CALL add_step_input
LDA #1004
STA @input_word
CALL add_step_input
LDA #2
STA @input_word
CALL add_step_input
LDA #1008
STA @input_word
CALL add_step_input
LDA #3
STA @input_word
LDA #1000
STA input_word

LDA #0
STA @tree
CALL add_step
LDA #1
STA @tree
CALL add_step
LDA #1500
STA @tree
CALL add_step
LDA #1
STA @tree
CALL add_step
LDA #2
STA @tree
CALL add_step
LDA #1508
STA @tree
CALL add_step
LDA #1524
STA @tree
CALL add_step
LDA #2
STA @tree
CALL add_step
LDA #2
STA @tree
CALL add_step
LDA #1516
STA @tree
CALL add_step
LDA #1520
STA @tree
CALL add_step
LDA #3
STA @tree
CALL add_step
LDA #0
STA @tree
CALL add_step
LDA #5
STA @tree
CALL add_step
LDA #0
STA @tree
CALL add_step
LDA #4
STA @tree
CALL add_step
LDA #0
STA @tree
LDA #1494
STA tree

check_in_tree:
LDA @input_word
STA curr_input_value
CALL add_step
LDA @tree
STA curr_children_number


find_next:
CALL add_step
LDA @tree
STA curr_child_address
LDA @curr_child_address
STA curr_child_value
LDA curr_child_value
CMP curr_input_value
JE input_next
LDA curr_children_number
SUB #1
STA curr_children_number
LDA #0
CMP curr_children_number
JE finish_fail
JMP find_next 

input_next:
CALL add_step_input
LDA @input_word
STA input_word
LDA #0
CMP input_word
JE finish_ok
LDA curr_child_address
STA tree
JMP check_in_tree

add_step:
LDA step
ADD tree
STA tree
RET

add_step_input:
LDA step
ADD input_word
STA input_word
RET 

finish_ok:
LDA #1
OUT #1
HALT

finish_fail:
LDA #0
OUT #1
HALT

.END BEGIN