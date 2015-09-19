drawDesktop:
	pusha
	mov si, .ld0
	call print

	mov ax, .stringloc
	call listFiles

	mov si, .ld2
	call print

	mov bx, 2
	mov dl, 2
	mov cx, 10
	mov dh, 10

	mov si, .stringloc
	call print
	mov al, 3
	call fillScreen
	mov word [.tmp], files
	mov word di, [.tmp]
	mov word [di], si
	add word [.tmp], 2
.loop:
	inc si
	cmp byte [si], 0
	je .done

	cmp byte [si], ','
	jne .loop

	inc si
	mov word di, [.tmp]
	mov word [di], si
	add word [.tmp], 2
	dec si

	mov byte [si], 0
	sub si, 4



	mov di, binext
	call stringCompare
	jnc .nx0

	mov ax, icons.shell
	mov cx, 10
	mov dh, 10
	call drawPic
	jmp .loopa
  .nx0:
	mov di, txtext
	call stringCompare
	jnc .nx1

	mov ax, icons.txt
	mov cx, 10
	mov dh, 10
	call drawPic
	jmp .loopa
  .nx1:
	mov di, icnext
	call stringCompare
	jnc .nx5

	mov ax, icons.icn
	mov cx, 10
	mov dh, 10
	call drawPic
	jmp .loopa
  .nx5:
	mov ax, icons.unknown
	mov cx, 10
	mov dh, 10
	call drawPic
  .loopa:
	add si, 4
	add bx, 11

	cmp bx, 300
	jb .loop

	add dl, 11
	mov bx, 2

	jmp .loop
.done:
	sub si, 4
	;call print
	mov di, binext
	call stringCompare
	jnc .nx2

	mov ax, icons.shell
	mov cx, 10
	mov dh, 10
	call drawPic
	jmp .exx
.nx2:
	mov di, txtext
	call stringCompare
	jnc .nx3

	mov ax, icons.txt
	mov cx, 10
	mov dh, 10
	call drawPic
	jmp .exx
.nx3:
	mov di, icnext
	call stringCompare
	jnc .nx4

	mov ax, icons.icn
	mov cx, 10
	mov dh, 10
	call drawPic
	jmp .exx
.nx4:
	mov ax, icons.unknown
	mov cx, 10
	mov dh, 10
	call drawPic
.exx:
	;mov si, .ld3
	;call print
	mov bx, 0
	mov dl, 0
	mov cx, 319
	mov dh, 199
	mov al, 42
	call drawRect
	mov dl, 189
	mov bx, 1
	mov cx, 10
	mov dh, 10
	mov ax, icons.power
	call drawPic
	popa
	ret
.ld0 db "GUI LKM Loading... (your files)",13,10,0
.ld1 db "[GUILKM]listed files...",13,10,0
.ld2 db "[GUILKM]building images...",13,10,0
.stringloc times 512 db 0
.tmp dw 0
files times 20 dw 0
processClick:
	call getMousePos
	cmp dx, 189
	jb .calc
	cmp cx, 11
	ja .calc
	call os_off
	ret
.calc:
	cmp dx, 2
	jb .done
	cmp cx, 2
	jb .done

	mov word [.y], dx

	mov word ax, cx
	sub	 ax, 2		       ;$2, %eax
	mov	 dx, 5957	       ;$-1171354717, %edx
	mul	 dx		       ;%edx
	;shl	  dx, 2
	mov	 cx, dx 	       ;%edx, %ecx
	mov word ax, [.y]		;y(%rip), %eax
	sub	 ax, 2		       ;$2, %eax
	mov	 dx, 5957	       ;$-1171354717, %edx
	mul	 dx
	;shl	  dx, 2
	mov	 ax, dx 	       ;%edx, %eax
	mov	 dx, 27
	mul	 dx
	add	 ax, cx
	mov	 dx, 2
	mul	 dx
	mov	 di, ax
	;shl	  di, 2
	add	 di, files

	mov ax, [di]
	call openfile
.done:
	ret
.x dw 0
.y dw 0
txtext db ".TXT",0
binext db ".PGG",0
icnext db ".ICN",0

openfile:
	pusha
	push ax
	mov bx, ax
	call stringLength
	sub ax, 4
	add ax, bx
	mov si, ax
	pusha
	mov dx, 0
	mov ah, 2
	mov bh, 0
	int 10h
	popa

	mov di, txtext
	call stringCompare
	jc .opentxt
	mov di, binext
	call stringCompare
	jc .openbin
	mov di, icnext
	call stringCompare
	jc .openicn

	mov ax, .unrecognisedicn
	call dialogBox
	pop ax
.done:
	popa
	call drawDesktop
	ret
.opentxt:
	mov al, 0
	call fillScreen
	pop ax
	mov cx, diskstrbuff
	call loadFile
	mov si, diskstrbuff
	call print
	mov si, .anykey
	call print
	call waitkey
	jmp .done
.openbin:
	mov al, 0
	call fillScreen
	pop ax
	mov cx, prg_start
	call loadFile
	call executeFile
	jmp .done
