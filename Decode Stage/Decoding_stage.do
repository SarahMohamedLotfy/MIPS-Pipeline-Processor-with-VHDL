vsim work.decoder
add wave -position insertpoint sim:/decoder/*
force -freeze sim:/decoder/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/decoder/interrupt 0 0
force -freeze sim:/decoder/reset 1 0
run 100


force -freeze sim:/decoder/reset 0 0
force -freeze sim:/decoder/flush_decoder 0 0
force -freeze sim:/decoder/RegWrite 1 0
force -freeze sim:/decoder/Swap 1 0
force -freeze sim:/decoder/Mem_Wb_Rd 001 0
force -freeze sim:/decoder/value1 00001111000011110000111100001111 0
force -freeze sim:/decoder/Mem_Wb_Rs 010 0
force -freeze sim:/decoder/value2 11111111111111110000000000000000 0
run 100

force -freeze sim:/decoder/reset 0 0
force -freeze sim:/decoder/flush_decoder 0 0
force -freeze sim:/decoder/RegWrite 0 0
force -freeze sim:/decoder/Swap 0 0
force -freeze sim:/decoder/Rt_from_fetch 000 0
force -freeze sim:/decoder/IF_ID_Rt 001 0
force -freeze sim:/decoder/IF_ID_Rs 010 0
run 100

