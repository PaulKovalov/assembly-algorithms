.start 0
a: .dw 2
b: .dw 5

begin:
mul a, b
out %A
stop

.end begin
