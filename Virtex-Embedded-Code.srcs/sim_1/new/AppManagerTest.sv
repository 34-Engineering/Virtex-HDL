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
    FastSerialTest FastSerialTest(
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS)
    );
    task write(reg [0:7] data);
        FastSerialTest.write(data);
    endtask
    task clearWriteQueue();
        FastSerialTest.clearWriteQueue();
    endtask

    //On Data
    task onData(reg [0:7] data);
        $display ("test read %b", data);
    endtask

    //Test
    initial begin
        write(8'b11111111);
        write(8'b00000000);
        write(8'b11110000);
        write(8'b00001111);
        write(8'b10101010);
        write(8'b01010101);

        #1000 begin
            AppManager.write(8'b11111111);
            AppManager.write(8'b00000000);
            AppManager.write(8'b11110000);
            AppManager.write(8'b00001111);
            AppManager.write(8'b10101010);
            AppManager.write(8'b01010101);
        end
    end
endmodule
