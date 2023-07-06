`timescale 1ns/1ns

module multiplynnMatrix_Top(Go_t, Done_t, MULT_OUT_t, 
Rst_Core, MA_dib, MB_dib, MA_dia, MB_dia, MA_dob, MB_dob, 
MA_Addrb, MB_Addrb, MA_enb, MB_enb, MA_web, MB_web, Rst_M, Clk);

    //Core Interface 
   input Go_t;
   output Done_t;
   input Rst_Core;
   output [511:0] MULT_OUT_t;
   
   //Dual-port SRAM Interface 
   input [127:0] MA_dib, MB_dib;
   input [127:0] MA_dia, MB_dia;  //dummy port
   output [127:0] MA_dob, MB_dob; //dummy port
   input [0:0] MA_Addrb, MB_Addrb; //dummy port
   wire [0:0] MA_Addra, MB_Addra; //dummy port
   input MA_enb, MB_enb, MA_web, MB_web;
   input Rst_M;
   
   //Interface between SAD_Core and Dual_port SRAM
   wire [127:0] MA_doa, MB_doa;
   wire M_ena, M_wea;
   
   //Common Interface 
   input Clk;

   multiplynnMatrix Core(Go_t, MA_doa, MB_doa,
                          M_wea, M_ena, Done_t, MULT_OUT_t, Clk, Rst_Core);

    dp_sram_coregen MemA(
	MA_Addra,//addra,
	MA_Addrb,//addrb,
	Clk,//clka,
	Clk,//clkb,
	MA_dia,//dina,
	MA_dib,//dinb,
	MA_doa,//douta,
	MA_dob,//doutb,
	M_ena,//ena,
	MA_enb,//enb,
	Rst_M,//sinita,
	Rst_M,//sinitb,
	M_wea,//wea,
	MA_web);//web);
   
   dp_sram_coregen MemB(
	MB_Addra,//addra,
	MB_Addrb,//addrb,
	Clk,//clka,
	Clk,//clkb,
	MB_dia,//dina,
	MB_dib,//dinb,
	MB_doa,//douta,
	MB_dob,//doutb,
	M_ena,//ena,
	MB_enb,//enb,
	Rst_M,//sinita,
	Rst_M,//sinitb,
	M_wea,//wea,
	MB_web);//web);


endmodule