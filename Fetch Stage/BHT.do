quit -sim
vsim -gui work.bht
add wave -position insertpoint sim:/bht/*
force -freeze sim:/bht/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/bht/index 00000 0
force -freeze sim:/bht/RW 1 0
force -freeze sim:/bht/predictionState 01 0
run 
