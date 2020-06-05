// Author:0716051 李庭逸

module Decoder(
    instr_op_i,
    zero_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    branch_o
    );

//I/O ports
input  [6-1:0] instr_op_i;
input          zero_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         branch_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            branch_o;



always@(*)begin
    ALU_op_o = instr_op_i[3:1];
    //if instr_op[5:3]==0, 確定不是R-type就是branch
    //Rtype and beq, bne
    if (instr_op_i[5:3] == 3'b000)begin
        case(instr_op_i[2:0])
            3'b000: begin
                RegDst_o <= 1;
                ALUSrc_o <= 0;
                RegWrite_o <= 1;
                branch_o <= 0;
            end
            3'b100: begin
                RegDst_o <= 0;
                ALUSrc_o <= 0;
                RegWrite_o <= 0;
                branch_o <= 1;
            end
            3'b101: begin
                RegDst_o <= 0;
                ALUSrc_o <= 0;
                RegWrite_o <= 0;
                branch_o <= 1;
            end
        endcase
    end
    //I-type(except for beq bne)
    else begin
        RegDst_o <= 0;
        ALUSrc_o <= 1;
        RegWrite_o <= 1;
        branch_o <= 0;
    end
end

endmodule
