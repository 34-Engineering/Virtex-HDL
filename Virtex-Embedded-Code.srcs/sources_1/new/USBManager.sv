`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021 11:14:59 AM
// Module Name: USBManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* USBManager - Manages Communication with the FT2232H 
    Streams video & processes blobs to FT2232H
    Sends a list of all configurations on request
    Sets individual configurations on request */
module USBManager(
    input CLK,
    output FSDI, //input to FT2232H
    output FSCLK, //driven by fpga, 100MHz
    input FSDO, //output from FT2232H
    input FSCTS, //clear to send (on FSDO), active low
    output PWRSAV,
    output PWREN,
    output SUS
    );

    assign PWRSAV = 0;
    assign PWREN = 1;
    assign SUS = 0;

    assign FSCLK = CLK;

    always @(posedge CLK) begin
        
    end

    /* Fast Serial Interface Cheat Sheet
        Start bit is 0
        LSB first
        Stop bit is 1 (for channel B)

        FSDI Sequence (rel to FPGA):
         1) Send a start bit (only if FSCTS is high) --> FT2232H will drop FSCTS on the next positive clock edge
         2) Send a byte of data followed by a stop bit

        FSDO Sequence (rel to FPGA):
         1) Recieve a start bit (FT2232H cannot do this if it is recieving data on FSDI)
         2) Recieve a byte of data followed by a stop bit
    */

endmodule
