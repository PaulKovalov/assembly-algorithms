.START 0
; I came up with the following strcuture of the tree node:
; Node has the "field" to keep its data, the field "number of children" that denotes
; the amount of the children nodes and the pointers (addresses) to the child nodes.
; So if, for example, the node has number of children = 5 then it keeps 5 consecutive addresses 
; of it's children
; For the input word I decided to simplify it a bit. Instead of keeping the number of children in the input word node,
; I assume that there is only 1 child node
input_word: .dw 1000        ; pointer to the input
curr_input_value: .dw 0     ; used in find next, store the value of the current input node
curr_input_address: .dw 0   ; used in find next, stores the address of the current input node
tree: .dw 1494              ; tree pointer
curr_child_value: .dw 0   ; used in find_next loop. This variable stores the amount of children of the current node
curr_child_address: .dw 0  ; used in find next loop. This variable is the address of the child node
curr_children_number: .dw 0  ; used in find_next loop. This variable stores the amount of children of the current node
step: .dw 2

begin:
; create input word. This is "123", which is represented in the three nodes 1->2->3
MOV *input_word, &1         ; the address 1000 now has value 1 (This is the input value. Change 1 to whatever you want, this will be the new node value)
CALL add_step_input
MOV *input_word, &1004      ; the address 1002 now has the value 1004, which is the address of the next node
CALL add_step_input
MOV *input_word, &2         ; the address 1004 now has the value 2 (This is the input value. Change 2 to whatever you want, this will be the new node value)
CALL add_step_input
MOV *input_word, &1008      ; the address 1006 now has the value 1008, which is the address of the next node
CALL add_step_input
MOV *input_word, &3         ; the address 1008 now has the value 3 (This is the input value. Change 3 to whatever you want, this will be the new node value)
MOV input_word, &1000       ; roll back the pointer to the input on the input beginning
; create tree itself. This has the following structure 0->1, 1->2, 1->4, 2->3, 2->5, 4-> 6
MOV *tree, &0               ; 1494 <- 0
CALL add_step               ; 1494 => 1496
MOV *tree, &1               ; 1496 <- 1 (0 element has 1 children)
CALL add_step               ; 1496 => 1498
MOV *tree, &1500            ; 1498 <- 1500
CAlL add_step               ; 1498 => 1500
MOV *tree, &1               ; 1500 <- 2
CALL add_step               ; 1500 => 1502
MOV *tree, &2               ; the first node has two children
CALL add_step               ; 1502 => 1504
MOV *tree, &1508            ; 1504 <- 1508 (address of the first child)
CALL add_step               ; 1504 => 1506
MOV *tree, &1524            ; 1506 <- 1524 (address of the second child)
CALL add_step               ; 1506 => 1508 (the address of the first child)
MOV *tree, &2               ; 1508 <- 2
CALL add_step               ; 1508 => 1510
MOV *tree, &2               ; child also has two children (3 and 5)
CALL add_step               ; 1510 => 1512 
MOV *tree, &1516            ; 1512 <- 1516 (address of 3)
CALL add_step               ; 1512 => 1514
MOV *tree, &1520            ; 1514 <- 1520 (address of 5)
CALL add_step               ; 1514 => 1516
MOV *tree, &3               ; 1516 <- 3 (first children)
CALL add_step               ; 1516 => 1518
MOV *tree, &0               ; child with the value 3 has no children
CALL add_step               ; 1518 => 1520
MOV *tree, &5               ; 1520 <- 5(second children)
CALL add_step               ; 1520 => 1522
MOV *tree, &0               ; child with the value 5 has no children
CALL add_step               ; 1522 => 1524, the address of the second child of the first node (1 -> 4)
MOV *tree, &4               ; 1524 <- 4
CALL add_step               ; 1524 => 1526
MOV *tree, &0               ; child with the value 4 has no children
MOV tree, &1494             ; After memory is filled with the values, roll back the tree pointer to the tree head
                            ; procedure that compares input and the tree
