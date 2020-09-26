.org 0
program_code: .dw 2,4,576,0,4416,2,5120,1,8448		; a*b program code
program_iter: .dw 0					; program code iterator
mem_iter: .dw 0						; new memory location iterator 
var_indices: .dw 6, 10					; indices of the variable addreses in the program code of the a*b
var_indices_iter: .dw 0					; indices iterator
new_start: .dw 1000					; the address where you want to copy the program and run

begin:							; at the very beginning of the program I initialize iterators,	
LDA #program_code					
STA program_iter					; program iter now has the address of the first element of the code
LDA new_start
STA mem_iter						; memory iter is pointing to the first memory cell of the new address
LDA #var_indices					; var indices iterator points to the address of the first element in the
STA var_indices_iter					; array of variable indices


copy:							; procedure that copies the program data to the new memory location
LDA @program_iter
STA @mem_iter						; move element of program code to the new memory location
LDA program_iter
CMP @var_indices_iter					; if program code iterator's value is the same as the value of
JE add_address						; var_indices iterator, add new start address to that memory cell

increment_code_addresses:				; increments iterators and checks if the address of the program iterator 
LDA mem_iter						; is equal to its value. Since iterator is declared just below the 
ADD #2							; actual code, when the iterator's address will be the same as value that
STA mem_iter						; means that the iterator is at the end of the code and we are ready
LDA program_iter					; to jump in the new memory location
ADD #2
STA program_iter
CMP #program_iter					; iterator value and address comparison
JNE copy						
JMP @new_start						; jump to the new start if equal

add_address:						; adds new start address to the variable reference
LDA var_indices_iter					; firstly checks if the variable iterator is valid
CMP #var_indices_iter					; if it is valid, then adds new start to the values that are already
JE increment_code_addresses				; written in the memory
LDA new_start
ADD @mem_iter
STA @mem_iter
LDA var_indices_iter					
ADD #2							; increment variable indices iterator
STA var_indices_iter					
JMP increment_code_addresses				; jump to the program iterator incremental

.end begin
