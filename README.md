# Virtex Embedded Code

This repository contains the Xilinx Vivado project for the Artix-7 (XC7A35T-1FTG256C) FPGA on Virtex. See [34-Engineering/Virtex-PCBs](https://github.com/34-Engineering/Virtex-PCBs) for wiring/setup. All FPGA code is written in SystemVerilog.

## Description

The FPGA handles the following tasks:

 1) Reading data from the [Python 300 Image Sensor](https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf) through the Onsemi's LVDS protocol
 2) Processing Blobs from image sensor data
 3) Configuring the image sensor over SPI
 4) I2C communication with RoboRIO
 5) [FTDI's Fast Serial](https://ftdichip.com/wp-content/uploads/2020/08/AN_131_FT2232D_H_Fast-Opto-Isolated-Serial-Interface-mode.pdf) communication over USB with [34-Engineering/Virtex-App](https://github.com/34-Engineering/Virtex-App)
 6) Controlling IR and signal LEDs
 7) Reading and saving camera configurations to EEPROM memory with SPI
 8) Writing bit file sent over JTAG to flash memory with SPI 

## Source

Source Files: `Virtex-Embedded-Code.srcs/sources_1/new`

Test Files: `Virtex-Embedded-Code.srcs/sim_1/new`

## Simulating & Building

All simulating, synthesis, implementation, and bitstream generation is done through Vivado 2021.

## IDE Setup

 1) Install VSCode, add it to PATH (ex  `C:\Users\liams\AppData\Local\Programs\Microsoft VS Code\bin`), and ensure `code .` works in the command line

 2) Download [Universal Ctags](https://github.com/universal-ctags/ctags), add it to PATH (ex `D:\Program Files (x86)\ctags`), and ensure `ctags` works in the command line

 3) Download Xilinx Vivado, add the following enviornment vairables, and ensure `xvlog` works in the command line
    - PATH
      - `C:\Xilinx\Vivado\2021.1\bin`
      - `C:\Xilinx\Vivado\2021.1\lib\win64.o`
      - `C:\Xilinx\DocNav`
      - `C:\Xilinx\Model_Composer\2021.1\bin`
      - `C:\Xilinx\Vitis_HLS\2021.1\bin`
    - XILINX_HLS = C:\Xilinx\Vitis_HLS\2021.1
    - XILINX_VIVADO = C:\Xilinx\Vivado\2021.1

 4) Install the [Verilog VSCode Extension](https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL) and configure settings
    - Set `verilog.ctags.path` = `ctags`
    - Set `verilog.linting.linter` = `xvlog`