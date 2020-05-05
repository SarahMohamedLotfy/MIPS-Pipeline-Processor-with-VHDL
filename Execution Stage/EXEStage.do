vsim -gui work.exestage
add wave -position insertpoint sim:/exestage/*
force -freeze sim:/exestage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/exestage/rst 0 0
force -freeze sim:/exestage/INT 0 0
force -freeze sim:/exestage/ID_EX 000000110000001101000000000000000000000000000001111000000000000000000010000001000000000000000000000000000000000000011110000111100000000000011110000 0
force -freeze sim:/exestage/EXALUResult 32'h0 0
force -freeze sim:/exestage/MEMALUResult 32'h0 0
force -freeze sim:/exestage/INPORTValue 32'h5 0
noforce sim:/exestage/RegDst
run