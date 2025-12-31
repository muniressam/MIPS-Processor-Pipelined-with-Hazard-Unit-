vlib work
vlog ../RTL/*.v +cover
vlog *.v +cover
vsim -voptargs=+acc work.MIPS_TB

add wave /MIPS_TB/DUT/*

run -all

#quit -sims