.openicn:
	mov al, 0
	call fillScreen
	pop ax
	mov cx, diskstrbuff
	call loadFile
	mov si, diskstrbuff
	lodsw
	mov cx, ax
	lodsw
	mov dh, al
	mov bx, 50
	mov dl, 100
	mov ax, diskstrbuff+4
	call drawPic
	mov si, .anykey
	call print
	call waitkey
	jmp .done
.anykey db 13,10,"any key to exit.",0
.unrecognisedicn:
	db 4,0,0,4,0,4,0,0,4,0,4,4,4,0,0,4,4,4,4,0,4,4,4,4,0,0,0,0,0,4,4,4,4,0,4,4,4,0,0,4,4,4,0,0,0,0,Y,Y,0,0
	db 4,0,0,4,0,4,4,0,4,0,4,0,0,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,4,0,0,0,0,4,0,0,4,0,4,0,0,4,0,0,Y,0,0,Y,0
	db 4,0,0,4,0,4,4,0,4,0,4,0,0,4,0,4,4,4,4,0,4,0,0,0,0,0,0,0,0,4,4,4,4,0,4,0,0,4,0,4,0,0,4,0,0,Y,0,0,Y,0
	db 4,0,0,4,0,4,0,4,4,0,4,4,4,0,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,4,0,0,0,0,4,4,4,0,0,4,4,4,0,0,Y,0,Y,Y,0,Y
	db 4,0,0,4,0,4,0,4,4,0,4,0,4,0,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,4,0,0,0,0,4,0,4,0,0,4,0,4,0,0,Y,0,Y,Y,0,Y
	db 0,4,4,0,0,4,0,0,4,0,4,0,0,4,0,4,4,4,4,0,4,4,4,4,0,0,0,0,0,4,4,4,4,0,4,0,0,4,0,4,0,0,4,0,Y,Y,Y,Y,Y,Y


icons:
.shell:
	db 3,3,3,03,03,03,03,3,3,3	; icon
	db 3,3,3,03,03,03,03,3,3,3
	db 3,3,3,03,07,07,03,3,3,3
	db 3,3,3,15,15,15,15,3,3,3
	db 3,3,7,15,01,01,15,7,3,3
	db 3,3,7,15,01,01,15,7,3,3
	db 3,3,3,15,15,15,15,3,3,3
	db 3,3,3,03,07,07,03,3,3,3
	db 3,3,3,03,03,03,03,3,3,3
	db 3,3,3,03,03,03,03,3,3,3
.txt:
	db 3,3,3,3,3,3,3,3,3,3	    ; icon
	db 3,7,7,7,7,7,7,7,3,3
	db 3,7,8,8,8,7,8,7,7,3
	db 3,7,7,7,7,7,7,7,7,3
	db 3,7,8,8,8,8,7,8,7,3
	db 3,7,7,7,7,7,7,7,7,3
	db 3,7,8,8,7,8,8,8,7,3
	db 3,7,7,7,7,7,7,7,7,3
	db 3,7,7,7,7,7,7,7,7,3
	db 3,3,3,3,3,3,3,3,3,3
.icn:
	db 3,3,3 ,3 ,3 ,3,3,3,3,3      ; icon
	db 3,6,6 ,6 ,6 ,6,6,6,6,3
	db 3,6,14,42,42,2,2,2,6,3
	db 3,6,42,9 ,2 ,2,2,2,6,3
	db 3,6,42,9 ,9 ,9,6,9,6,3
	db 3,6,9 ,9 ,9 ,9,6,9,6,3
	db 3,6,9 ,9 ,9 ,9,2,2,6,3
	db 3,6,10,10,10,2,2,2,6,3
	db 3,6,6 ,6 ,6 ,6,6,6,6,3
	db 3,3,0 ,0 ,3 ,3,0,0,3,3
.unknown:
	db 3,3,3,3,3,3,3,3,3,3
	db 3,3,8,8,8,8,8,3,3,3
	db 3,3,3,3,3,3,3,8,3,3
	db 3,3,3,3,3,3,3,8,3,3
	db 3,3,3,3,8,8,8,3,3,3
	db 3,3,3,3,8,3,3,3,3,3
	db 3,3,3,3,3,3,3,3,3,3
	db 3,3,3,3,8,3,3,3,3,3
	db 3,3,3,3,8,3,3,3,3,3
	db 3,3,3,3,3,3,3,3,3,3
.power:
	db 4,4,4,4,4,4,4,4,4,4
	db 4,9,1,1,1,1,1,1,9,4
	db 4,1,9,9,9,9,9,9,1,4
	db 4,1,9,9,1,9,9,9,1,4
	db 4,1,9,9,1,9,9,9,1,4
	db 4,1,9,9,1,9,9,9,1,4
	db 4,1,9,9,1,9,9,9,1,4
	db 4,9,1,9,1,9,1,1,9,4
	db 4,9,9,9,1,9,9,9,9,4
	db 4,4,4,4,4,4,4,4,4,4