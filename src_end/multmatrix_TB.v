`timescale 1ns/1ns

module Testbench();
    reg  	           Go_s; 
    wire 	           Done_s; 
    wire [511:0]	       MULT_OUT_s;
    reg  	           Rst_Core_s; 
    reg  [127:0]  	   MA_dib_s;
    reg  [127:0]       MB_dib_s;
    wire [127:0]       MA_dia_s;  //dummy port
    wire [127:0]       MB_dia_s;  //dummy port
    wire [127:0]             MA_dob_s; //dummy port
    wire [127:0]             MB_dob_s; //dummy port
    reg  [0:0]   MA_Addrb_s; 
    reg  [0:0]   MB_Addrb_s;
    reg  	           MA_enb_s; 
    reg  	           MB_enb_s; 
    reg  	           MA_web_s; 
    reg  	           MB_web_s; 
    reg  	           Rst_M_s;
    reg  	           Clk_s;
    reg [127:0] A[0:0];
    reg [127:0] B[0:0];
    reg [255:0] Ref[1:0];
    parameter Clk_Period = 20;
    integer Index;
    

    multiplynnMatrix_Top ComptoTest(
        Go_s, Done_s, MULT_OUT_s, Rst_Core_s, MA_dib_s, MB_dib_s,
	    MA_dia_s, MB_dia_s, MA_dob_s, MB_dob_s, MA_Addrb_s, MB_Addrb_s,
	   MA_enb_s, MB_enb_s, MA_web_s, MB_web_s, Rst_M_s, Clk_s
    );

    always begin
        Clk_s <= 0;
        #(Clk_Period/2);
        Clk_s <= 1;
        #(Clk_Period/2);
    end

    initial $readmemh("./sw/MemA.txt", A);
    initial $readmemh("./sw/MemB.txt", B);
    initial $readmemh("./sw/sw_result.txt", Ref);

    initial begin
        //initialize all inputs
        Go_s <= 0; Rst_M_s <= 1; Rst_Core_s <= 1; 
        MA_enb_s <= 0; MB_enb_s <= 0; MA_web_s <= 0; MB_web_s <= 0;

        @(posedge Clk_s);
        Rst_M_s <= 1'b0;

        @(posedge Clk_s); // 행렬 A 불러오기
            MA_enb_s <= 1'b1;
            MA_web_s <= 1'b1;
            MA_dib_s <= A[0];
            
        @(posedge Clk_s);
        MA_enb_s <= 1'b0;
        MA_web_s <= 1'b0;

        @(posedge Clk_s); // 행렬 B 불러오기
            MB_enb_s <= 1'b1;
            MB_web_s <= 1'b1;
            MB_dib_s <= B[0];
            @(posedge Clk_s);
        MB_enb_s <= 1'b0;
        MB_web_s <= 1'b0;

        @(posedge Clk_s); // Multply 시작
        Rst_Core_s <= 1'b0;
        Go_s <= 1'b1;

        @(posedge Clk_s);
        Go_s <= 1'b0;

        @(posedge Clk_s);
        while(Done_s != 1'b1) begin
            @(posedge Clk_s);
            
            if(MULT_OUT_s != {Ref[0], Ref[1]})
                $display("Error %x != %x", MULT_OUT_s, {Ref[0], Ref[1]});
            else
                $display("Correct %x == %x", MULT_OUT_s, {Ref[0], Ref[1]});
            @(posedge Clk_s);
        end
        $stop;

    end

endmodule