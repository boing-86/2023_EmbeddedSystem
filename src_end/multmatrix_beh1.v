`timescale 1ns/1ns
`define R_WIDTH 32
`define N 4

// MULT_OUT 은 NxN 행렬의 정중앙에 있는 값임. output에 array를 선언불가하기 때문
module multiplynnMatrix(Go, A_Data, B_Data,
                        RW, En, Done, MULT_OUT, Clk, Rst);
    input Go, Clk, Rst;
    output reg RW, En, Done;
    output reg [511:0] MULT_OUT;
    input [127:0] A_Data, B_Data;


    parameter S0 = 4'b0000, S1 = 4'b0001, S1a = 4'b1100, S2 = 4'b0010, S3 = 4'b0011,
              S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7a = 4'b0111,
              S7 = 4'b1000, S8 = 4'b1001, S9 = 4'b1010, S10 = 4'b1011;
    reg [3:0] State;
    integer i, j, k;
    integer tmp;
    reg [15:0] MatrixR [0:3][0:3];
    reg [7:0] MatrixA[0:3][0:3];
    reg [7:0] MatrixB[0:3][0:3];

    always @(posedge Clk) begin

        if (Rst==1) begin
            MULT_OUT <= {(`R_WIDTH){1'b0}};
            RW <= 1'b0;
            En <= 1'b0;
            Done <= 1'b0;
            State <= S0;

        end 
        else begin
            MULT_OUT <= {(`R_WIDTH){1'b0}};
            RW <= 1'b1;
            En <= 1'b0;
            Done <= 1'b0;
			MatrixA[0][0] <= A_Data[7:0];
            MatrixB[0][0] <= B_Data[7:0];
            MatrixA[0][1] <= A_Data[15:8];
            MatrixB[0][1] <= B_Data[15:8];
            MatrixA[0][2] <= A_Data[23:16];
            MatrixB[0][2] <= B_Data[23:16];
            MatrixA[0][3] <= A_Data[31:24];
            MatrixB[0][3] <= B_Data[31:24];
            MatrixA[1][0] <= A_Data[39:32];
            MatrixB[1][0] <= B_Data[39:32];
            MatrixA[1][1] <= A_Data[47:40];
            MatrixB[1][1] <= B_Data[47:40];
            MatrixA[1][2] <= A_Data[55:48];
            MatrixB[1][2] <= B_Data[55:48];
            MatrixA[1][3] <= A_Data[63:56];
            MatrixB[1][3] <= B_Data[63:56];
            MatrixA[2][0] <= A_Data[71:64];
            MatrixB[2][0] <= B_Data[71:64];
            MatrixA[2][1] <= A_Data[79:72];
            MatrixB[2][1] <= B_Data[79:72];
            MatrixA[2][2] <= A_Data[87:80];
            MatrixB[2][2] <= B_Data[87:80];
            MatrixA[2][3] <= A_Data[95:88];
            MatrixB[2][3] <= B_Data[95:88];
            MatrixA[3][0] <= A_Data[103:96];
            MatrixB[3][0] <= B_Data[103:96];
            MatrixA[3][1] <= A_Data[111:104];
            MatrixB[3][1] <= B_Data[111:104];
            MatrixA[3][2] <= A_Data[119:112];
            MatrixB[3][2] <= B_Data[119:112];
            MatrixA[3][3] <= A_Data[127:120];
            MatrixB[3][3] <= B_Data[127:120];
            end

            case (State)
            S0: begin
                if (Go == 1) begin
                    State <= S1;
								end
                else begin
                    State <= S0;
                end 
            end

            S1:begin
                RW <= 1'b1;
                En <= 1'b0;
                State <= S1a;
            end

            S1a : begin
                MatrixA[0][0] <= A_Data[7:0];
                MatrixB[0][0] <= B_Data[7:0];
                MatrixA[0][1] <= A_Data[15:8];
                MatrixB[0][1] <= B_Data[15:8];
                MatrixA[0][2] <= A_Data[23:16];
                MatrixB[0][2] <= B_Data[23:16];
                MatrixA[0][3] <= A_Data[31:24];
                MatrixB[0][3] <= B_Data[31:24];
                MatrixA[1][0] <= A_Data[39:32];
                MatrixB[1][0] <= B_Data[39:32];
                MatrixA[1][1] <= A_Data[47:40];
                MatrixB[1][1] <= B_Data[47:40];
                MatrixA[1][2] <= A_Data[55:48];
                MatrixB[1][2] <= B_Data[55:48];
                MatrixA[1][3] <= A_Data[63:56];
                MatrixB[1][3] <= B_Data[63:56];
                MatrixA[2][0] <= A_Data[71:64];
                MatrixB[2][0] <= B_Data[71:64];
                MatrixA[2][1] <= A_Data[79:72];
                MatrixB[2][1] <= B_Data[79:72];
                MatrixA[2][2] <= A_Data[87:80];
                MatrixB[2][2] <= B_Data[87:80];
                MatrixA[2][3] <= A_Data[95:88];
                MatrixB[2][3] <= B_Data[95:88];
                MatrixA[3][0] <= A_Data[103:96];
                MatrixB[3][0] <= B_Data[103:96];
                MatrixA[3][1] <= A_Data[111:104];
                MatrixB[3][1] <= B_Data[111:104];
                MatrixA[3][2] <= A_Data[119:112];
                MatrixB[3][2] <= B_Data[119:112];
                MatrixA[3][3] <= A_Data[127:120];
                MatrixB[3][3] <= B_Data[127:120];

                i <= 0;
                State <= S2;
                RW <= 1'b0;
                En <= 1'b0;
            end

            S2:begin
                if (i < `N) begin
                    State <= S3;
                end
                else begin
                    State <= S10;
                end

            end

            S3:begin
                j <= 0;
                State <= S4;
            end

            S4:begin
                if (j < `N) begin
                    State <= S5;
                end
                else begin
                    State <= S9;
                end
            end

            S5:begin
                k = 0;
                State <= S6;
            end

            S6:begin
                if (k < `N) begin
                    State <= S7a;
                    RW <= 1'b0;
                    En <= 1'b0;
                end
                else begin
                    State <= S8;
                end
            end

            S7a:begin
                State <= S7;
            end

            S7 : begin
                tmp = MatrixR[i][j];
                MatrixR[i][j] = tmp + MatrixA[i][k] * MatrixB[k][j];
                k = k+1;
                State <= S6;
            end

            S8:begin
                j <= j+1;
                State <= S4;
            end

            S9:begin
                i <= i+1;
                State <= S2;
            end

            S10:begin
                MULT_OUT <= {MatrixR[3][3], MatrixR[3][2], MatrixR[3][1], MatrixR[3][0], 
                            MatrixR[2][3], MatrixR[2][2], MatrixR[2][1], MatrixR[2][0],
                            MatrixR[1][3], MatrixR[1][2], MatrixR[1][1], MatrixR[1][0], 
                            MatrixR[0][3], MatrixR[0][2], MatrixR[0][1], MatrixR[0][0]};
                Done <= 1'b1;
                State <= S0;
            end
            endcase
            
    end
endmodule
