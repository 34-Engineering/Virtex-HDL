# Virtex Embedded Code

This repository contains the Xilinx Vivado project for the Artix-7 (XC7A35T-1FTG256C) FPGA on Virtex. See [34-Engineering/Virtex-PCBs](https://github.com/34-Engineering/Virtex-PCBs) for wiring/setup. All FPGA code is written in SystemVerilog.

## Description

The FPGA handles the following tasks:

 1) Reading data from the [Python 300 Image Sensor](https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf) through the Onsemi's LVDS protocol
 2) Processing Blobs from image sensor data
 3) Configuring the image sensor over 10MHz SPI
 4) 4MHz SPI communication with RoboRIO
 5) [FTDI's Fast Serial](https://ftdichip.com/wp-content/uploads/2020/08/AN_131_FT2232D_H_Fast-Opto-Isolated-Serial-Interface-mode.pdf) communication over USB with [34-Engineering/Virtex-App](https://github.com/34-Engineering/Virtex-App)
 6) Controlling IR and signal LEDs
 7) Reading and saving camera configurations to EEPROM memory with 10MHz SPI
 8) Writing bit file sent over JTAG to flash memory with SPI 

## Source

`Virtex-Embedded-Code.srcs/sources_1/new`: source modules; only these files are synthesized into the FPGA bit file

- `Top.sv`: top (main) module for the FPGA source code

`Virtex-Embedded-Code.srcs/sim_1/new`: sim modules; used to simulate the hardware that the source modules interact with (Python 300, FT2232H, etc.)

- `TopSim.sv`: top simulation file for executing a global test of the entire FPGA

`Virtex-Embedded-Code.srcs/test_1/new`: test modules; used to confirm that every module is working correct

- `TopTest.sv`: top test file for executing unit tests on every module

`Virtex-Embedded-Code.srcs/constrs_1/new/Virtex.xdc`: master contrains file mapping ports in Top.sv to physical BGA pads

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