;----------------------------------------------------------------------------------------------------------
; CNOS kernel, made by Dylan Brophy (except for file system, thats made by Mike who is AWESOME!)
;----------------------------------------------------------------------------------------------------------

stringloc	equ	endloc
disk_buffer	equ	8000h
prg_start	equ	8500h
diskstrbuff	equ	0A000h

use16
jmp start

jmp print
jmp pause

jmp drawPixel
jmp drawHLine
jmp drawVLine
jmp drawRect
jmp drawPic
jmp fillScreen

jmp listFiles
jmp loadFile
jmp fileWrite
jmp fileExists
jmp fileCreate
jmp fileDelete
jmp fileRename
jmp fileSize

jmp getMousePos
jmp setMousePos
jmp showCursor
jmp hideCursor
jmp mouseWait
jmp checkMouseClick
jmp leftCheckMouse
jmp middleCheckMouse
jmp rightCheckMouse
jmp waitMouse
jmp freeMove
jmp getExtKey
jmp indicateThink

jmp stringLength
jmp stringUpper
jmp stringLower
jmp stringCompare

jmp dialogBox

jmp waitkey

jmp slistToList
jmp fnamelistToFilelist

jmp input

start:
	cli		       ; no interrupts
	mov ax, 0
	mov ss, ax
	mov sp, 0FFFFh
	sti

	cld


	mov ax, 2000h			; Set all segments to match where kernel is loaded
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov ax, 0A000h
	mov gs, ax

	cmp dl, 0
	je no_change
	mov [bootdev], dl		; Save boot device number
	push es
	mov ah, 8			; Get drive parameters
	int 13h
	pop es
	and cx, 3Fh			; Maximum sector number
	mov [SecsPerTrack], cx		; Sector numbers start at 1
	movzx dx, dh			; Maximum head number
	add dx, 1			; Head numbers start at 0 - add 1 for total
	mov [Sides], dx

no_change:

	call loadVideoDriver		; loading video system
	mov si, ldsr.ld0
	call print
	mov ax, 0
	mov bx, 0
	mov cx, 319
	mov dx, 199
	call setMouseRange
	mov dx, 202h
	call setMouseScale
	call mouseInit			; loading mouse driver
	;call loadinterrupts
	mov si, ldsr.ld1
	call print
restorepoint:
	call drawDesktop
	jmp userspace
ldsr:
    .ld0   db "----CNOS----",10,13,"video driver loaded.",10,13,"starting mouse driver...",10,13,0
    .ld1   db "done.",10,13,"starting graphical interface...",10,13,0
userspace:
	mov ax, 1			; setup
.loop:
	call freeMove
	call processClick
.noclick:
	call leftCheckMouse
	jc .noclick
	jmp .loop

os_off:
	mov ah,53h	      ;this is an APM command
	xor bx, bx
	mov al, 0
	int 15h
	mov bl, al
	jc .err
	mov al, 4
	mov ah,53h	      ;this is an APM command
	xor bx, bx
	int 15h
	jc .de
	jmp .st2
.de:
	cmp ah,03h		 ;if the error code is anything but 03h there was an error.

	jne .err
.st2:
	mov al, 1
	mov ah,53h	      ;this is an APM command
	xor bx, bx
	int 15h
	jc .err

	mov ax,5308h		  ;Change the state of power management...
	mov bx,0FFFFh		   ;...on all devices to...
	mov cx,1	       ;...power management on.
	int 15h 		;call the BIOS function through interrupt 15h

	jc .err

	mov cx, 3
	mov ax,5307h		;this is an APM command
	mov bx, 01h
	int 15h

	jc .err
	ret
.err:
	call fatalError
	ret

Fault:
	cli
	push ds
	mov ax, 0x2000
	mov ds, ax

	mov al, 0
	call fillScreen
	mov si, .msg
	call print
	pop ds
	mov sp, 0FFFFh
	push restorepoint
	sti
	call waitkey
	ret

.msg db "ERROR: you have experienced a fault. press any key to go to your desktop. your work has been lost.",0

loadinterrupts:
	cli
	push es
	mov ax, 0			; set up interrupts
	mov es, ax
	mov word [es:0x0020], Fault
	mov word [es:0x0022], 0x2000
	pop es
	sti
	ret


gdtinfo:
   dw gdt_end - gdt - 1   ;last byte in table
   dd gdt		  ;start of table
 
gdt	    dd 0,0	  ; entry 0 is always unused
flatcode    db 0xff, 0xff, 0, 0, 0, 10011010b, 10001111b, 0
flatdata    db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
gdt_end:

;%include "video/line.asm"
%include "video/graphics.asm"
%include "video/images.asm"
%include "disk/disk.asm"
%include "misc.asm"
%include "input/mouse.asm"
%include "input/keyboard.asm"
%include "gui/desktop.asm"
%include "gui/window.asm"
%include "data/string.asm"
%include "data/list.asm"
endloc: