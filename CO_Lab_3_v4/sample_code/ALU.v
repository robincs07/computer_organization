// Author:0716033 周俊毅, 0716051 李庭逸


module ALU(
    src1_i,
    src2_i,
    ctrl_i,
    result_o,
    zero_o,
    greater_zero_o
    );

//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;
output           greater_zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg             zero_o;
reg             greater_zero_o;

wire [32-1:0] AND;
wire [32-1:0] OR;
wire [32-1:0] ADD;
wire [32-1:0] SUB;
wire [32-1:0] lt;
wire [32-1:0] ult;
wire signed [64-1:0] mul;
wire          greater_zero;

wire signed [32-1:0] ssrc1_i;
wire signed [32-1:0] ssrc2_i;

assign ssrc1_i=src1_i;
assign ssrc2_i=src2_i;

assign AND=src1_i&src2_i;
assign OR=src1_i|src2_i;
assign ADD=src1_i+src2_i;
assign SUB=src1_i-src2_i;
assign lt=(ssrc1_i<ssrc2_i) ? 1 : 0;
assign ult=(src1_i<src2_i)  ? 1 : 0;
assign mul = ssrc1_i*ssrc2_i;
assign greater_zero=(ssrc1_i>0) ? 1 : 0;


always @(*)
    begin
        case(ctrl_i)
        4'b0000:result_o<=AND;
        4'b0001:result_o<=OR;
        4'b0010:result_o<=ADD;
        4'b0110:result_o<=SUB;
        4'b0111:result_o<=lt;
        4'b1111:result_o<=ult;
        4'b0011:result_o <= mul[31:0];
        endcase
        zero_o<=~|SUB;
        greater_zero_o <= greater_zero;
    end

endmodule

