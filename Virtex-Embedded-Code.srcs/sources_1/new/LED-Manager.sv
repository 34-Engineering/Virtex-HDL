`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021 11:14:59 AM
// Module Name: LEDManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////


module LEDManager(
    input CLK,
    output IR,
    output PWR,
    output EN,
    output TAR,
    input V12
    );

    reg [26:0] enabledCounter;
    reg powerPWM;

    assign PWR = V12 ? 1 : powerPWM;
    assign TAR = Top.hasTarget;
    assign IR = Top.enabled;
    assign EN = Top.enabled && enabledCounter > 50000000;

    //100mHz
    always @(posedge CLK) begin
        enabledCounter = enabledCounter + 1;
        powerPWM = ~powerPWM;
    end

endmodule
