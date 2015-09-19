org 8500h
main:
	call draw
mainloop:
	call freeMove
	call getMousePos
	cmp cx, 20
	jb .chcl
	cmp cx, 300
	ja .chtb
	mov bx, cx
	mov al, [color]
	call drawP
	jmp mainloop
	ret
.chcl:
	mov ax, dx
	mov dl, 12
	mul dl
	mov byte [color], ah
	jmp mainloop
.chtb:
	cmp dx, 20
	jb end
	jmp mainloop
draw:
	pusha
	mov al, 0
	mov bx, 0
	mov cx, 20
	mov dl, 0
	mov dh, 19
.loop1:
	call drawRect
	inc al
	add dl, 20
	add dh, 20
	cmp al, 9
	jb .loop1
	mov al, 15
	call drawRect
.drawicn:
	mov dl, 0
	mov bx, 300
	mov dh, 20
	mov cx, 20
	mov ax, exiticn
	call drawPic
	popa
	ret
drawP:
	push bx
	push dx
	push ax
	mov ax, 320
	mov dh, 0
	mul dx
	mov dx, ax
	pop ax
	push ax
	add bx, dx
	mov [gs:bx],al
	mov [bufx+bx],al
	pop ax
	pop dx
	pop bx
	ret
end:
	mov ax,0
	call fillScreen
	mov si, save
	call print
	call waitkey
	cmp al, 'y'
	jne .nosave
	mov si, fn
	call print
	call input
	mov ax,si
	mov bx,buff
	mov cx, 0xFA02
	call fileWrite
.nosave:
	ret
fn   db "file name> ",0
save db "y to save, n to quit.",0

;------------------------------------------
; DATA SECTION
;------------------------------------------
exiticn:
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,4
	db 4,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,4
	db 4,0,0,6,6,0,0,0,0,0,0,0,0,0,0,6,6,0,0,4
	db 4,0,0,0,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,4
	db 4,0,0,0,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,4
	db 4,0,0,0,0,6,6,0,0,0,0,0,0,6,6,0,0,0,0,4
	db 4,0,0,0,0,0,6,6,6,0,0,6,6,6,0,0,0,0,0,4
	db 4,0,0,0,0,0,0,6,6,6,0,6,6,0,0,0,0,0,0,4
	db 4,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,4
	db 4,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,4
	db 4,0,0,0,0,0,0,6,6,0,0,6,6,0,0,0,0,0,0,4
	db 4,0,0,0,0,0,6,6,0,0,0,0,6,6,0,0,0,0,0,4
	db 4,0,0,0,0,6,6,0,0,0,0,0,0,6,6,0,0,0,0,4
	db 4,0,0,0,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,4
	db 4,0,0,0,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,4
	db 4,0,0,6,6,0,0,0,0,0,0,0,0,0,0,6,6,0,0,4
	db 4,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,4
	db 4,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
color db 1
%include "cnos.lib"
buff:
dw 320,200
bufx: