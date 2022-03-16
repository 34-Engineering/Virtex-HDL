onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+fifo_virtex_config -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.fifo_virtex_config xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {fifo_virtex_config.udo}

run -all

endsim

quit -force
