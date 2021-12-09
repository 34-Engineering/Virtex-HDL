`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 12/6/2021
// Module Name: AppManagerTest
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

module AppManagerTest(input wire CLK);
    wire USB_ON = 1;
    wire USB_PWREN = 0;
    wire USB_SUS = 1;
    wire FSDI;
    wire FSCLK;
    reg FSDO = 1; //active low
    reg FSCTS = 1; //active low

    AppManager uut(
        .CLK(CLK),
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS),
        .USB_ON(USB_ON),
        .USB_PWREN(USB_PWREN),
        .USB_SUS(USB_SUS)
    );

    reg [9:0] readData;
    reg [3:0] dataPos = 0;
    always @(posedge FSCLK) begin
        if (FSCTS) begin
            //wants to send data
            if (!FSDI) begin
                //so let it
                FSCTS <= 0;
                dataPos <= 0;
            end
        end
        else begin
            readData[dataPos] <= FSDI;
            dataPos <= dataPos + 1;
            if (dataPos == 10) begin
                FSCTS <= 1;
                $display ("got %p", readData);
            end
        end
    end
endmodule
