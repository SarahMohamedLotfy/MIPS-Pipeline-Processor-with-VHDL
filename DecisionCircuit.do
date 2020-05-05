vsim -gui work.decision
add wave -position insertpoint sim:/decision/*
force -freeze sim:/decision/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/decision/rst 0 0
force -freeze sim:/decision/PCreg 16'd0 0
run