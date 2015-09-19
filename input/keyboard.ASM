waitkey:
	mov ah, 0
	int 16h
	ret

input:
	pusha
	mov di, kbdbuffer
.loop:
	call waitkey
	cmp al, 13
	je .done
	cmp di, kbde
	jae .done
	cmp al, 8
	je .bk
	stosb
	mov ah, 0Eh
	int 10h
	jmp .loop
.bk:
	dec di
	mov ax, 0E08h
	int 10h
	mov al, ' '
	int 10h
	mov al, 8
	int 10h
	jmp .loop
.done:
	mov al, 0
	stosb
	popa
	mov si, kbdbuffer
	ret

kbdbuffer: times 256 db 0
kbde: