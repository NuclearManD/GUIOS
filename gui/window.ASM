dialogBox:
	pusha
	mov dl, 49
	mov bx, 74
	mov dh, 56
	mov cx, 125
	call drawRect
	inc bx
	inc dl
	mov dh, 6
	mov cx, 50
	call drawPic
.loop:
	call showCursor 		; just show the cursor
	mov ax, 1
	call pause

	call hideCursor

	call leftCheckMouse
	jc .done

	jmp .loop
.done:
	popa
	ret