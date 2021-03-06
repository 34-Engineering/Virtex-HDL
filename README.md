# Virtex HDL

This repository contains the Xilinx Vivado project for the Artix-7 (XC7A35T-1FTG256C) FPGA on Virtex. See [34-Engineering/Virtex-PCBs](https://github.com/34-Engineering/Virtex-PCBs) for wiring/setup. All FPGA code is written in SystemVerilog.

## Description

The FPGA handles the following tasks:

 1) Automatic Configuration, Reconfiguration, & Tempturature Shutoff over an SPI Interface with the [Python 300 Image Sensor](https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf)
 2) 576Mb/s LVDS Interface through SerDes with the Python 300
 3) Run Length Encoding & Frame Buffering of Python 300 Image Data
 4) Real-time Vision Processing (Blob Making & Target Selection) from Python 300 Image Data
 5) Configuration, Enabling, & Target Reading over external Virtex SPI Interface
 6) Async FT245 FIFO Interface with FT2232H USB 2.0 IC to the [34-Engineering/Virtex-App](https://github.com/34-Engineering/Virtex-App)
 7) IR LED and RGB LED Bar Control with Fault Tolerance
 8) EEPROM SPI Interface for Saving Virtex Configurations
 9) JTAG Boundry Scan to Flash Memory Interface

## Nomenclature

Blob: an isolated white region in the image

- Bounding Box: the minimum non-rotated rectangle that covers all pixels in the blob
- Quad: a quadrilateral made from the four most extreme points in the blob (used for angle calculations)

Target: a blob or group of blobs that represent the entire physical target

Kernel: a line of 8 horizontal pixels (native to the Python 300)

## Source

`Virtex-HDL.srcs/sources_1/new`: source modules; only these files are synthesized into the FPGA bit file

- `Top.sv`: top (main) module for the FPGA source code

`Virtex-HDL.srcs/sim_1/new`: sim modules; used to simulate the hardware that the source modules interact with (Python 300, FT2232H, etc.)

- `TopSim.sv`: top simulation file for executing a global test of the entire FPGA

`Virtex-HDL.srcs/test_1/new`: test modules; used to confirm that every module is working correct

- `TopTest.sv`: top test file for executing unit tests on every module

`Virtex-HDL.srcs/constrs_1/new/Virtex.xdc`: master contrains file mapping ports in Top.sv to physical BGA pads

## Simulating & Building

All simulating, synthesis, implementation, and bitstream generation is done through Vivado 2021.

## VSCode Setup (Windows 10/11)

 1) Add VSCode to PATH (ex  `C:\Users\liams\AppData\Local\Programs\Microsoft VS Code\bin`), and ensure `code .` works in the command line

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

 5) (Optional) Run `set_param general.maxThreads 8` in the Vivado TCL console to reduce Synthesis time.

## Questions

If you have any questions feel free to contact [info@34engineering.com](mailto:info@34engineering.com) or [liamsnow03@gmail.com](mailto:liamsnow03@gmail.com)

## Flashing with Open OCD

`openocd --file ocd.cfg`
