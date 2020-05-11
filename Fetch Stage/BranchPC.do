quit -sim
vsim -gui work.branchpc
add wave -position insertpoint sim:/branchpc/*
force -freeze sim:/branchpc/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/branchpc/PC 32'd1 0
force -freeze sim:/branchpc/enable  0
force -freeze sim:/branchpc/PC 32'd1 0
run

