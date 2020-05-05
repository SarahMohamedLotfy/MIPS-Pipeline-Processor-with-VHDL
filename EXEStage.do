vsim -gui work.exestage
add wave -position insertpoint sim:/exestage/*
force -freeze sim:/exestage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/exestage/rst 0 0
force -freeze sim:/exestage/INT 0 0
force -freeze sim:/exestage/ID_EX 000000110000001101000000000000000000000000000001111000000000000000000010001000000000000000000000000000000000000000011110000111100000000000011110000 0
force -freeze sim:/exestage/EXALUResult 32'h0 0
force -freeze sim:/exestage/MEMALUResult 32'h0 0
force -freeze sim:/exestage/INPORTValue 32'h5 0
force -freeze sim:/exestage/MEM_WBRegisterRd 011 0
force -freeze sim:/exestage/EX_MEMRegisterRd 111 0
force -freeze sim:/exestage/EX_MEMRegWrite 1 0
force -freeze sim:/exestage/MEM_WBRegWrite 1 0
force -freeze sim:/exestage/EX_MEMSWAP 0 0
force -freeze sim:/exestage/MEM_WBSWAP 0 0
noforce sim:/exestage/RegDst
run
force -freeze sim:/exestage/EX_MEMRegisterRd 001 0
force -freeze sim:/exestage/ID_EX 000000110000010001000000000000000000000000000001111000000000000000000011001000000000000000000000000000000000000000011110000111100000000000011110000 0
run
force -freeze sim:/exestage/MEM_WBRegisterRd 001 0
force -freeze sim:/exestage/ID_EX 000000111000000101000000000000000000000000000001111000000000000000000101001000000000000000000000000000000000000000011110000111100000000000011110000 0
run
force -freeze sim:/exestage/INPORTValue 00000000000000000000000000000000 0
run