onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib fifo_python_to_blob_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {fifo_python_to_blob.udo}

run -all

quit -force
