SECTION .bss
	BUFFLEN equ 16
	Buff: resb BUFFLEN

SECTION .data
	HexStr: db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00",10
	HSLen equ $-HexStr
	
	Digits: db "0123456789abcdef"

SECTION .text

global _start

_start:
	nop	;suppose it's needed
Read:	mov eax,3	; Reading
	mov ebx,0
	mov ecx,Buff
	mov edx,BUFFLEN
	int 80H
	
	cmp eax,0	; Check rc
	je Exit
	
	mov ebp,Buff
	mov esi,eax	; Store in esi count of bytes from Input
	mov ecx,esi	; Count is now in ecx
	mov edi,0	;Offset from the beginning
Proc:			;Processing
	xor eax,eax
	xor ebx,ebx
	mov edx,0		;store position in 3-byte segment
	;mov [bp+ecx+edx],20H	;first byte should be always 20h(Space)
	;inc edx		;inrement position in 3-byte segment
	
	mov al,byte [ebp+edi]	;Take byte from buffer
	mov ebx,eax		;Copy that byte to ebx
	
	and eax,0Fh			;clear all but first 4 bits
	mov al,byte [Digits+eax]	;Get a real hex digit
	
	shr ebx,4			;Shift right, to get second 4 bits
	mov bl,byte [Digits+ebx]	;Get a real hex digit
	
	inc edx				;inrement position in 3-byte segment
	mov byte [HexStr+edx],bl	;Write first hex half
	inc edx				;inrement position in 3-byte segment
	mov byte [HexStr+edx],al	;Write second hex half
	
	cmp edx,HSLen			;Compare offset to HexStr length
	jne Next
	je Write
Next:	mov ecx,esi
	inc ecx
	inc ecx
	cmp edx,esi
	jne Proc

Write:			;Writing to output
	mov eax,4
	mov ebx,1
	mov ecx,HexStr
	mov edx,HSLen
	int 80h
	
Exit:	mov eax,1
	mov ebx,0
	int 80H
