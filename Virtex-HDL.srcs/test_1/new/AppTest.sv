`timescale 1ns / 1ps

/* AppManagerTest - 

    */
module AppManagerTest();

    // wire USB_ON = 1;
    // wire USB_PWREN = 0;
    // wire USB_SUS = 1;
    // wire FSDI;
    // wire FSCLK;
    // reg FSDO = 1; //active low
    // reg FSCTS = 1; //active low

    // AppManager(
    //     .CLK(CLK),
    //     .FSDI(FSDI),
    //     .FSCLK(FSCLK),
    //     .FSDO(FSDO),
    //     .FSCTS(FSCTS),
    //     .USB_ON(USB_ON),
    //     .USB_PWREN(USB_PWREN),
    //     .USB_SUS(USB_SUS),
    //     .configuration(configuration),
    //     .saveConfig(saveConfig),
    //     .frameBuffer(frameBuffer)
    // );

    // //Fast Serial
    // wire [7:0] readData;
    // wire readDataValid;
    // FastSerialSim FastSerialSim(
    //     .FSDI(FSDI),
    //     .FSCLK(FSCLK),
    //     .FSDO(FSDO),
    //     .FSCTS(FSCTS),
    //     .enabled(1'b1),
    //     .readData(readData),
    //     .readDataValid(readDataValid)
    // );

    // //On Data
    // always_ff @(posedge readDataValid) begin
    //     $display ("test read %b", readData);
    // end

    // //Test
    // initial begin
    //     FastSerialSim.write(8'b00100000);
    // end
endmodule
