.start 0
array: .dw 5,1,4,3,2
n: .dw 5
i: .dw 0
j: .dw 0
prev_j: .dw 0
loop_counter: .dw 1
key: .dw 0
						; variables for the binsearch
l: .dw 0					; left search boundary
r: .dw 0					; right search boundary
m: .dw 0					; (l + r) / 2
m_value: .dw 0					; the value of the array which is located in the address m
search: .dw 2					; the element to be found

insertion_sort:
MOV key, *i
SUB i, &2
MOV j, %A
shift_elements:
JL j, &0, next_iteration
JG *j, key, next_iteration
MOV prev_j, j
ADD j, &2
MOV j, %A
MOV *j, *prev_j
SUB prev_j, &2
MOV j, %A
JMP shift_elements
next_iteration:
ADD i, &2
MOV i, %A
ADD j, &2
MOV j, %A
MOV *j, key
ADD loop_counter, &1
MOV loop_counter, %A
JL loop_counter, n, insertion_sort
RET

binsearch:					; I comment only this code because other code is the previous lab's code
JG l, r, binsearch_fail				; if l > r - binsearch cannot find the element, so the element is not present in the array
ADD l, r					; m = (l + r)/2
DIV %A, &2					
MOV m, %A	
MUL m, &2					; since l and r are indices (0 ... n), to get the address of the array cell I multiply it by two
MOV m_value, %A					
JE *m_value, search, binsearch_stop		; this program sorts in descending order, so conditions are reversed - if the element is less 							; than the current then go left, if element is bigger - go right
JG *m_value, search, binsearch_go_right		; current value is bigger - go right
JL *m_value, search, binsearch_go_left		; current value is less - go left
binsearch_go_right:				; go right subroutine
MOV l, m					; l <- m + 1 because we don't need to consider element m again - we can go to m + 1
ADD l, &1
MOV l, %A					
JMP binsearch					; go to binsearch start with new l and r boundaries
binsearch_go_left:
MOV r, m					; r <- m - 1
SUB r, &1
MOV r, %A
JMP binsearch					; go to the binsearch start with the new l and r boundaries
binsearch_stop:					; binsearch jumps here when it found the element - here it just prints the found value
OUT *m_value
STOP
binsearch_fail:					; binsearch jumps here when it didn't find the element - here it prints -1
OUT &-1
STOP

main:
ADD &array, &2
MOV i, %A
CALL insertion_sort				; call insertion sort
MOV r, n					; initialize right search boundary
JMP binsearch					; jump to binsearch

.end main
