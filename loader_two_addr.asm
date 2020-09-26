.start 0
program_code: .dw 2,4,3840,0,2,2304,65531,256				; a*b program code
program_iter: .dw 0							; program code iterator
mem_iter: .dw 0								; new memory location iterator 
var_indices: .dw 6, 8							; indices of the variable addreses in the program code of the a*b
var_indices_iter: .dw 0							; indices iterator
new_start: .dw 1000							; the address where you want to copy the program and run

begin:									; at the very beginning of the program I initialize iterators,
MOV program_iter, &program_code						; program iter now has the address of the first element of the code
MOV mem_iter, new_start							; memory iter is pointing to the first memory cell of the new address
MOV var_indices_iter, &var_indices					; var indices iterator points to the address of the first element in the
									; array of variable indices

copy:									; procedure that copies the program data to the new memory location
MOV *mem_iter, *program_iter						; move element of program code to the new memory location
JE program_iter, *var_indices_iter, add_address				; if program code iterator's value is the same as the value of 										; var_indices iterator, add new start address to that memory cell

increment_code_addresses:						; increments iterators and checks if the address of the program iterator 
ADD mem_iter, &2							; is equal to its value. Since iterator is declared just below the 
MOV mem_iter, %A							; actual code, when the iterator's address will be the same as value that
ADD program_iter, &2							; means that the iterator is at the end of the code and we are ready
MOV program_iter, %A							; to jump in the new memory location
JNE program_iter, &program_iter, copy					
JMP *new_start								

add_address:								; adds new start address to the variable reference
JE var_indices_iter, &var_indices_iter, increment_code_addresses	; firstly checks if the variable iterator is valid
ADD *mem_iter, new_start						; if it is valid, then adds new start to the values that are already 
MOV *mem_iter, %A							; written in the memory
ADD var_indices_iter, &2						
MOV var_indices_iter, %A						; increment variable indices iterator					
JMP increment_code_addresses						; jump to the program iterator incremental

.end begin
