.global sha1_chunk

# h[0] is 1st argument (%rdi)
# w[0] is 2nd argument (%rsi)
sha1_chunk:
	pushq %rbp 
	push %r12
	push %r14
	push %r15
	push %rbx
	movq %rsp, %rbp
	movq $16, %rdx

	loop1:
		cmpq $80, %rdx		
		je loopstop1

		movq %rdx, %rbx
		sub $3, %rbx
		mov (%rsi, %rbx, 4), %eax


		movq %rdx, %rbx
		sub $8, %rbx
		mov (%rsi, %rbx, 4), %ecx
		xor %eax, %ecx

		movq %rdx, %rbx
		sub $14, %rbx
		mov (%rsi, %rbx, 4), %eax
		xor %eax, %ecx

		movq %rdx, %rbx
		sub $16, %rbx
		mov (%rsi, %rbx, 4), %eax
		xor %eax, %ecx
	
		roll $1, %ecx

		mov %ecx, (%rsi, %rdx, 4)

		incq %rdx
		jmp loop1
	loopstop1:
		mov (%rdi), %r11d #a is in r11
		mov 4(%rdi), %r12d #b is in r12
		mov 8(%rdi), %r13d #c is in r13
		mov 12(%rdi), %r14d #d is in r14
		mov 16(%rdi), %r15d #e is in r15
		mov $0, %rdx 
		mainloop:
			cmpq $80, %rdx
			je mainloopstop

			r1:
			cmpq $19, %rdx
			jg r2
			movl %r13d, %eax
			and %r12d, %eax
			movl %r12d, %ecx
			not %ecx
			and %r14d, %ecx
			or %eax, %ecx
			mov %ecx, %r9d #r9 is f
			movl $0x5A827999,%r8d #r8 is k
			jmp endif

			r2:
			cmpq $39, %rdx
			jg r3
			movl %r13d, %r9d
			xor %r12d, %r9d
			xor %r14d, %r9d
			movl $0x6ED9EBA1,%r8d
			jmp endif

			r3:
			cmpq $59, %rdx
			jg r4
			movl %r13d, %eax
			and %r12d, %eax
			movl %r14d, %ecx
			and %r12d, %ecx
			movl %r14d, %r9d
			and %r13d, %r9d
			or %eax, %ecx
			or %ecx, %r9d
			movl $0x8F1BBCDC,%r8d
			jmp endif

			r4:
			movl %r13d, %r9d
			xor %r12d, %r9d
			xor %r14d, %r9d
			movl $0xCA62C1D6, %r8d
			jmp endif
	
		endif:
			movl %r11d, %eax #not sure about ebx
			roll $5, %eax
			add %r9d, %eax
			add %r15d, %eax
			add %r8d, %eax
			add (%rsi, %rdx, 4), %eax


			movl %r14d, %r15d
			movl %r13d, %r14d
			roll $30, %r12d
			movl %r12d, %r13d
			movl %r11d, %r12d
			movl %eax, %r11d

			incq %rdx
			jmp mainloop

		mainloopstop:



		addl %r11d, (%rdi)
		addl %r12d, 4(%rdi)	
		addl %r13d, 8(%rdi)
		addl %r14d, 12(%rdi)
		addl %r15d, 16(%rdi)

		#end of stack frame
		movq %rbp, %rsp
		pop %rbx
		pop %r15
		pop %r14
		pop %r12
		popq %rbp 	
		ret 		
				
