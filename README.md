# Virtex Embedded Code

This repository contains the Xilinx Vivado project for the Artix-7 (XC7A35T-1FTG256C) FPGA on Virtex. See [34-Engineering/Virtex-PCBs](https://github.com/34-Engineering/Virtex-PCBs) for wiring/setup. All FPGA code is written in SystemVerilog.

## Description

The FPGA handles the following tasks:

 1) 576Mb/s LVDS & SPI Interface with the [Python 300 Image Sensor](https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf)
 2) Real-time Run Length Encoding & Blob Processing
 3) Target Selection
 4) SPI Communication with the RoboRIO
 5) Fast Serial Communication over USB 2.0 with [34-Engineering/Virtex-App](https://github.com/34-Engineering/Virtex-App)
 6) Controlling IR and Signal LEDs
 7) EEPROM SPI Interface for Saving Virtex Configurations
 8) JTAG Boundry Scan to Flash Memory Interface

## Terminology

Blob: a group of touching pixels

- Bounding Box: the minimum non-rotated rectangle that covers all pixels in the blob
- Quad: a quadrilateral made from the four most extreme points in the blob (used for rotation/slope calculations)

Target: a blob or group of blobs that represent the entire physical target

Kernel: a group of 8 horizontal pixels (native to Python 300)

- White Pixel: a pixel that has a value >  threshold
- Black Pixel: a pixel that has a value <= threshold

Run: a 1-pixel-tall horizontal line of similarly colored pixels that is represented by only it's length (and blobID). Calculating its x-coordinate requires looking at the runs before it in the run buffer.

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

If you have any questions feel free to contact [info@34engineering.com](mailto:info@34engineering.com)
