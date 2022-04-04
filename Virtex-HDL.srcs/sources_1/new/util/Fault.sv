`timescale 1ns / 1ps



/* Faults */
//TODO sticky & non sticky faults
`ifndef FAULT_DONE
`define FAULT_DONE

typedef struct packed {
    //LED
    logic IR_LED;              //fault flag from MAX chip (electrical issue like LED burn out)

    //Python
    logic PYTHON_300_PLL;      //python 300 PLL could not stabalize (electrical issue?)
    
    //Blob
    logic OUT_OF_BLOB_MEM;     //tried to create more blobs than available in mem (probably too noisy)
    logic OUT_OF_RLE_MEM;     
    logic BLOB_PROCESSOR_SLOW; //blob processor took too long on line(s) (probably too noisy)
    logic RUN_FIFO_FULL;      //blob run length encoder wasn't reading kernels fast enough3
    logic MAX_TARGET_GROUP_SIZE;

    logic reserved08;
    logic reserved09;
    logic reserved10;
    logic reserved11;

    logic reserved12;
    logic reserved13;
    logic reserved14;
    logic reserved15;

    logic reserved16;
    logic reserved17;
    logic reserved18;
    logic reserved19;
    
    logic reserved20;
    logic reserved21;
    logic reserved22;
    logic reserved23;

    logic reserved24;
    logic reserved25;
    logic reserved26;
    logic reserved27;

    logic reserved28;
    logic reserved29;
    logic reserved30;
    logic reserved31;
} Faults;

`endif