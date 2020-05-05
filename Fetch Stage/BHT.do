vsim -gui work.bht
add wave -position insertpoint sim:/bht/*
force -freeze sim:/bht/clk 1 0, 0 {50 ps} -r 100
