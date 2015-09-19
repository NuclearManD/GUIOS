org 8500h
%include "cnos.lib"
mov ax, 0
call fillScreen
	cli
	push es
	mov ax, 0x0000
	mov es, ax
	
	mov ax, [es:0x0080]
	mov [ohandler], ax
	mov ax, [es:0x0082]
	mov [ohandlerseg], ax
	
	mov word [es:0x0080], IO_interrupt
	mov word [es:0x0082], 0x2000
	pop es
	sti
mov si, loaded
call print
ret


IO_interrupt:
	cli
	pusha
	push ds
	mov ax, 0x2000
	mov ds, ax

	cmp ax, 0
	je .print

	cmp ax, 1
	je .input

.done:
	pop ds
	popa
	sti
	iret
.print:
	call print
	jmp .done
.input:
	pop ds
	popa
	call input
	pusha
	push ds
	jmp .done
ohandler    dw 0
ohandlerseg dw 0
loaded	    db "done loading.",10,13, 0