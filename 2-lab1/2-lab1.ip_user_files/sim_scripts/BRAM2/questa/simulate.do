onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib BRAM2_opt

do {wave.do}

view wave
view structure
view signals

do {BRAM2.udo}

run -all

quit -force
