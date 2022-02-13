`timescale 1ns / 1ps

/* FlashManager - 

    Docs: https://www.macronix.com/Lists/Datasheet/Attachments/7409/MX25V1635F,%202.5V,%2016Mb,%20v1.4.pdf


    Flash: MX25V1635FM2I (2,000,000 x 8-bits)
     - 80MHz



    Uses 

    */
module FlashManager(
    input wire CLK,
    output wire SPI_CLK, SPI_CS,
    output wire [3:0] SPI_Q,
    input wire TMS, TCK, TDI,
    output wire TDO
    );
    
    initial begin
        
    end

    //TODO
 
    // wire bscan_tdi;
    // wire bscan_tck;
    // wire bscan_tms;
    // wire bscan_drck1;
    // wire bscan_sel1;
    // wire bscan_shift;
    // wire bscan_capture;
    // wire bscan_update;
    // reg bscan_tdo1 = 0;

    // BSCAN_SPARTAN3A
    // bscan_inst (
    //     .TDI(bscan_tdi),
    //     .TCK(bscan_tck),
    //     .TMS(bscan_tms),
    //     .DRCK1(bscan_drck1),
    //     .DRCK2(),
    //     .RESET(),
    //     .SEL1(bscan_sel1),
    //     .SEL2(),
    //     .SHIFT(bscan_shift),
    //     .CAPTURE(bscan_capture),
    //     .UPDATE(bscan_update),
    //     .TDO1(bscan_tdo1),
    //     .TDO2(1'b1)
    // );

    // wire flash_mosi_int;
    // wire flash_miso_int = flash_miso;
    // wire flash_clk_int;
    // wire flash_cs_int;
    // wire flash_sel = bscan_sel1 & bscan_shift;

    // assign flash_mosi = flash_sel ? bscan_tdi : flash_mosi_int;
    // assign flash_clk = flash_sel ? bscan_drck1 : flash_clk_int;
    // assign flash_cs = flash_sel ? 1'b0 : flash_cs_int;

    // always @(posedge bscan_drck1) begin
    //     bscan_tdo1 <= flash_miso;
    // end
endmodule