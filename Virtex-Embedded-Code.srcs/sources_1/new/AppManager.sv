`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021
// Module Name: AppManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* AppManager - Manages Communication with Virtex App 
    Streams video & processed blobs to FT2232H
    Reads & writes camera configurations 
    Fast Serial: https://docs.google.com/document/d/1Sg8LKgYLEdBtbzcvhCJvDzMn8KQxomQIMN0E1RHf6OQ/edit
    Virtex Fast Serial Protocol: https://docs.google.com/document/d/1n1cTdPgI_MZJplnfnsV4Gh2vK2MCvT35MewmOGstzLg/edit
    */
module AppManager(
    input wire CLK,
    output reg FSDI, //FPGA->PC
    output wire FSCLK, //48MHz (FPGA generated)
    input wire FSDO, //USB->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    output wire USB_ON,
    output wire USB_PWREN,
    output wire USB_SUS
    );

    assign USB_ON = 0;
    assign USB_PWREN = 1;
    assign USB_SUS = 0;

    wire CLK48;
    clk_wiz_1 clk_wiz_1(
        .clk_in1(CLK),
        .clk_out1(CLK48)
    );

    wire send;
    assign send = USB_ON;

    reg [7:0] logic_input = 0'b10010110;

    wire [10:0] output_frame;
    assign output_frame[0] = 1; // FSDI=1 (idle state)
    assign output_frame[1] = 0;
    assign output_frame[9:2] = logic_input;
    assign output_frame[10] = 1; // Destination bit (1=portB)

    reg [3:0] current_bit = 0;

    assign FSCLK = clk48;

    always @(posedge CLK48) begin
        if (((send & FSCTS) | current_bit > 0) & current_bit < 10) begin
            current_bit <= current_bit + 1;
        end
        else begin
            current_bit <= 0;
        end
        FSDI <= output_frame[current_bit];
    end

endmodule
