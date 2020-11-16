onerror {quit -f}
vlib work
vlog -work work L1P4.vo
vlog -work work L1P4.vt
vsim -novopt -c -t 1ps -L cycloneiii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.L1P4_vlg_vec_tst
vcd file -direction L1P4.msim.vcd
vcd add -internal L1P4_vlg_vec_tst/*
vcd add -internal L1P4_vlg_vec_tst/i1/*
add wave /*
run -all
