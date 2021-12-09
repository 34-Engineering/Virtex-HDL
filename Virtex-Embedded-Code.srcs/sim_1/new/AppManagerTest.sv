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

    AppManager AppManager(
        .CLK(CLK),
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS),
        .USB_ON(USB_ON),
        .USB_PWREN(USB_PWREN),
        .USB_SUS(USB_SUS)
    );

    //Fast Serial
    FastSerialTest FastSerial(
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS)
    );
    task write(reg [0:7] data);
        FastSerial.write(data);
    endtask
    task clearWriteQueue();
        FastSerial.clearWriteQueue();
    endtask

    //On Data
    task onData(reg [0:7] data);
        $display ("got %b", data);
    endtask

    //Test
    initial begin
        // AppManager.write({AppManager.GET_CONFIG_CODE, 12});
        write('{uut.GET_CONFIG_CODE, 12});
    end
endmodule
