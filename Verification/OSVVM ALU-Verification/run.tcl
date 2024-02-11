
vsim -gui work.tbalu
add wave -position insertpoint  \
sim:/tbalu/Clk \
sim:/tbalu/nReset \
sim:/tbalu/A_internal \
sim:/tbalu/B_internal \
sim:/tbalu/SEL_internal \
sim:/tbalu/RES_internal \
sim:/tbalu/test_done_internal \
sim:/tbalu/tperiod_Clk \
sim:/tbalu/tpd
run -all