					; this porgram implements ascending insertion sort

.org 0
array: .dw 5,1,4,3,2			; array
n: .dw 5				; the size of the array
i: .dw 0				; pointer to the array 
j: .dw 0				; pointer to the array
prev_j: .dw 0				; helper variable to store arr[j-1]
loop_counter: .dw 1			; 
key: .dw 0				; helper variable to store current array element

main:
LDA #array				; insertion sort starts from the 1st element (not 0)
ADD #2					; write the address of the first element to the pointer i
STA i

insertion_sort:				; insertion sort procedure
LDA @i
STA key					; save current array element
LDA i					; initialize j = i - 1
SUB #2
STA j

shift_elements:				; this procedure shifts all the elements that are greater than current one position ahead in order to 
					; free space for the current element to be inserted
LDA #0					; loop break conditions: if j < 0 or arr[j] < key
CMP j
JL next_iteration
LDA key
CMP @j
JL next_iteration
LDA key
CMP @j
JE next_iteration
LDA j					; save current j value to the prev_j
STA prev_j
LDA j					; increment j
ADD #2
STA j
LDA @prev_j				; arr[j + 1] = arr[j]
STA @j
LDA prev_j				; j = j - 1
SUB #2
STA j
JMP shift_elements			

next_iteration:
LDA i					; increment both i and j
ADD #2					
STA i					
LDA j					
ADD #2					
STA j					
LDA key
STA @j					; arr[j + 1] = key
LDA loop_counter			; increment loop counter
ADD #1				
STA loop_counter
CMP n					; if loop counter == n, print the result
JNE insertion_sort			;
LDA #0					; to print the result, reset the counter and pointer to the array
STA loop_counter
LDA #array
STA i
JMP print_result

print_result:
LDA @i					; print current array value
OUT #1
LDA i
ADD #2					; increment array pointer i
STA i
LDA loop_counter			; increment loop counter
ADD #1
STA loop_counter
CMP n
JNE print_result			; when loop counter == n stop the program
HALT

.end main
