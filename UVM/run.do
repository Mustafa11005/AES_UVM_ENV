#vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover -l sim.log

coverage save AES_uvm.ucdb -onexit

add wave -position insertpoint sim:/top/intf_/*

run -all

#quit -sim
#vcover report AES_uvm.ucdb -details -annotate -all -output coverage_rpt.txt

