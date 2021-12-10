`timescale 1ns / 1ps

/* AppManagerTest - 

    */
module AppManagerTest(input wire CLK);
    wire USB_ON = 1;
    wire USB_PWREN = 0;
    wire USB_SUS = 1;
    wire FSDI;
    wire FSCLK;
    bit FSDO = 1; //active low
    bit FSCTS = 1; //active low

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
    wire [7:0] readData;
    wire readDataValid;
    FastSerialTest FastSerialTest(
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS),
        .enabled(1),
        .readData(readData),
        .readDataValid(readDataValid)
    );
    task write(bit [0:7] data);
        FastSerialTest.write(data);
    endtask
    task clearWriteQueue();
        FastSerialTest.clearWriteQueue();
    endtask

    //On Data
    always @(posedge readDataValid) begin
        $display ("test read %b", readData);
    end

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
