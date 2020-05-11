vsim work.hazard_detection_unit
add wave -position insertpoint sim:/hazard_detection_unit/*
force -freeze sim:/hazard_detection_unit/reset 0 0
force -freeze sim:/hazard_detection_unit/ID_EX_RegisterRt 001 0
force -freeze sim:/hazard_detection_unit/IF_ID_RegisterRs 001 0
force -freeze sim:/hazard_detection_unit/IF_ID_RegisterRt 001 0
force -freeze sim:/hazard_detection_unit/ID_EX_MemRead 1 0
run 100

