f = open("input.txt","r")
instructionList = []

TwoOperandInstructions2 ={
"SWAP":6,
"swap":6,
"SHL":12,
"shl":12,
"SHR":13,
"shr":13,
"LDM":16,
"ldm":16,
"LDD":17,
"ldd":17,
"STD":18,
"std":18
}

TwoOperandInstructions3 ={
	"ADD":7,
	"add":7,
	"IADD":8,
	"iadd":8,
	"SUB":9,
	"sub":9,
	"AND":10,
	"and":10,
	"OR":11,
	"or":11
}
OneOperandInstructions = {
	"NOT":1,
	"not":1,
	"INC":2,
	"inc":2,
	"DEC":3,
	"dec":3,
	"OUT":4,
	"out":4,
	"IN":5,
	"in":5,
	"PUSH":14,
	"push":14,
	"POP":15,
	"pop":15,
	"JZ":19,
	"jz":19,
	"JMP":20,
	"jmp":20,
	"CALL":21,
	"call":21
}
NoOperandInstructions ={
	"NOP":"0000000000000000",
	"nop":"0000000000000000",
	"RET":"1011000000000000",
	"ret":"1011000000000000",
	"RTI":"1011100000000000",
	"rti":"1011100000000000"	
} 

instructionsOutput = []
DataOutput = []
for instr in f:
	if instr[0] == '#' or instr[0] == '\n' or instr[0] == '\t' :
		continue
	instr = instr.replace("\t",'')
	instructionComponents =instr.split("#")
	actualInstructionComponents = instructionComponents[0]
	if len(actualInstructionComponents) is not 0:
		instructionList.append(actualInstructionComponents)
	else:
		instructionList.append(instructionComponents)
	#print(actualInstructionComponents)	


f.close()


instrComponent =[]
for instruction in instructionList:
	instruction=instruction.lstrip()
	instruction = instruction.rstrip()
	instruction=instruction.replace(',',' ')
	IRValueList = instruction.split(' ')
	while '' in IRValueList:
		IRValueList.remove('')
	instrComponent.append(IRValueList)

instrFile =open("instructionMemory.mem",'w') 
DataFile =open("DataMemory.mem",'w') 
#format line to be read in modelsim 
DataFile.writelines("// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1"+"\n")
instrFile.writelines("// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1"+"\n")
#to count org apperance count
ORGCount=-1
instrCount=0
dataCount =0

for instr in instrComponent:
	print(instr)
	if instr[0] ==".ORG":
		ORGCount=ORGCount+1
		if ORGCount in [0 ,1] :
			dataCount=int(instr[1])
		else:
			instrCount = int(instr[1])
		
		

	elif len(instr) == 4: #whether 2 operand instruction3 
		STR = "{0:05b}".format(TwoOperandInstructions3[instr[0]])
		if instr[0] == "IADD":
			EA_IMM = int(instr[3])
			EA_IMM_STR = "{0:020b}".format(EA_IMM&0xfffff)
			nextaddress = EA_IMM_STR[4:] #first 16 bits 
			#src1
			SRC1=int(instr[1][int(instr[1].find("R"))+1])			
			STR+="{0:03b}".format(SRC1&0xffff)
			SRC2=int(instr[2][int(instr[2].find("R"))+1])			
			STR+="{0:03b}".format(SRC2&0xffff)
			STR+="{0:04b}".format(0&0xffff)
			STR+="{0:01b}".format(1&0xffff)
			instructionsOutput.append(STR)
			instructionsOutput.append(nextaddress)
			print(STR)
			print(nextaddress)
		else:
			#src1
			SRC1=int(instr[1][int(instr[1].find("R"))+1])			
			STR+="{0:03b}".format(SRC1&0xffff)
			#src2 
			SRC2=int(instr[2][int(instr[2].find("R"))+1])			
			STR+="{0:03b}".format(SRC2&0xffff) 
			#Dst
			DST=int(instr[3][int(instr[3].find("R"))+1])			
			STR+="{0:03b}".format(DST&0xffff)
			STR+="{0:02b}".format(0&0xffff)
			instructionsOutput.append(STR)
			print(STR)




	elif len(instr) == 3:
		#two operand instruction2 swap,shl,shr,ldm,ldd,std
		STR = "{0:05b}".format(TwoOperandInstructions2[instr[0]])
		SRC1=int(instr[1][int(instr[1].find("R"))+1])
		#src1
		if instr[0] == "SWAP":
			STR+="{0:03b}".format(SRC1&0xffff)	
			#src2 if register
			SRC2=int(instr[2][int(instr[2].find("R"))+1])			
			STR+="{0:03b}".format(SRC2&0xffff) 
			STR+="{0:05b}".format(0&0xffff)					
			instructionsOutput.append(STR)
			print(STR)
		#shl,shr,ldm,ldd,std	
		else:
			#src1
			STR+="{0:03b}".format(0&0xffff)
			STR+="{0:03b}".format(SRC1&0xffff)
			EA_IMM = int(instr[2])
			EA_IMM_STR = "{0:020b}".format(EA_IMM&0xfffff)
			nextaddress = EA_IMM_STR[4:]
			if 	instr[0] in ["LDD","STD"]:
				#EA
				STR+=EA_IMM_STR[0:4]
			else:
				#imm
				STR+="{0:04b}".format(0&0xffff)
			
			STR+="{0:01b}".format(1&0xffff)
			print(STR)
			instructionsOutput.append(STR)
			instructionsOutput.append(nextaddress)					
			print(nextaddress)

	elif len(instr) == 2:
		
		#one operand and push ,pop ,branching
		STR = "{0:05b}".format(OneOperandInstructions[instr[0]]) 
		STR+="{0:03b}".format(0&0xffff)
		if "R" in instr[1]:
			SRC1=int(instr[1][int(instr[1].find("R"))+1])			
			STR+="{0:03b}".format(SRC1&0xffff)
		STR+="{0:05b}".format(0&0xffff)
		instructionsOutput.append(STR)	
		print(STR)
	elif len(instr) == 1:
		if instr[0] not in NoOperandInstructions:
			if ORGCount in [0,1]:
				Value="{0:016b}".format((int(instr[0]))&0xffff)
				DataFile.write(("{}: "+Value+"\n").format(dataCount))
		else:
			#no operand 
			STR= NoOperandInstructions[instr[0]]
			instructionsOutput.append(STR)
			print(STR)									

# for test in instrComponent: 
	
# 	print(test,len(test))

for line in instructionsOutput:
	instrFile.write((hex(instrCount))[2:]+": "+line+"\n")
	instrCount=instrCount+1

instrFile.close()	
DataFile.close()

