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
    Reads & writes camera configurations 
    Fast Serial: https://docs.google.com/document/d/1Sg8LKgYLEdBtbzcvhCJvDzMn8KQxomQIMN0E1RHf6OQ/edit
    Virtex Fast Serial Protocol: https://docs.google.com/document/d/1n1cTdPgI_MZJplnfnsV4Gh2vK2MCvT35MewmOGstzLg/edit*/
module AppManager(
    input CLK,
    output FS_MISO, //FSDI input to PC, output from FPGA
    output FS_CLK, //driven by fpga, 50MHz
    input FS_MOSI, //FSDO output from PC, input to FPGA
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

endmodule
