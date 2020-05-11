# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10

#NOP            #No change
#IN R3	       #R1= 5,add 5 on the in port,flags no change
#NOT R1         #R1 =FFFFFFFF , C--> no change, N --> 1, Z --> 0
#INC R2	       #R1 =00000000 , C --> 1 , N --> 0 , Z --> 1
#in R4          #R2= 10,add 10 on the in port, flags no change
#NoT R5	       #R2= FFFFFFEF, C--> no change, N -->1,Z-->0
#INC R6         #R1= 6, C --> 0, N -->0, Z-->0
#Dec R1         #R2= FFEE,C-->1 , N-->1, Z-->0
#OUT R2
#OUT R3
#NOP
#NOP
#NOP
#NOP
#NOP
#NOP
ADD R1,R2,R3
#iadd R2,R5,00ff
#LDD R5,F0F0F

