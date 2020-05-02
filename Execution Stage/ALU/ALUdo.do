vsim -gui work.alu2
add wave -position insertpoint sim:/alu2/*
force -freeze sim:/alu2/S 0000 0
force -freeze sim:/alu2/EN 1 0
run
force -freeze sim:/alu2/S 0001 0
force -freeze sim:/alu2/A 16'h20 0
run
force -freeze sim:/alu2/B 16'h30 0
force -freeze sim:/alu2/S 0010 0
run
force -freeze sim:/alu2/S 0011 0
run
force -freeze sim:/alu2/S 0100 0
run
force -freeze sim:/alu2/S 0101 0
run
force -freeze sim:/alu2/S 0110 0
run
force -freeze sim:/alu2/S 0111 0
run
force -freeze sim:/alu2/S 1000 0
run
force -freeze sim:/alu2/S 1001 0
run
force -freeze sim:/alu2/S 1010 0
force -freeze sim:/alu2/B 16'h5 0
run
force -freeze sim:/alu2/A 16'hf0f0 0
run
force -freeze sim:/alu2/A 0000100000000000 0
run
force -freeze sim:/alu2/S 1011 0
run
force -freeze sim:/alu2/A 16'hf0f0 0
run
