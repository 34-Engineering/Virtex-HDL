`timescale 1ns / 1ps

/* AppManager - Manages communication with the Virtex App through FTDI's Fast Serial
     1) Streams video & processed blobs to FT2232H
     2) Reads & writes camera configurations 
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

    parameter GET_FRAME_CODE = 'b000;
    parameter GET_CONFIG_CODE = 'b001;
    parameter SET_CONFIG_CODE = 'b100;
    enum {NONE, GET_FRAME, GET_CONFIG, SET_CONFIG} state = NONE;
    reg stateStep = 0; //which byte num we are on in the state

    //Fast Serial
    FastSerial FastSerial(
        .CLK(CLK),
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS),
        .enabled(USB_ON & !USB_PWREN & USB_SUS)
    );
    task write(reg [0:7] data);
        FastSerial.write(data);
    endtask
    task clearWriteQueue();
        FastSerial.clearWriteQueue();
    endtask

    //On Data
    task onData(reg [0:7] data);
        $display ("read %b", data);
    endtask
endmodule