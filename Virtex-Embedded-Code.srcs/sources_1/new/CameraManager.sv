`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021 11:14:59 AM
// Module Name: CameraManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////


module CameraManager(
    input CLK,
    input MC_LPP,
    input MC_LPN,
    input MC_HSP,
    input MC_HSN,
    input [1:0] MD_LPP,
    input [1:0] MD_LPN,
    input [1:0] MD_HSP,
    input [1:0] MD_HSN,
    inout [3:0] GPIO,
    output SHDN,
    output SCL,
    inout SDA 
    );

    //Sub-Components
    CameraConfigManager CameraConfigManager(
        .CLK(CLK),
        .GPIO(GPIO),
        .SHDN(SHDN),
        .SCL(SCL),
        .SDA(SDA)
    ); /* synthesis preserve */

    MIPICSI2Reader MIPICSI2Reader(
        .CLK(CLK),
        .ENABLED(Top.enabled),
        .RESET(1),
        .MC_HSN(MC_HSN),
        .MC_HSP(MC_HSP),
        .MC_LPN(MC_LPN),
        .MC_LPP(MC_LPP),
        .MD_HSN(MD_HSN),
        .MD_HSP(MD_HSP),
        .MD_LPN(MD_LPN),
        .MD_LPP(MD_LPP),
        .TDATA(TDATA),
        //.TDEST(),
        //.TLAST()
        .TUSER(TUSER),
        .TVALID(TVALID),
        .CLK200(CLK200)
    ); /* synthesis preserve */

    wire TDATA; //[7:0]
    wire TUSER; //[63:0]
    wire TVALID;
    wire CLK200;

    BlobProcessor BlobProcessor(
        .CLK200(CLK200),
        .TDATA(TDATA),
        .TUSER(TUSER),
        .TVALID(TVALID)
    ); /* synthesis preserve */

endmodule