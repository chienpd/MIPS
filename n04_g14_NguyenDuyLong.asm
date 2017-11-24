.eqv HEADING 0xffff8010 
# Integer: An angle between 0 and 359 
# 0 : North (up) 
# 90: East (right) 
# 180: South (down) 
# 270: West (left) 
.eqv MOVING 0xffff8050 		# Boolean: whether or not to move 
.eqv LEAVETRACK 0xffff8020 	# Boolean (0 or non-0): 
# whether or not to leave a track 
.eqv WHEREX 0xffff8030 		# Integer: Current x-location of MarsBot 
.eqv WHEREY 0xffff8040 		# Integer: Current y-location of MarsBot 
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012

.data
script1: .word 90,2000,0,180,3000,0,180,5790,1,80,500,1,70,500,1,60,500,1,50,500,1,40,500,1,30,500,1,20,500,1,10,500,1,0,500,1,350,500,1,340,500,1,330,500,1,320,500,1,310,500,1,300,500,1,290,500,1,280,490,1,90,8000,0,270,500,1,260,500,1,250,500,1,240,500,1,230,500,1,220,500,1,210,500,1,200,500,1,190,500,1,180,500,1,170,500,1,160,500,1,150,500,1,140,500,1,130,500,1,120,500,1,110,500,1,100,500,1,90,500,1,90,5000,0,270,2000,1,0,2900,1,90,2000,1,270,2000,1,0,2900,1,90,2000,1,90,1000,0
script2: .word 90,5000,0,180,3000,0,270,500,1,260,500,1,250,500,1,240,500,1,230,500,1,220,500,1,210,500,1,200,500,1,190,500,1,180,500,1,170,500,1,160,500,1,150,500,1,140,500,1,130,500,1,120,500,1,110,500,1,100,500,1,90,500,1,90,2000,0,0,5800,1,180,2900,1,90,2000,1,0,2900,1,180,5800,1,90,2000,0,0,5800,1,90,2000,0,90,2000,1,270,2000,1,180,2900,1,90,2000,1,270,2000,1,180,2900,1,90,2000,1,90,2000,0,0,5800,1,150,6697,1,0,5800,1,90,2000,0
script3: .word 90,5000,0,180,3000,0,270,500,1,260,500,1,250,500,1,240,500,1,230,500,1,220,500,1,210,500,1,200,500,1,190,500,1,180,500,1,170,500,1,160,500,1,150,500,1,140,500,1,130,500,1,120,500,1,110,500,1,100,500,1,90,500,1,80,500,1,70,500,1,60,500,1,50,500,1,40,500,1,30,500,1,20,500,1,10,500,1,0,500,1,350,500,1,340,500,1,330,500,1,320,500,1,310,500,1,300,500,1,290,500,1,280,500,1,90,1000,0
end_script : .word
.text
li $t3, IN_ADRESS_HEXA_KEYBOARD
li $t4, OUT_ADRESS_HEXA_KEYBOARD

polling: 
	li $t5, 0x01  		#check row 0,1,2,3 ->  check =0
	sb $t5, 0($t3) 		#IN_ADRESS_HEXA_KEYBOARD
	lb $a0, 0($t4) 		#OUT_ADRESS_HEXA_KEYBOARD
	bne $a0, 0x11, SCAN_4  	# so sanh gia tri nhan duoc vs 0x11(a0 !=0 -> SCAN_4)
	# else (a0 == 0) load addres script1 ,script2
	la $a1, script1 	#load script1 a1  = adress(script1[0])
	la $a2 ,script2	 	#load script2 a2  = adress(script2[0])
	j START          	#jumb START 
	SCAN_4:			#check gia tri nhap vao bang 4 hay khong 
	li $t5, 0x02    	#check row 4,5,6,7 -> check =4
	sb $t5, 0($t3)  	#in_adress_hexa_keyboard
	lb $a0, 0($t4)  	#out_adress_hexa_keyboard
	bne $a0, 0x12, SCAN_8  #so sanh gia tri nhan duoc vs 0x12(a0!=4 -> SCAN_8)
	#else (a0==4) load adress script2, script3
	la $a1, script2  #load script2 a1  = adress(script2[0])
	la $a2, script3	 #load script3 a2  = adress(script3[0])
	j START          #jumb START
	SCAN_8:         #check gia tri nhap vao bang 8 hay khong
	li $t5, 0X04    #check row 8,9,a,b
	sb $t5, 0($t3)  #in_adress_hexa_keyboard
	lb $a0, 0($t4)  #out_adress_hexa_keyboard
	bne $a0, 0x14, back_to_polling #so sanh gia tri nhan duoc vs 0x14(a0!=8 -> back_to_polling)
	la $a1, script3 	#load script3 a1 = adress(script3[0])
	la $a2, end_script 	#load end_script a2 = adress(end_script)
	j START         #jumb START 
back_to_polling: j polling      #jumb polling


START:  #a2 = a2-4 -> a2 = adress(cript[last]) -> VD : a1 = address(script[0]) , a2 = adress(script[n-1])
	addi $a2,$a2,-4
	jal GO   #moving bot
READ_SCRIPT: 
	slt $t1 , $a2 , $a1   #check a2 <a1 ?
	bne $t1, $zero , END  # if (a2<a1) ket thuc END
	lw $a0 ,  8($a1)      #else a0 = 8($a1) -> a0 = gia tri track cua bo script ->set marbot track/untrack
	jal TRACK	 
	lw $a0, 0($a1)	      #a0 = 0($a1) -> a0 = gia tri goc cua bo script -> set marbot rotate
	jal ROTATE	  
	lw $a0,4($a1)	      #a0 = 4($a1) -> a0 = gia tri thoi gian cua bo scrpit ->set sleep time
	jal SLEEP      
	jal UNTRACK           # untrack postscript truoc
	addi $a1,$a1,12       #dich thanh ghi a1 qua bo 3 so da doc
	j READ_SCRIPT         # quay lai vong lap
END:
	jal STOP              
	li $v0, 10
	syscall
	j polling
#-----------------------------------------------------------
   GO:
   	li $at, MOVING # change MOVING port 
  	addi $k0, $zero,1 # to logic 1, 
   	sb $k0, 0($at) # to start running 
   	jr $ra 
#-----------------------------------------------------------
   STOP: 
  	li $at, MOVING # change MOVING port to 0 
   	sb $zero, 0($at) # to stop 
   	jr $ra
#------------------------------------------------------------
   TRACK: 
  	li $at, LEAVETRACK # change LEAVETRACK port 
  	sw $a0, 0($at) # to start tracking 
  	jr $ra
#-----------------------------------------------------------
  ROTATE: 
  	li $at, HEADING # change HEADING port 
  	sw $a0, 0($at) # to rotate robot 
 	jr $ra
#------------------------------------------------------------
  SLEEP:
  	addi $v0,$zero,32
  	syscall 
  	jr $ra
#-----------------------------------------------------------
  UNTRACK:
  	li $at, LEAVETRACK # change LEAVETRACK port to 0
  	sb $zero, 0($at) # to stop drawing tail 
 	jr $ra 
