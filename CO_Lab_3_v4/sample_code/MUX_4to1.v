// Author:0716033 周俊毅, 0716051 李庭逸

module MUX_4to1(
    data0_i,
    data1_i,
    data2_i,
    data3_i,
    select_i,
    data_o
    );

parameter size = 32;

//I/O ports
input   [size-1:0] data0_i;
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [size-1:0] data3_i;
input   [2-1:0]    select_i;
output  [size-1:0] data_o;

//Internal Signals
reg     [size-1:0] data_o;
always @(*)
    begin
        if (select_i==1) begin
            data_o<=data1_i;
        end
        else if(select_i==2)begin
            data_o<=data2_i;
        end
        else if(select_i==3)begin
            data_o<=data3_i;
        end
        else begin
            data_o<=data0_i;
        end
    end

endmodule
