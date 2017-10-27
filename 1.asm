;Batch:-A2 Roll No:-34
section .data
	pmsg db 10, "The count of positive numbers"
	pmsg_len equ $-pmsg
	nmsg db 10, "The count of negative numbers"
	nmsg_len equ $-nmsg
	array dw 000ah,000bh,000ch,9f00h,9491h,8007h,1002h
	arrcnt equ 7
	pcnt db 0
	ncnt db 0

section .bss
	dispbuff resb 2

%macro print 2
	mov eax,4
	mov ebx,1
	mov rcx,%1
	mov edx,%2
	int 0x80
%endmacro

section .text
	global _start
	_start:
	mov esi,array
	mov ecx,arrcnt

up1:
	bt word[esi],15
	jnc pnxt
	inc byte[ncnt]
	jmp pskip

pnxt:
	inc byte[pcnt]

pskip:
	inc esi
	inc esi
	loop up1

	print pmsg,pmsg_len
	mov bl,[pcnt]
	call disp8num
	print nmsg,nmsg_len
	mov bl,[ncnt]
	call disp8num

exit:
	mov eax,1
	mov ebx,0
	int 0x80

disp8num:
	mov edi,dispbuff
	mov ecx,2
	dispup1:
	rol bl,4
	mov dl,bl
	and dl,0fh
	add dl,30h
	cmp dl,39h
	jbe dispskip1
	add dl,07h

	dispskip1:
	mov[edi],dl
	inc edi
	loop dispup1
	print dispbuff,2
	ret

;OUTPUT:-
;dell@dell-dell-ideapad-300-15ISK:~$ cd programs
;dell@dell-dell-ideapad-300-15ISK:~/programs$ nasm -f elf64 1.pos.asm
;dell@dell-dell-ideapad-300-15ISK:~/programs$ ld -o 1.pos 1.pos.o
;dell@dell-dell-ideapad-300-15ISK:~/programs$ ./1.pos

;The count of positive numbers04
;The count of negative numbers03
;dell@dell-dell-ideapad-300-15ISK:~/programs$ 



















;Batch:-A2 Roll No:-38
section .data
	pmsg db 10, "The count of positive numbers"
	pmsg_len equ $-pmsg
	nmsg db 10, "The count of negative numbers"
	nmsg_len equ $-nmsg
	array dw 000ah,000bh,000ch,9f00h,9491h,8007h,1002h
	arrcnt equ 7
	pcnt db 0
	ncnt db 0

section .bss
	dispbuff resb 2

%macro print 2
	mov eax,4
	mov ebx,1
	mov rcx,%1
	mov edx,%2
	int 0x80
%endmacro

section .text
	global _start
	_start:
	mov esi,array
	mov ecx,arrcnt

up1:
	bt word[esi],15
	jnc pnxt
	inc byte[ncnt]
	jmp pskip

pnxt:
	inc byte[pcnt]

pskip:
	inc esi
	inc esi
	loop up1

	print pmsg,pmsg_len
	mov bl,[pcnt]
	call disp8num
	print nmsg,nmsg_len
	mov bl,[ncnt]
	call disp8num

exit:
	mov eax,1
	mov ebx,0
	int 0x80

disp8num:
	mov edi,dispbuff
	mov ecx,2
	dispup1:
	rol bl,4
	mov dl,bl
	and dl,0fh
	add dl,30h
	cmp dl,39h
	jbe dispskip1
	add dl,07h

	dispskip1:
	mov[edi],dl
	inc edi
	loop dispup1
	print dispbuff,2
	ret

;OUTPUT:-
;dell@dell-dell-ideapad-300-15ISK:~$ cd programs
;dell@dell-dell-ideapad-300-15ISK:~/programs$ nasm -f elf64 1.pos.asm
;dell@dell-dell-ideapad-300-15ISK:~/programs$ ld -o 1.pos 1.pos.o
;dell@dell-dell-ideapad-300-15ISK:~/programs$ ./1.pos

;The count of positive numbers04
;The count of negative numbers03
;dell@dell-dell-ideapad-300-15ISK:~/programs$ 
