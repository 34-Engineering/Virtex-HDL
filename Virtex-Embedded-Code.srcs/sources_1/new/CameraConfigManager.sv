`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/28/2021 07:21:36 PM
// Module Name: CameraConfigManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* CameraConfigManager - I2C Master to the ARX3A0
    Sets all camera config & boot */
module CameraConfigManager(
    input CLK,
    inout [3:0] GPIO,
    output SHDN,
    output SCL,
    inout SDA
    );

    assign XSHDN = 0;
    assign GPIO = 4'b0000;

endmodule
