loadVideoDriver:
	mov ax, 0xA000
	mov gs, ax
	mov ax, 13h
	int 10h
	ret

; drawPixel
; draw a pixel at   x:bx   y:dl   color:al
drawPixel:
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
	pop ax
	pop dx
	pop bx
	ret
getPixel:
	push bx
	push dx
	mov ax, 320
	mov dh, 0
	mul dx
	mov dx, ax
	add bx, dx
	mov al,[gs:bx]
	pop dx
	pop bx
	ret

; drawHLine
; draw a horizontal line from bx to cx in color al on row dl
drawHLine:
	pusha
.loop:
	call drawPixel
	inc bx
	cmp bx, cx
	jge .done
	jmp .loop
.done:
	popa
	ret
; drawVLine
; draw a vertical line from dl to cl in color al on colmn bx
drawVLine:
	pusha
.loop:
	call drawPixel
	inc dl
	cmp dl, cl
	jae .done
	jmp .loop
.done:
	popa
	ret

; drawRect
; draw a rectangle at  x:bx  y:dl  to  x:cx  y:dh  with  color:al
drawRect:
	pusha
	call drawHLine
	push dx
	mov dl,dh
	add cx, 1
	call drawHLine
	sub cx, 1
	pop dx
	push cx
	mov cl,dh
	call drawVLine
	pop bx
	call drawVLine
	popa
	ret
; drawPic
; draw an image at  x:bx  y:dl	to  x:cx  y:dh	image:ax
drawPic:
	pusha
	mov si, ax
	mov word [.tmp], bx
	sub cx,1
	sub dh, 1
	add cx, bx
	add dh, dl
	jmp .loopb
.loopa:
	inc dl
	cmp dl,dh
	ja .done
	mov word bx, [.tmp]
.loopb:
	lodsb
	call drawPixel
	cmp bx, cx
	jae .loopa
	inc bx
	jmp .loopb
.done:
	popa
	ret
.tmp dw 0
fillScreen:
	pusha
	mov bx, 0
.l:
	cmp bx, 0xFA00
	je .done
	mov [gs:bx],al
	inc bx

	jmp .l
.done:
	popa
	ret