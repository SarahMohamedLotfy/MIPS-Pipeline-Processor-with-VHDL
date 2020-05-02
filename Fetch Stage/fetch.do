quit -sim
vsim -gui work.fetchstage

add wave -position insertpoint sim:/fetchstage/*

force -freeze sim:/fetchstage/PCReg 16'h0 0
force -freeze sim:/fetchstage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fetchstage/PCReg 0000000000000000 0
mem load -i instructionMemory.mem  /fetchstage/instruction_memory/ram

run