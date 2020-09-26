.org 0
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
LDA @i
STA key
LDA i
SUB #2
STA j
shift_elements:
LDA #0
CMP j
JL next_iteration
LDA key
CMP @j
JL next_iteration
LDA key
CMP @j
JE next_iteration
LDA j
STA prev_j
LDA j
ADD #2
STA j
LDA @prev_j
STA @j
LDA prev_j
SUB #2
STA j
JMP shift_elements
next_iteration:
LDA i
ADD #2
STA i
LDA j
ADD #2
STA j
LDA key
STA @j
LDA loop_counter
ADD #1		
STA loop_counter
CMP n
JNE insertion_sort
RET

binsearch:					; I comment only this code because other code is the previous lab's code
LDA r
CMP l
JG binsearch_fail				; if l > r - binsearch cannot find the element, so the element is not present in the array
LDA l
ADD r						; m = (l + r)/2
DIV #2
STA m
MUL #2           				; since l and r are indices (0 ... n), to get the address of the array cell I multiply it by two
STA m_value
LDA @m_value
CMP search
JE binsearch_stop				; this program sorts in ascending order, so conditions are not reversed - if the element is less 							; than the current then go right, if element is bigger - go left
JG binsearch_go_left				; current value is bigger - go left
JL binsearch_go_right				; current value is less - go right
binsearch_go_right:				; go right subroutine
LDA m						; l <- m
STA l
JMP binsearch					; go to binsearch start with new l and r boundaries
binsearch_go_left:
LDA m						; r <- m
STA r
JMP binsearch					; go to the binsearch start with the new l and r boundaries
binsearch_stop:					; binsearch jumps here when it found the element - here it just prints the found value
LDA @m_value
OUT #1
HALT
binsearch_fail:					; binsearch jumps here when it didn't find the element - here it prints -1
LDA #-1
OUT #1
HALT


main:
LDA #array
ADD #2
STA i
CALL insertion_sort
LDA r
STA n						; initialize right search boundary
JMP binsearch					; jump to binsearch

.end main
