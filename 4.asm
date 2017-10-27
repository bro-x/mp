section .data
	nline 	db	10,10
	nline_len: equ	 $-nline

	msg db 10,10,"Multiplication"
		   db 10,"-------------------------"
	msg_len: equ $-msg

	menu db 10,10,"---------Menu--------"
			 db 10,"1.Successive Addition Method"
			 db 10,"2.Shift and Add Method"
			 db 10,"3.Exit"
			 db 10,"------------------------"
			 db 10,"Enter your Choice:-"	
	menu_len: equ $-menu

	n1msg db 10,10,"Enter 4 digit Hex Number 1:-"
	n1msg_len: equ $-n1msg
	
	n2msg db 10,10,"Enter 4 digit Hex Number 2:-"
	n2msg_len: equ $-n2msg	

	samsg db 10,10,"Result by Successive Adddition is :-"
	samsg_len: equ $-samsg
	
	shamsg db 10,10,"Result by Shift and Add Method is:-"
	shamsg_len: equ $-shamsg
	
	emsg db 10,10,"Invalid Number...!!"
	emsg_len: equ $emsg
	
section .bss
	buf resb 5
	buf_len: equ $-buf

	no1 resw 1
	no2 resw 1

	ans1 resw 1
	ansh resw 1
	
	ans resd 1
	
	char_ans resb  4
	
	%macro print 2
		mov rax,1
		mov rdi,1
		mov rsi,%1
		mov rdx,%2
		syscall
	%endmacro
	
	%macro read 2
		mov rax,0
		mov rdi,0
		mov rsi,%1
		mov rdx,%2
		syscall
	%endmacro

	%macro exit 0
		print nline,nline_len
		mov rax,60
		xor rdi,rdi	
		syscall
	%endmacro
	
section .text
	global _start
_start:
		print msg,msg_len
		print n1msg,n1msg_len
		call accept_16	
		mov [no1],bx
	
		print n2msg,n2msg_len
		call accept_16
		mov[no2],bx

Disp_Menu:
		print menu,menu_len
		read buf,2
		mov al,[buf]
		
c1:	 
	cmp al,'1'
	jne c2
	call SA
	jmp Disp_Menu
	
c2:
	cmp al,'2'
	jne c3
	call SHA
	jmp Disp_Menu
	
c3:
	cmp al,'3'
	jne err
	exit
	
err:
	print emsg,emsg_len
	jmp Disp_Menu	

SA:	
	mov rbx,[no1]
	mov rcx,[no2]
	xor rax,rax
	xor rdx,rdx
	
back:	
	add rax,rbx
	jnc next
	inc rdx
	
next:
	dec rcx
	jnz back
	
	mov [ans1],rax
	mov [ansh],rdx
	
	print samsg,samsg_len
	mov ax,[ansh]
	call display_16
	
	mov ax,[ans1]
	call display_16
	
	ret

SHA:	
	mov rcx,16
	
	mov ax,[no1]
	mov bx,[no2]

back1:
	shl dword[ans],1
	shl ax,1	
	jnc next1
	add [ans],bx
	
next1:	
	dec rcx
	jnz back1
		
	print shamsg,shamsg_len
	mov ax,[ans+2	]
	call display_16
	
	mov ax,[ans+0]
	call display_16
	ret

accept_16:
	read buf,buf_len
		
	xor bx,bx
	mov rcx,4
	mov rsi,buf
	
next_digit:	
	shl bx,04
	mov al,[rsi]
	cmp al,"0"
	jb error
	cmp al,"9"
	jbe sub_30
	
	cmp al,"A"	
	jb error	
	cmp al,"F"	
	jbe sub_37
	
	cmp al,"a"	
	jb error	
	cmp al,"f"
	jbe sub_57
	
error:
	print emsg,emsg_len
	exit
	
sub_57:	
	sub al,20h
	
sub_37:
	sub al,07h
	
sub_30:
	sub al,30h
	add bx,ax
	inc rsi
	loop next_digit
	ret

display_16:
	mov rsi,char_ans+3
	mov rcx,4

cnt:
	mov rdx,0
	mov rbx,16
	div rbx
	cmp dl,09h
	jbe add_30
	add dl,07h
	
add_30:
	add dl,30h
	mov [rsi],dl
	dec rsi
	dec rcx
	jnz cnt
	
	print char_ans,4
ret
;deval@deval-Lenovo-ideapad-300-15ISK:~$ cd programs
;deval@deval-Lenovo-ideapad-300-15ISK:~$/programs$ nasm -f elf64 4.mul.asm
;deval@deval-Lenovo-ideapad-300-15ISK:~$/programs$ ld -o 4.mul 4.mul.o
;deval@deval-Lenovo-ideapad-300-15ISK:~$/programs$ ./4.mul


;Multiplication
;-------------------------

;Enter 4 digit Hex Number 1:-0002


;Enter 4 digit Hex Number 2:-000A


;---------Menu--------
;1.Successive Addition Method
;2.Shift and Add Method
;3.Exit
;------------------------
;Enter your Choice:-1


;Result by Successive Adddition is :-00000014

;---------Menu--------
;1.Successive Addition Method
;2.Shift and Add Method
;3.Exit
;------------------------
;Enter your Choice:-2
;

;Result by Shift and Add Method is:-00000014

;---------Menu--------
;1.Successive Addition Method
;2.Shift and Add Method
;3.Exit
;------------------------
;Enter your Choice:-3


;deval@deval-Lenovo-ideapad-300-15ISK:~$/programs$

		
		
		
