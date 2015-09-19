pause:
	pusha
	cmp ax, 0
	je .time_up			; If delay = 0 then bail out

	mov cx, 0
	mov [.counter_var], cx		; Zero the counter variable

	mov bx, ax
	mov ax, 0
	mov al, 2			; 2 * 55ms = 110mS
	mul bx				; Multiply by number of 110ms chunks required 
	mov [.orig_req_delay], ax	; Save it

	mov ah, 0
	int 1Ah 			; Get tick count	

	mov [.prev_tick_count], dx	; Save it for later comparison

.checkloop:
	mov ah,0
	int 1Ah 			; Get tick count again

	cmp [.prev_tick_count], dx	; Compare with previous tick count

	jne .up_date			; If it's changed check it
	jmp .checkloop			; Otherwise wait some more

.time_up:
	popa
	ret

.up_date:
	mov ax, [.counter_var]		; Inc counter_var
	inc ax
	mov [.counter_var], ax

	cmp ax, [.orig_req_delay]	; Is counter_var = required delay?
	jge .time_up			; Yes, so bail out

	mov [.prev_tick_count], dx	; No, so update .prev_tick_count 

	jmp .checkloop			; And go wait some more


	.orig_req_delay 	dw	0
	.counter_var		dw	0
	.prev_tick_count	dw	0


executeFile:
	pusha
	mov ax, 0
	mov bx, 0
	mov cx, 0
	mov dx, 0
	mov si, 0
	mov di, 0
	call prg_start

.done:
	popa
	ret

fatalError:
	mov bx, 20
	mov cx, 100
	mov dl, 40
	mov dh, 100
	mov al, 4
	call drawRect
	mov bx, 22
	mov dl, 42
	mov dh, 6
	mov cx, 50
	mov ax, errorpic
	call drawPic
	jmp $
Y equ 14 ; color yellow
errorpic: ;1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0
	dw 4,4,4,4,0,0,4,4,0,0,4,4,4,4,0,0,4,4,0,0,4,0,0,0,0,0,0,0,0,4,4,4,4,0,4,4,4,0,0,4,4,4,0,0,0,0,Y,Y,0,0
	dw 4,0,0,0,0,4,0,0,4,0,0,0,4,0,0,4,0,0,4,0,4,0,0,0,0,0,0,0,0,4,0,0,0,0,4,0,0,4,0,4,0,0,4,0,0,Y,0,0,Y,0
	dw 4,4,4,4,0,4,4,4,4,0,0,0,4,0,0,4,4,4,4,0,4,0,0,0,0,0,0,0,0,4,4,4,4,0,4,0,0,4,0,4,0,0,4,0,0,Y,0,0,Y,0
	dw 4,0,0,0,0,4,0,0,4,0,0,0,4,0,0,4,0,0,4,0,4,0,0,0,0,0,0,0,0,4,0,0,0,0,4,4,4,0,0,4,4,4,0,0,Y,0,Y,Y,0,Y
	dw 4,0,0,0,0,4,0,0,4,0,0,0,4,0,0,4,0,0,4,0,4,0,0,0,0,0,0,0,0,4,0,0,0,0,4,0,4,0,0,4,0,4,0,0,Y,0,Y,Y,0,Y
	dw 4,0,0,0,0,4,0,0,4,0,0,0,4,0,0,4,0,0,4,0,4,4,4,0,0,0,0,0,0,4,4,4,4,0,4,0,0,4,0,4,0,0,4,0,Y,Y,Y,Y,Y,Y
print:
	pusha

	mov ah, 0Eh
	mov bl, 37h
.repeat:
	lodsb				; Get char from string
	cmp al, 0
	je .done			; If char is zero, end of string

	;cmp al, 13
	;je .nl
	int 10h
	jmp .repeat			; And move on to next char
.nl:
	;call os_print_newline
	jmp .repeat
.done:
	popa
	ret