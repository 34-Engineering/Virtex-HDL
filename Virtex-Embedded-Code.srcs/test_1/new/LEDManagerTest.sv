`timescale 1ns / 1ps

/* LEDManagerTest - 

    */
module LEDManagerTest;
    reg CLK;
    always #5 CLK <= !CLK;

    reg LED_IR = 0;
    reg [2:0] LED_PWR = 0;
    reg [2:0] LED_EN = 0;
    reg [2:0] LED_TAR = 0;
    reg [2:0] LED_COM = 0;
    reg LED_USER = 0;
    reg LED_FAULT = 0;
    reg USB_ON = 0;
    reg PWR_12V_EN = 0;
    reg enabled = 0;
    reg targetBlobValid = 0;
    reg hasCommunication = 0;

    LEDManager LEDManager(
        .CLK(CLK),
        .LED_IR(LED_IR),
        .LED_PWR(LED_PWR),
        .LED_EN(LED_EN),
        .LED_TAR(LED_TAR),
        .LED_COM(LED_COM),
        .LED_USER(LED_USER),
        .LED_FAULT(LED_FAULT),
        .USB_ON(USB_ON),
        .PWR_12V_EN(PWR_12V_EN),
        .enabled(enabled),
        .targetBlobValid(targetBlobValid),
        .hasCommunication(hasCommunication)
    );

    initial begin
        assert(LED_IR == 0);
        assert(LED_PWR[0] == 0);
        assert(LED_PWR[1] == 1);
        assert(LED_TAR[2] == 0);
        assert(LED_COM[1] == 0);

        LED_FAULT = 1;
        USB_ON = 1;
        PWR_12V_EN = 1;
        enabled = 1;
        targetBlobValid = 1;
        hasCommunication = 1;

        #100

        assert(LED_IR == 1);
        assert(LED_PWR[0] == 1);
        assert(LED_PWR[1] == 1);
        assert(LED_TAR[2] == 1);
        assert(LED_COM[1] == 1);
    end
endmodule
