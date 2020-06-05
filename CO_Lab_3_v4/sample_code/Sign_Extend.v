// Author:0716033 周俊毅, 0716051 李庭逸


module Sign_Extend(
    data_i,
    opcode_i,
    data_o
    );

//I/O ports
input   [16-1:0] data_i;
input   [6-1:0]  opcode_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;
integer i;

//Sign extended
always @(*)begin
    if(opcode_i==6'b001101) begin
        data_o={ 16'b0, data_i[15:0]};
    end
    else begin
        data_o={ {16{data_i[15]}}, data_i[15:0]};
    end
end
endmodule
