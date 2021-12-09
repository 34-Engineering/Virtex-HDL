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

    reg [0:9] readData;
    reg [3:0] dataPos = 0;

    always @(negedge FSCLK) begin
        if (!FSDI & FSCTS) begin
            // $display ("got 0 = 0");
            FSCTS <= 0;
            readData[0] <= 0;
            dataPos <= 1;
        end
        else if (dataPos > 0 & !FSCTS) begin
            // $display ("got %p = %b", dataPos, FSDI);
            readData[dataPos] = FSDI;

            if (dataPos == 9) begin
                FSCTS <= 1;
                dataPos <= 0;
                onData(readData[1:8]);
            end
            else begin
                dataPos <= dataPos + 1;
            end
        end
    end

    task onData(reg [0:7] data);
        $display ("got %b", data);
    endtask

    task write(reg [0:7] data);
        
    endtask

    initial begin
        uut.write({uut.GET_CONFIG_CODE, 12});
    end
endmodule
