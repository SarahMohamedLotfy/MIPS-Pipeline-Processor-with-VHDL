vsim -gui work.system
add wave -position insertpoint sim:/system/*
add wave -position insertpoint  \
sim:/system/Decode/RegisterFile/registers
force -freeze sim:/system/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/system/INT 0 0
force -freeze sim:/system/rst 0 0
mem load -i instructionMemory.mem  /fetch/instruction_memory/ram
force -freeze sim:/system/rst 1 0
run
force -freeze sim:/system/rst 0 0
run
force -freeze sim:/system/INPORT 32'h4 0
run
force -freeze sim:/system/INPORT 32'h3 0
run 

run
run
run
run
run
run
run
run
run
run
run
run