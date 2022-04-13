onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib BRAM_opt

do {wave.do}

view wave
view structure
view signals

do {BRAM.udo}

run -all

quit -force
