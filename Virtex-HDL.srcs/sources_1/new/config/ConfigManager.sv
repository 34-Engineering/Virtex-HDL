`timescale 1ns / 1ps
`include "VirtexConfig.sv"

/* ConfigManager - syncs writing to virtexConfig (see VirtexConfig.sv for individual configurations & defaults)

    */
module ConfigManager(
    input wire CLK100,
    output VirtexConfig virtexConfig,
    input VirtexConfigWriteRequest virtexConfigWriteRequests [1:0],
    output reg [7:0] debug
    );

    initial virtexConfig = DefaultVirtexConfig;

    //Write Requests
    reg [$size(virtexConfigWriteRequests)-1:0] lastVirtexConfigWriteRequestValids;
    always_ff @(negedge CLK100) begin
        //TODO fix potential metastability with virtexConfigWriteRequest
        for (int i = 0; i < $size(virtexConfigWriteRequests); i++) begin
            if (virtexConfigWriteRequests[i].valid & ~lastVirtexConfigWriteRequestValids[i]) begin
                //Add to EEPROM Memory Write Queue
                virtexConfig[getConfigAddrIndex(virtexConfigWriteRequests[i].addr) -: 16] <= 
                    virtexConfigWriteRequests[i].data;
            end

            lastVirtexConfigWriteRequestValids[i] <= virtexConfigWriteRequests[i].valid;
        end
    end
endmodule