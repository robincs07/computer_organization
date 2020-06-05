// Author:0716051 李庭逸

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
input [2-1:0] leftright_i;
output [32-1:0] data_o;

reg     [32-1:0] data_o;

always@(*)begin
    //leftshift
    case(leftright_i)
        //branch leftshift 2
        //leftright 10
        2'b10: data_o <= se_i << 2;

        //lui leftshift 16
        //leftright 11
        2'b11: data_o <= se_i << 16;
        
        //sra
        //leftright 00
        2'b00: data_o <= $signed(data2_i) >>> shamt_i;

        //srav
        //leftright 01
        2'b01: data_o <= $signed(data2_i) >>> data1_i;
    endcase
end

endmodule
