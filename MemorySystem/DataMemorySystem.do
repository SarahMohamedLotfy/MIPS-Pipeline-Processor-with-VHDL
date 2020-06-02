vsim -gui work.memorysystem
add wave -position insertpoint sim:/memorysystem/*
mem load -i instructionMemory.mem -format mti -filltype inc -filldata 0 -fillradix symbolic -skip 0 -startaddress 0 -endaddress 2047 /memorysystem/DataMainMemory/MainMemory/Memory
force -freeze sim:/memorysystem/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/memorysystem/rst 1 0
force -freeze sim:/memorysystem/WR 0 0
force -freeze sim:/memorysystem/RD 1 0
force -freeze sim:/memorysystem/address 32'ha 0
force -freeze sim:/memorysystem/Datain 32'hFF 0
add wave -position insertpoint  \
sim:/memorysystem/DataMemoryController/current_state
add wave -position insertpoint  \
sim:/memorysystem/InstrMemoryController/current_state
run
force -freeze sim:/memorysystem/rst 0 0
force -freeze sim:/memorysystem/Data 1 0
force -freeze sim:/memorysystem/Instr 0 0
run
run
run
run
run
run
run
force -freeze sim:/memorysystem/WR 1 0
force -freeze sim:/memorysystem/RD 0 0
force -freeze sim:/memorysystem/address 00000000000000000000000000001100 0
run
run
mem load -i instructionMemory.mem /memorysystem/InstrMainMemory/MainMemory/Memory
force -freeze sim:/memorysystem/RD 1 0
force -freeze sim:/memorysystem/WR 0 0
force -freeze sim:/memorysystem/Data 0 0
force -freeze sim:/memorysystem/Instr 1 0
run
run
run
run
run
run
run
force -freeze sim:/memorysystem/Data 1 0
run
run