check_in_tree:
MOV curr_input_value, *input_word  ; get the current input value
CALL add_step                      ; 1494 => 1496
MOV curr_children_number, *tree    ; get the number of children of the current tree node
                            ; procedure that iterates over all children of the curent node and compares their value with the current input
find_next:
CALL add_step                       
MOV curr_child_address, *tree               ; get the address of the current node child
MOV curr_child_value, *curr_child_address   ; get the value of the current node child
OUT curr_child_value                        ; print the values of the nodes that are compared on this step
OUT curr_input_value                        ;
JE curr_child_value, curr_input_value, input_next; if the nodes' values are equal go to their children
SUB curr_children_number, &1                ; decrement the number of children by 1
MOV curr_children_number, %A                  
JE curr_children_number, &0, finish_fail    ; if no children left and no children has a value equal to the input's value - jump to finish_fail
JMP find_next                               ; otherwise continue search

input_next:                 ; procedure to get the next nodes of the input and the tree: input_word = input_word->child
CALL add_step_input
MOV input_word, *input_word
MOV tree, curr_child_address     ; update tree pointer with the address of the child

JE input_word, &0, finish_ok    ; check if the address of the next input node is 0. If it is then the input is finished and it is found
                                ; success
JMP check_in_tree               ; otherwise continue searching in the tree

add_step:                   ; utility to add step to the tree
ADD tree, step
MOV tree, %A
RET

add_step_input:             ; utility to add step to the input_word
ADD input_word, step
MOV input_word, %A
RET 

finish_ok:                  ; prints 1, called when input matches the tree
OUT &1
STOP

finish_fail:                ; prints 0, called when input doesn't match the tree
OUT &0
STOP

.END begin

// this one is without coments so you could launch it
.START 0
input_word: .dw 1000
curr_input_value: .dw 0
curr_input_address: .dw 0
tree: .dw 1494
curr_child_value: .dw 0
curr_child_address: .dw 0
curr_children_number: .dw 0
step: .dw 2

begin:

MOV *input_word, &1
CALL add_step_input
MOV *input_word, &1004
CALL add_step_input
MOV *input_word, &2
CALL add_step_input
MOV *input_word, &1008
CALL add_step_input
MOV *input_word, &3
MOV input_word, &1000

MOV *tree, &0
CALL add_step
MOV *tree, &1
CALL add_step
MOV *tree, &1500
CAlL add_step
MOV *tree, &1
CALL add_step
MOV *tree, &2
CALL add_step
MOV *tree, &1508
CALL add_step
MOV *tree, &1524
CALL add_step
MOV *tree, &2
CALL add_step
MOV *tree, &2
CALL add_step
MOV *tree, &1516
CALL add_step
MOV *tree, &1520
CALL add_step
MOV *tree, &3
CALL add_step
MOV *tree, &0
CALL add_step
MOV *tree, &5
CALL add_step
MOV *tree, &0
CALL add_step
MOV *tree, &4
CALL add_step
MOV *tree, &0
MOV tree, &1494

check_in_tree:
MOV curr_input_value, *input_word
CALL add_step           
MOV curr_children_number, *tree
find_next:
CALL add_step
MOV curr_child_address, *tree
MOV curr_child_value, *curr_child_address
OUT curr_child_value
OUT curr_input_value
JE curr_child_value, curr_input_value, input_next
SUB curr_children_number, &1
MOV curr_children_number, %A
JE curr_children_number, &0, finish_fail
JMP find_next 
input_next:
CALL add_step_input
MOV input_word, *input_word
JE input_word, &0, finish_ok
MOV tree, curr_child_address
JMP check_in_tree
add_step:
ADD tree, step
MOV tree, %A
RET
add_step_input:
ADD input_word, step
MOV input_word, %A
RET 

finish_ok:
OUT &1
STOP

finish_fail:
OUT &0
STOP

.END begin