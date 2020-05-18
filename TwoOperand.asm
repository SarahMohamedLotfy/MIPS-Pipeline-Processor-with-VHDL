# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
in   R1       #add 5 in R1
in   R2       #add 19 in R2
IADD R2,R1,2  #R5 = FFFF , flags no change
Add R1,R5,R6
nop
nop



