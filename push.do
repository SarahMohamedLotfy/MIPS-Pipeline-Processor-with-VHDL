vsim -gui work.system
add wave -position insertpoint sim:/system/*
add wave -position insertpoint  \
force -freeze sim:/system/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/system/INT 0 0
force -freeze sim:/system/rst 0 0
mem load -i instructionMemory1.mem  /fetch/instruction_memory/ram
mem load -i DataMemory.mem  /MemoryStage/DM/ram
force -freeze sim:/system/rst 1 0
run
force -freeze sim:/system/rst 0 0
force -freeze sim:/system/INPORT 32'h6 0
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