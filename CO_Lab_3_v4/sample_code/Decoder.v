// Author:0716033 周俊毅, 0716051 李庭逸

module Decoder(
    instr_op_i,
    zero_i,
    greater_zero_i,
    jump_reg_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    branch_o,
    jump_o,
    memwrite_o,
    memread_o
    );

//I/O ports
input  [6-1:0] instr_op_i;
input          zero_i;
input          greater_zero_i;
input          jump_reg_i;

output         RegWrite_o;
output [6-1:0] ALU_op_o;
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         branch_o;
output         jump_o;
output         memwrite_o;
output         memread_o;

//Internal Signals
reg    [6-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            branch_o;
reg            jump_o;
reg            memwrite_o;
reg            memread_o;


always@(*)begin
    ALU_op_o <= instr_op_i;
    //if instr_op[5:3]==0, 確定不是R-type就是branch
    //Rtype and beq, bne
    if (instr_op_i[5:3] == 3'b000)begin
        if(jump_reg_i) begin
            RegWrite_o <= 0;
            memwrite_o <= 0;
            memread_o <= 0;
            branch_o <= 0;
            jump_o <= 0;
        end
        else begin
            memwrite_o <= 0;
            memread_o <= 0;
            case(instr_op_i[2:0])
                3'b000: begin//R type
                    RegDst_o <= 1;
                    ALUSrc_o <= 0;
                    RegWrite_o <= 1;
                    branch_o <= 0;
                    jump_o <= 0;
                end
                3'b100: begin//branch if eq
                    RegDst_o <= 0;
                    ALUSrc_o <= 0;
                    RegWrite_o <= 0;
                    jump_o <= 0;
                    if(zero_i == 1) begin
                        branch_o <= 1;
                    end
                    else begin
                        branch_o <= 0;
                    end
                end
                3'b101: begin//branch if neq
                    RegDst_o <= 0;
                    ALUSrc_o <= 0;
                    RegWrite_o <= 0;
                    jump_o <= 0;
                    if(zero_i == 0) begin
                        branch_o <= 1;
                    end
                    else begin
                        branch_o <= 0;
                    end

                end
                3'b010: begin//j
                    RegDst_o <= 0;
                    ALUSrc_o <= 0;
                    RegWrite_o <= 0;
                    branch_o <= 0;
                    jump_o <= 1;
                end
                3'b011: begin//jal
                    RegDst_o <= 2;
                    ALUSrc_o <= 0;
                    RegWrite_o <= 1;
                    branch_o <= 0;
                    jump_o <= 1;
                end
                3'b110: begin//branch if <=0
                    RegDst_o <= 0;
                    ALUSrc_o <= 0;
                    RegWrite_o <= 0;
                    jump_o <= 0;
                    if(greater_zero_i == 0) begin
                        branch_o <= 1;
                    end
                    else begin
                        branch_o <= 0;
                    end
                end
                3'b111: begin//branch if > 0
                    RegDst_o <= 0;
                    ALUSrc_o <= 0;
                    RegWrite_o <= 0;
                    jump_o <= 0;
                    if(greater_zero_i == 1) begin
                        branch_o <= 1;
                    end
                    else begin
                        branch_o <= 0;
                    end
                end
            endcase
        end
    end
    //I-type(except for beq bne) Lab2
    else if(instr_op_i[5:3] == 3'b001)begin
        RegDst_o <= 0;
        ALUSrc_o <= 1;
        RegWrite_o <= 1;
        branch_o <= 0;
        jump_o <= 0;
        memwrite_o <= 0;
        memread_o <= 0;
    end
    else if(instr_op_i[5:3] == 3'b100)begin//load word
        RegDst_o <= 0;
        ALUSrc_o <= 1;
        RegWrite_o <=1;
        branch_o <=0;
        jump_o <= 0;
        memread_o <= 1;
        memwrite_o <= 0;
    end
    else if(instr_op_i[5:3] == 3'b101)begin//save word
        RegDst_o <= 0;
        ALUSrc_o <= 1;
        RegWrite_o <= 0;
        branch_o <= 0;
        jump_o <= 0;
        memread_o <= 0;
        memwrite_o <= 1;

    end
end

endmodule
