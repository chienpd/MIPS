.data
MessageInput:	.asciiz	"Input:\n"
Message1:	.asciiz	"\tstring1: "
Message2:	.asciiz	"\tstring2: "
Message3:	.asciiz	"\tkhong phan biet hoa thuong\nOutput:\n	"
Message4:	.asciiz	"\tco phan biet hoa thuong\nOutput:\n	"
Message5:	.asciiz	"Co phan biet chu hoa - thuong hay khong ?" 
Message6:	.asciiz	"Not found !"
String:		.space	1000
subString:	.space 	1000
.text
	li 	$v0, 4			#
	la	$a0, MessageInput	#
	syscall				# print Input:
#-------------------------------------------------------------------------
InputString:
	li 	$v0, 4		#
	la	$a0, Message1	#
	syscall			# print String1:
	
	li	$v0, 8		#
	la	$a0, String	#
	li	$a1, 100		#
	syscall			# input to String:
	
	
	lb	$t3, 0($a0)		# t3 = String[0]
	addi	$at, $0, 10
	beq	$t3, $at, InputString	# if String[0] = \n -> Loop
	nop
	
	
	add	$s0, $a0, $0		# String = s0
#---------------------------------------------------------------------------
InputsubString:
	li 	$v0, 4		#
	la	$a0, Message2	#
	syscall			# print String2:
	
	li	$v0, 8		#
	la	$a0, subString	#
	li	$a1, 10		#
	syscall			# input to subString
	
	lb	$t4, 0($a0)		# t4 = subString[0]
	addi	$at, $0, 10
	beq	$t4, $at, InputsubString	# if subString[0] = \n -> Loop
	nop
	add	$s1, $a0, $0		# subString = s1
#---------------------------------------------------------------------------
WhileUpCase:
	li	$v0, 50
	la	$a0, Message5
	syscall
	addi	$at, $0, 0
	beq	$a0, $at, Yes		# co phan biet hoa - thuong
	nop
	addi	$at, $0, 1
	beq	$a0, $at, No		# khong phan biet hoa thuong
	nop
	addi	$at, $0, 2
	beq	$a0, $at, WhileUpCase	# chon lai
	nop
EndWhileUpCase:
#---------------------------------------------------------------------------
Yes:
	li 	$v0, 4			#
	la	$a0, Message4		#
	syscall				# print co phan biet hoa thuong
	j	main
#---------------------------------------------------------------------------
No:
	li 	$v0, 4			#
	la	$a0, Message3		#
	syscall				# print khong phan biet hoa thuong
	addi	$t9, $a0, 1		# flag upCase ?
#--------------------------------------------------------------------------
main:
	addi	$s2, $0, 0	# i = 0
	add	$s3, $0, 0	# j = 0
While:
	add	$t1, $s2, $s0		# addr of String[i] in t1
	lb	$t3, 0($t1)		# t3 = String[i]
	lb	$t4, 0($s1)		# t4 = subString[0]
	beq	$t3, $0, EndWhile	# if String[i] = \0 -> exit while
	nop
	addi	$at, $0, 10
	beq	$t3, $at, EndWhile	# if String[i] = \n -> exit While
	nop
	If:
		
		beq	$t9, $0, notUpCase1
		nop
			jal	UpCase
			nop
		notUpCase1:
		jal	N_L
		nop
		bne	$t3, $t4, Add	# if String[i] != subString[0] -> exit If
		nop
		add	$s3, $0, 1	# j = 1
		While2:
			add	$t5, $s3, $t1	# t5 = addr[i + j]
			lb	$t3, 0($t5)	# t6 = String[i+j}
			add	$t7, $s3, $s1	# t7 = addr of subString[j]
			lb	$t4, 0($t7)	# t4 = suString[j]
			
			beq	$t9, $0, notUpCase2
			nop
				jal	UpCase
				nop
			notUpCase2:
			beq	$t4, $0, EndWhile2	# if subString[j] == \0 -> exit while2
			nop
			addi	$at, $0, 10
			beq	$t4, $at, EndWhile2	# if subString[j] == \n -> exit while2
			nop
			jal	N_L
			nop
			bne	$t4, $t3, EndWhile2	# if subString[j] != String[i+j] -> exit while2
			nop
			addi	$s3, $s3, 1		# j = j + 1
			j	While2			# Loop2
		EndWhile2:	
		PrintPos:
			If2:
				addi	$at, $0, 10
				bne	$t4, $at, EndIf2	# if subString[j] != \n -> exit If2
				nop
				add	$a0, $s2, $0	# a0 = s2 = i
				li	$v0, 1		#
				syscall			# print pos
				
				addi	$a0, $0, 32	# print space
				li	$v0, 11		#
				syscall			#
				
				addi	$t0, $0, 1	# k = 1	-> co subString hay k ?
			EndIf2:
				bne	$t4, $0, EndPrintPos	# if subString[j] != \0 -> exit PrintPos
				nop
				add	$a0, $s2, $0	# a0 = s2 = i
				li	$v0, 1		#
				syscall			# print pos
				
				addi	$a0, $0, 32	# print space
				li	$v0, 11		#
				syscall			#
				
				addi	$t0, $0, 1	# k = 1	-> co subString hay k ?
		EndPrintPos:
	EndIf:	
	Add:	addi	$s2, $s2, 1			# i = i + 1
		j	While				# Loop
#----------------------------------------------------------------------------------------------
UpCase:
	IFUpCase1:
		sub	$t8, $t3, 97			# if String[i] >= 97 && String[i] <= 122
		bltz	$t8, EndIfUpCase1
		nop		# 
		sub	$t8, $t3, 122			#
		bgtz	$t8, EndIfUpCase1
		nop		#
		sub	$t3, $t3, 32			# String[i] = String[i] - 32
	EndIfUpCase1:
	
	IfUpCase2:
		sub	$t8, $t4, 97			# if subString[j] >= 97 && String[j] <= 122
		bltz	$t8, EndIfUpCase2
		nop		#
		sub	$t8, $t4, 122			#
		bgtz	$t8, EndIfUpCase2
		nop		#
		sub	$t4, $t4, 32			# subString[j] = String[j] - 32
	EndIfUpCase2:
	jr	$ra
#--------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
N_L:
	IfN:
		addi	$t8, $0, 'n'
		bne	$t3, $t8, EndIfN
		addi	$t8, $0, 'l'
		add	$t3, $0, $t8
	EndIfN:
	IfL:
		addi	$t8, $0, 'n'
		bne	$t4, $t8, EndIfL
		addi	$t8, $0, 'l'
		add	$t4, $0, $t8
	EndIfL:
	jr	$ra
EndN_L:
#------------------------------------------------------------------------------------
EndWhile:	
	addi	$at, $0, 1
	beq	$t0, $at, Exit	    	# if t7 == 1 -> Exit
	nop
	li	$v0, 4              	# else print Not found !
	la	$a0, Message6       	#
	syscall  			#
Exit:	
	
