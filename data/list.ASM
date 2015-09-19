; ax: in: stringlist location, out: list location
slistToList:
	pusha
	mov si, ax
	mov di, ax
	mov bx, .tmplist
.loop:
	lodsb
	cmp al, 0
	je .done
	cmp al, ','
	jne .next

	mov word [bx], di
	add bx, 2
	mov byte [si-1],0
	mov di, si
.next:
	jmp .loop
.done:
	popa
	mov word [bx], di
	add bx, 2
	mov word [bx], 0
	mov ax, .tmplist
	ret
.tmplist times 20 dw 0
; ax: in: filenamelist location, out: filelist location
fnamelistToFilelist:
	pusha
	mov si, ax
	mov cx, filebuff
	mov di, .tmplist
.loop:
	lodsw
	cmp ax, 0
	je .done

	call loadFile
	jc fatalError
	mov ax, cx
	stosw
	add cx, bx
	jmp .loop
.done:
	popa
	mov ax, .tmplist
	mov word [di], di
	add di, 2
	mov word [di], 0
	ret
.tmplist times 20 dw 0
filebuff equ endloc