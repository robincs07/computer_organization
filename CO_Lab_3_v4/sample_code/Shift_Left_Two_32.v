// Author:0716033 周俊毅, 0716051 李庭逸


module Shift_Left_Two_32(
    se_i,
    shamt_i,
    data1_i,
    data2_i,
    leftright_i,
    data_o
    );

//I/O ports
input [32-1:0] se_i;
input [5-1:0] shamt_i;
input [32-1:0] data1_i;
input [32-1:0] data2_i;
input [3-1:0] leftright_i;
output [32-1:0] data_o;

reg     [32-1:0] data_o;

always@(*)begin
    //leftshift
    case(leftright_i)
        //branch leftshift 2
        //leftright 010
        3'b010: data_o <= se_i << 2;

        //lui leftshift 16
        //leftright 011
        3'b011: data_o <= se_i << 16;
        
        //sra
        //leftright 000
        3'b000: data_o <= $signed(data2_i) >>> shamt_i;

        //srav
        //leftright 001
        3'b001: data_o <= $signed(data2_i) >>> data1_i;

        //sll
        //leftright 100
        3'b100: data_o <= $signed(data2_i) <<< shamt_i;
        //
    endcase
end

endmodule
