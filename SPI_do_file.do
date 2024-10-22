vlib work
vlog RAM.v SPI_Slave.v SPI.v SPI_tb.v
vsim -voptargs=+acc work.SPI_tb
add wave *
run -all
#quit -sim