org 8500h
mov si, msg
call 3
call 105
ret
msg db "testing 1.. 2.. 3..",13, 10, "any key to exit this funny program.",0