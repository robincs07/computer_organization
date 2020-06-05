//Author: 0716033 周俊毅, 0716051 李庭逸

module Combine(
    PC_addr,
    instr,
    j_addr
);

input       [4-1:0]     PC_addr;
input       [26-1:0]    instr;

output reg  [32-1:0]    j_addr;

always @(*) begin
    j_addr={PC_addr, instr, 2'b00};
end 

endmodule // 