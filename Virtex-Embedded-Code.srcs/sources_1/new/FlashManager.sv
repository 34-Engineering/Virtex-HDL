`timescale 1ns / 1ps

/* FlashManager - 

    Docs: https://www.macronix.com/Lists/Datasheet/Attachments/7409/MX25V1635F,%202.5V,%2016Mb,%20v1.4.pdf


    Flash: MX25V1635FM2I (2,000,000 x 8-bits)
     - 80MHz



    Uses 

    */
module FlashManager(
    input wire CLK,
    output wire SPI_CLK,
    output wire SPI_CS,
    output wire [3:0] SPI_Q,
    input wire TMS,
    input wire TCK,
    output wire TDO,
    input wire TDI
    );

    assign SPI_CS = 1;

    JTAG(
        .TMS(TMS),
        .TCK(TCK),
        .TDO(TDO),
        .TDI(TDI)
    );

    //80MHz SPI_CLK
    //TODO 80MHz SPI_CLK?

    //SPI master
    //TODO SPI master?
endmodule