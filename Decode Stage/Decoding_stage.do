vsim work.alldecoder
add wave -position insertpoint sim:/alldecoder/*
force -freeze sim:/alldecoder/interrupt 0 0
force -freeze sim:/alldecoder/reset 1 0
force -freeze sim:/alldecoder/clk 1 0, 0 {50 ps} -r 100
run 100
force -freeze sim:/alldecoder/reset 0 0
force -freeze sim:/alldecoder/IF_ID 00101001100111 0
run 100
force -freeze sim:/alldecoder/RegWriteinput 1 0
force -freeze sim:/alldecoder/Mem_Wb_Rd 001 0
force -freeze sim:/alldecoder/value1 00000000111111110000000011111111 0
run 100
force -freeze sim:/alldecoder/RegWriteinput 0 0
force -freeze sim:/alldecoder/Swapinput  0 0
run 100

