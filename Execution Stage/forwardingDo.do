vsim -gui work.forwardingunit
add wave -position insertpoint sim:/forwardingunit/*
force -freeze sim:/forwardingunit/MEM_WBRegisterRd 011 0
force -freeze sim:/forwardingunit/EX_MEMRegisterRd 010 0
force -freeze sim:/forwardingunit/ID_EXRegisterRs 011 0
force -freeze sim:/forwardingunit/ID_EXRegisterRt 111 0
force -freeze sim:/forwardingunit/EX_MEMRegWrite 1 0
force -freeze sim:/forwardingunit/MEM_WBRegWrite 1 0
force -freeze sim:/forwardingunit/EX_MEMSWAP 0 0
force -freeze sim:/forwardingunit/MEM_WBSWAP 0 0
run