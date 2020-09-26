.org 0
a: .dw 2
b: .dw 4

begin:
LDA a
MUL b
OUT #1
HALT

.end begin
