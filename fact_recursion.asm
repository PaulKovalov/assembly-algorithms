.START 0
ans: .dw 0		; variable to store the temporary answer
n: .dw 7		; number to calculate factorial
stack: .dw 200		; stack pointer, initially it's value is 200. 
			; Further I will use this value to refer to the address that this variable points to
step: .dw 2		; Each stack element stores the return address and the data. The size of each stack element is 2 nominal bytes
			; so this variable denotes the step (offset) to get the next stack element
beg: 
MOV *stack, n           ; save n to the address which is pointed by stack (it is 200 now)
CALL fact		; call factorial subroutine
OUT *stack		; at this point the factorial has already been calculated and it's value is stored on the top of the stack,
			; so print the top of the stack
STOP

fact:
MOV n, *stack    	; The beginning of the fact function
			; At the very beginning, there is only one value saved in the stack - inital value of n
			; but we also need to update stack with the return address which is stored in register L, so move to the next stack
			; "element".
SUB stack, step		; subtract 2 from the current stack value (go to the next stack element)
MOV stack, %A		; save new stack value
MOV *stack, %L		; to the address at which now the stack points stack, push return address
JE n, &1, finish	; check if n == 1, which means that the stack is now comlete, go to the finish label and start calculating the factorial 				; itself
SUB stack, step		; subtract 2 from stack value and update the stack
MOV stack, %A		; 
SUB n, &1		; subtract 1 from n
MOV *stack, %A		; push new n value on stack
CALL fact		;
			; for now stack elements under the current element are created - they keep both the return address and the corresponding 				; value of n
MOV ans, *stack		; save current factorial value to the ans variable
ADD stack, step		; get next element's return address
MOV stack, %A		;
MOV %L, *stack		;
ADD stack, step		;
MOV stack, %A		; get next element's factorial value
MUL *stack, ans		; multiply it with the answer
MOV *stack, %A		; update stack value
RET
finish:
MOV %L, *stack		; if n == 1, then we are here. We load to the L register the latest return address
ADD stack, step		; and pop this value from the stack, so the topmost element is the factorial value
MOV stack, %A
RET

.END beg


