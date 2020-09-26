; I came up with the idea of storing 3 values in the each stack element - 
; Return address (value of %L), Fn - 1, Fn. The next stack element stores
; Fn and Fn + 1 etc. So if I start with the initial stack element that has
; F1 = 1, F2 = 1 and empty return address, I can find F3, which is the sum of
; the previous stack elements


.org 0
n: .dw 5		; index of the fibonacci number we have to calculate
f1: .dw 1 		; first fibonacci number = 1
f2: .dw 1		; second fibonacci number = 1
ans: .dw 0		; variable to store temporary answer
stack: .dw 2000		; pointer to stack
step: .dw 2		; the size of the element on the stack
double_step: .dw 4	; the size of the two elements in the stack, I need it to fast access the previous fibonacci number

BEGIN:			; in the beginning of the program, push f1 and f2 onto the stack
LDA f1			; load f1 to the register A
STA @stack		; save to the address at which points stack (push onto stack)
LDA stack		; go to the next stack element
SUB step		;
STA stack		;
LDA f2			; load f2 to the register A
STA @stack		; push onto the stack
CALL FIB		; call FIB subroutine
LDA @stack		; at this point, the top-most stack element has Fn
OUT #1			; write it to the display port #1
HALT			; stop the program
.END BEGIN

FIB:			; start FIB subprogram
LDA stack		; Now stack has f1 and f2. Push %L to it and the element is complete
SUB step		;
STA stack		;
STL @stack		;

LDA n			; check if n == 1. If it is, go to finish label. Otherwise subtract 1 from n and go on
CMP #1			;
JE FINISH		;

LDA n			; n - 1
SUB #1			;
STA n			;

LDA stack		; Now calculate Fn using previous stack element (Fn-2, Fn-1)
ADD double_step		; Adding double_step gives me access to the address of the Fn-1
STA f1			; save address of the Fn-1 to the temporary variable f1
LDA stack		; 
ADD step		; Adding step gives me access to the address of the Fn-2
STA f2			; save address of the Fn-2 to the temporary variable f2

LDA @f1			; Now get the value of the Fn - 1, add it to the answer
ADD ans			; 
STA ans			;
LDA @f2			; Get the value of the Fn - 2, add it to the answer
ADD ans			;
STA ans			;

LDA stack		; Once we have calculated the Fn as the sum of the Fn - 1 and Fn - 2, push Fn and Fn - 1, onto the stack so we could
			; calculate Fn + 1 in the next recursive call
SUB step		; Go to the next stack element
STA stack		;
LDA ans			;
STA @stack		; push Fn onto the stack
LDA stack		; 
SUB step		;
STA stack		;
LDA @f1			; push Fn - 1 onto the stack
STA @stack		;
LDA #0			; clear ans variable
STA ans			;
CALL FIB		; continue this while n != 1 

LDA @stack		; At this point n = 1, the stack now has the answer but it is on it's bottom. So now we have to push it onto the top
STA ans			; Get the last element in the stack (which is answer) 
LDA stack		; Get the return address from the stack
ADD step		; 
STA stack		;
LDL @stack		; Load return address to the register L
LDA stack		; Go to the Fn - 2 address
ADD double_step		;
STA stack		;
LDA ans			; And update it's value with the answer, so on the last call the address 2000 will have the answer
STA @stack		
RET

FINISH:
LDL @stack		; On the top of the stack is the return address, save it to the register L
LDA stack		; Add double_step and to go to the address of the Fn
ADD double_step		;
STA stack		;
RET
