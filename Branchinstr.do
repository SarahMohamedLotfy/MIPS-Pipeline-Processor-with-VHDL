vsim -gui work.system
add wave -position insertpoint sim:/system/*
add wave -position insertpoint  \
sim:/system/Decode/RegisterFile/registers
add wave -position insertpoint sim:/system/Fetch/*
add wave -position insertpoint sim:/system/Fetch/DecisionCircuit/*
add wave -position insertpoint sim:/system/Fetch/Predicition/*
add wave -position insertpoint  \
sim:/system/Fetch/Predicition/Table/table
add wave -position insertpoint  \
sim:/system/Fetch/Predicition/PredicionFSM/inputState \
sim:/system/Fetch/Predicition/PredicionFSM/T_NT \
sim:/system/Fetch/Predicition/PredicionFSM/IF_IDFlush \
sim:/system/Fetch/Predicition/PredicionFSM/prediction_state \
sim:/system/Fetch/Predicition/PredicionFSM/current_state \
sim:/system/Fetch/Predicition/PredicionFSM/prev_state \
sim:/system/Fetch/Predicition/PredicionFSM/next_state \
sim:/system/Fetch/Predicition/PredicionFSM/reset \
sim:/system/Fetch/Predicition/PredicionFSM/taken \
sim:/system/Fetch/oldTargetAddress
add wave -position insertpoint  \
sim:/system/Execute/EXALUResult \
sim:/system/Execute/MEMALUResult \
sim:/system/Execute/MEM_WBRegisterRd \
sim:/system/Execute/EX_MEMRegisterRd \
sim:/system/Execute/EX_MEMRegWrite \
sim:/system/Execute/MEM_WBRegWrite \
sim:/system/Execute/EX_MEMSWAP \
sim:/system/Execute/MEM_WBSWAP \
sim:/system/Execute/RegDst \
sim:/system/Execute/CCR \
sim:/system/Execute/RsReg \
sim:/system/Execute/WBsignals \
sim:/system/Execute/MEMSignals \
sim:/system/Execute/ZF \
sim:/system/Execute/SWAP \
sim:/system/Execute/INTSignal \
sim:/system/Execute/RRI \
sim:/system/Execute/DataOut \
sim:/system/Execute/AddrressEA_IMM \
sim:/system/Execute/SRC2out \
sim:/system/Execute/MUXAInput \
sim:/system/Execute/MUXBInput \
sim:/system/Execute/MUXSRC2_signInput \
sim:/system/Execute/MUXALUResult_PC1Input \
sim:/system/Execute/MUXTempA_INPORTInput \
sim:/system/Execute/MUXRt_RdInput \
sim:/system/Execute/IMM_EAbit \
sim:/system/Execute/CallBit \
sim:/system/Execute/REGdstSignal \
sim:/system/Execute/INEnableSignal \
sim:/system/Execute/signType \
sim:/system/Execute/OVF \
sim:/system/Execute/UpperInstr \
sim:/system/Execute/PC_1 \
sim:/system/Execute/SRC1 \
sim:/system/Execute/SRC2 \
sim:/system/Execute/SignExtendOut \
sim:/system/Execute/tempA \
sim:/system/Execute/A \
sim:/system/Execute/B \
sim:/system/Execute/ALUResult \
sim:/system/Execute/MUXSRC2_signOutput \
sim:/system/Execute/INPORTValue \
sim:/system/Execute/ALUSelectors \
sim:/system/Execute/EA_Part \
sim:/system/Execute/CCRRegister \
sim:/system/Execute/Rs \
sim:/system/Execute/Rt \
sim:/system/Execute/Rd \
sim:/system/Execute/MUXASel \
sim:/system/Execute/MUXBSel

force -freeze sim:/system/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/system/INT 0 0
force -freeze sim:/system/rst 0 0
force -freeze sim:/system/INPORT 32'h0 0
mem load -i instructionMemory.mem  /fetch/instruction_memory/ram
force -freeze sim:/system/rst 1 0
run
force -freeze sim:/system/rst 0 0
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
run
run
run
run
run
run

