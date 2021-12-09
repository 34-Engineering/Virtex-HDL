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

/* AppManager - Manages communication with the Virtex App through FTDI's Fast Serial
     1) Streams video & processed blobs to FT2232H
     2) Reads & writes camera configurations 
    Fast Serial Docs: https://ftdichip.com/wp-content/uploads/2020/08/AN_131_FT2232D_H_Fast-Opto-Isolated-Serial-Interface-mode.pdf
    FT2232H Docs: https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf
    Fast Serial Notes: https://docs.google.com/document/d/1Sg8LKgYLEdBtbzcvhCJvDzMn8KQxomQIMN0E1RHf6OQ/edit
    Virtex Fast Serial Protocol: https://docs.google.com/document/d/1n1cTdPgI_MZJplnfnsV4Gh2vK2MCvT35MewmOGstzLg/edit
    */
module AppManager(
    input wire CLK,
    output reg FSDI, //FPGA->PC
    output wire FSCLK, //48MHz (FPGA generated)
    input wire FSDO, //PC->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    input wire USB_ON,
    input wire USB_PWREN, //usb power enabled, active low
    input wire USB_SUS //usb in suspend mode, active low
    );

    //48MHz clock
    wire CLK48;
    clk_wiz_1 clk_wiz_1(
        .clk_in1(CLK),
        .clk_out1(CLK48)
    );
    assign FSCLK = CLK48;

    //USB
    wire usbWorking = USB_ON & !USB_PWREN & USB_SUS;

    //Send Queue 
    reg [7:0] dataQueue [$] = { 8'b01100110, 8'b11110000 };
    reg [3:0] dataPos = 0;

    always @(posedge CLK48) begin
        if (usbWorking & dataQueue.size() > 0) begin
            //bit 0
            if (dataPos == 0) begin
                FSDI <= 0;
                dataPos <= 1;
            end

            //bit 9
            else if (dataPos == 9 & !FSCTS) begin
                //send destination bit
                FSDI <= 1;

                //prepare for next byte
                dataQueue.pop_front();
                dataPos <= 0;
            end

            //bit 1-8
            else if (!FSCTS) begin
                FSDI <= dataQueue[0][dataPos - 1];
                dataPos <= dataPos + 1;
            end
        end
        else begin
            //idle
            FSDI <= 1;
        end
    end

    // function void send(reg [7:0] data);
    //     dataQueue.push_back(data);
    // endfunction
endmodule