.START 1000
a: .dw 2
b: .dw  2

beg:
ADD a, b
OUT %A
STOP

.END beg
