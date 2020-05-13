vsim -gui work.decision
add wave -position insertpoint sim:/decision/*
force -freeze sim:/decision/PCreg 32'h9 0
force -freeze sim:/decision/rst 1 0
force -freeze sim:/decision/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/decision/ReadFromMemorySignal 0 0
force -freeze sim:/decision/JZ 0 0
force -freeze sim:/decision/UnconditionBranch 0 0
force -freeze sim:/decision/T_NT 11 0
force -freeze sim:/decision/State 00 0
run
force -freeze sim:/decision/rst 0 0
force -freeze sim:/decision/MemoryPC 32'hFF 0
force -freeze sim:/decision/ReadFromMemorySignal 1 0
run
force -freeze sim:/decision/ReadFromMemorySignal 0 0
force -freeze sim:/decision/DecodePC 32'h000f 0
force -freeze sim:/decision/T_NT 01 0
run
force -freeze sim:/decision/TargetAddress 32'h00f0 0
force -freeze sim:/decision/JZ 1 0
force -freeze sim:/decision/State 11 0
run
force -freeze sim:/decision/T_NT 11 0
force -freeze sim:/decision/T_NT 11 0
run