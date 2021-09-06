`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021 11:14:59 AM
// Module Name: AppManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* AppManager - Manages Communication with Virtex App 
    Streams video & processed blobs to FT2232H
    Reads & writes camera configurations */
module AppManager(
    input CLK,
    output FS_DI, //input to FT2232H
    output FS_CLK, //driven by fpga, 100MHz
    input FS_DO, //output from FT2232H
    input FS_CTS, //clear to send (on FSDO), active low
    output USB_PWRSAV,
    output USB_PWREN,
    output USB_SUS
    );

    assign USB_PWRSAV = 0;
    assign USB_PWREN = 1;
    assign USB_SUS = 0;

    assign FS_CLK = CLK;

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
