onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+fifo_python_to_blob -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.fifo_python_to_blob xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {fifo_python_to_blob.udo}

run -all

endsim

quit -force
