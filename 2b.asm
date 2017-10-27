section .data
	menumsg db 10,10,'##### Menu for Overlapped Block Transfer #####',10
		db 10,'1.Block Transfer without using string instructions'
		db 10,'2.Block Transfer with using string instructions'
		db 10,'3.Exit',10
	menumsg_len equ $-menumsg

	wrchmsg db 10,10,'Wrong Choice Entered....Please try again!!!',10,10
	wrchmsg_len equ $-wrchmsg

	blk_bfrmsg db 10,'Block contents before transfer'
	blk_bfrmsg_len equ $-blk_bfrmsg

	blk_afrmsg db 10,'Block contents after transfer'
	blk_afrmsg_len equ $-blk_afrmsg

	srcmsg db 10,'Source block contents::'
	srcmsg_len equ $-srcmsg

	dstmsg db 10,'Destination block contents::'
	dstmsg_len equ $-dstmsg

	
	srcblk db 01h,02h,03h,04h,05h

	dstblk times 3 db 0

	cnt equ 05

	spacechar db 20h

	

section .bss

	optionbuff resb 02
	dispbuff resb 02


%macro write 2
	mov eax,04
	mov ebx,01
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

%macro read 2
	mov eax,03
	mov ebx,0
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro


%macro exit 0
mov eax,01	
mov ebx,0
int 80h
%endmacro

section .text
	global _start
_start:
	write blk_bfrmsg,blk_bfrmsg_len

	call showblks

menu:	write menumsg,menumsg_len

	read optionbuff,02

	cmp byte [optionbuff],'1'
	jne case2
	call blkxferwo_proc

	jmp exit1

case2:	cmp byte [optionbuff],'2'
	jne case3
	call blkxferw_proc
	jmp exit1

case3:	cmp byte [optionbuff],'3'
	je exit
	write wrchmsg,wrchmsg_len
	jmp menu
exit1:
	write blk_afrmsg,blk_afrmsg_len
	call showblks
exit

	


dispblk_proc:
	mov rcx,cnt
rdisp:
	push rcx
	mov bl,[esi]		;Read ASCII value char by char
	call disp8_proc		;& Display 
	inc esi			;Point to next char
	write spacechar,1	;Display space
	pop rcx
	loop rdisp		;Decrement count
				;Repeat display process till actual count becomes zero
	ret


blkxferwo_proc:
	mov esi,srcblk+4
	mov edi,dstblk+2
	mov ecx,cnt
blkup1:
	mov al,[esi]
	mov [edi],al
	dec esi
	dec edi
	loop blkup1

	ret

blkxferw_proc:
	mov esi,srcblk+4
	mov edi,dstblk+2
	mov ecx,cnt

	std
	rep movsb

	ret


showblks:
	write srcmsg,srcmsg_len

	mov esi,srcblk
	call dispblk_proc

	write dstmsg,dstmsg_len

	mov esi,dstblk-2
	call dispblk_proc
	ret


disp8_proc:
	mov ecx,02
	mov edi,dispbuff
dup1:
	rol bl,4
	mov al,bl
	and al,0fh
	cmp al,09
	jbe dskip
	add al,07h
dskip:	add al,30h
	mov [edi],al
	inc edi
	loop dup1

	write dispbuff,03
	ret

;OUTPUT:-
;deval@deval-Lenovo-ideapad-300-15ISK:~$ cd programs
;deval@deval-Lenovo-ideapad-300-15ISK:~/programs$ nasm -f elf64 2b.overlap.asm
;deval@deval-Lenovo-ideapad-300-15ISK:~/programs$ ld -o 2b.overlap 2b.overlap.o
;deval@deval-Lenovo-ideapad-300-15ISK:~/programs$ ./2b.overlap

;Block contents before transfer
;Source block contents::01 02 03 04 05 
;Destination block contents::04 05 00 00 00 

;##### Menu for Overlapped Block Transfer #####

;1.Block Transfer without using string instructions
;2.Block Transfer with using string instructions
;3.Exit
;1

;Block contents after transfer
;Source block contents::01 02 03 01 02 
;Destination block contents::01 02 03 04 05 

;##### Menu for Overlapped Block Transfer #####

;1.Block Transfer without using string instructions
;2.Block Transfer with using string instructions
;3.Exit
;2

;Block contents after transfer
;Source block contents::01 02 03 01 02 
;Destination block contents::01 02 03 04 05

;##### Menu for Overlapped Block Transfer #####

;1.Block Transfer without using string instructions
;2.Block Transfer with using string instructions
;3.Exit
;3

;deval@deval-Lenovo-ideapad-300-15ISK:~/programs$

