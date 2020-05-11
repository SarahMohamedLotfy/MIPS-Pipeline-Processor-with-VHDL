vsim -gui work.branchhazard
add wave -position insertpoint sim:/branchhazard/*
force -freeze sim:/branchhazard/clk 1 0, 0 {50 ps} -r 100
