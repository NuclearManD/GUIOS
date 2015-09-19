; I/O: ax is string and string length
stringLength:
	push si
	push bx
	mov si, ax
	mov bx, 0
.loop:
	lodsb
	cmp al, 0
	je .done
	inc bx
	jmp .loop
.done:
	mov ax, bx
	pop bx
	pop si
	ret
stringUpper:
	push si
	push ax
	mov si, ax
.loop:
	cmp byte [si], 0
	je .done
	cmp byte [si], 'a'
	jb .no
	cmp byte [si], 'z'
	ja .no
	sub byte [si], 20h
.no:
	inc si
	jmp .loop
.done:
	pop ax
	pop si
	ret

stringLower:
	push si
	push ax
	mov si, ax
.loop:
	cmp byte [si], 0
	je .done
	cmp byte [si], 'A'
	jb .no
	cmp byte [si], 'Z'
	ja .no
	add byte [si], 20h
.no:
	inc si
	jmp .loop
.done:
	pop ax
	pop si
	ret

stringCompare:
	pusha
.loop:
	lodsb
	cmp al, [di]
	jne .ne

	cmp al, 0
	je .done
	inc di
	jmp .loop
.ne:
	popa
	clc
	ret
.done:
	popa
	stc
	ret
