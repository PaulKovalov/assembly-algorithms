					; this porgram implements descending insertion sort
.start 0
array: .dw 5,1,4,3,2			; array
n: .dw 5				; the size of the array
i: .dw 0				; pointer to the array 
j: .dw 0				; pointer to the array
prev_j: .dw 0				; helper variable to store arr[j-1]
loop_counter: .dw 1
key: .dw 0				; helper variable to store current array element

main:
ADD &array, &2				; insertion sort starts from the 1st element (not 0)
MOV i, %A				; write the address of the first element to the pointer i

insertion_sort:				; insertion sort procedure
MOV key, *i				; save current array element
SUB i, &2				; initialize j = i - 1
MOV j, %A

shift_elements:				; this procedure shifts all the elements that are greater than current one position ahead in order to 
JL j, &0, next_iteration		; free space for the current element to be inserted
JG *j, key, next_iteration		; loop break conditions: if j < 0 or arr[j] >= key (because it it descending sorting)
MOV prev_j, j				; save current j value to the prev_j
ADD j, &2				; increment j
MOV j, %A				
MOV *j, *prev_j				; arr[j + 1] = arr[j]
SUB prev_j, &2				
MOV j, %A				; j = j - 1
JMP shift_elements

next_iteration:
ADD i, &2				; increment both i and j
MOV i, %A
ADD j, &2
MOV j, %A
MOV *j, key				; arr[j + 1] = key
ADD loop_counter, &1			; increment loop counter
MOV loop_counter, %A
JL loop_counter, n, insertion_sort	; if loop counter == n, print the result
MOV loop_counter, &0			; to print the result, reset the counter and pointer to the array
MOV i, &array
JMP print_result

print_result:
OUT *i					; print current array value
ADD i, &2				; increment array pointer i
MOV i, %A
ADD loop_counter, &1			; increment loop counter
MOV loop_counter, %A
JL loop_counter, n, print_result	; when loop counter == n stop the program
stop

.end main
