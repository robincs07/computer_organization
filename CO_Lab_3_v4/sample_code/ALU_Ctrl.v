// Author:0716033 周俊毅, 0716051 李庭逸

module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o,
        leftright_o,
        jump_reg_o,
        result_ctrl_o,
        );

//I/O ports
input      [6-1:0] funct_i;
input      [6-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o; //alu要執行甚麼程序
output     [3-1:0] leftright_o;
output     [2-1:0] result_ctrl_o;
output             jump_reg_o;
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg        [3-1:0] leftright_o;
reg        [2-1:0] result_ctrl_o;
reg                jump_reg_o;

//Select exact operation
always@(*)begin
        //if ALUop前三項==0, 也就是Rtype
        if(ALUOp_i == 6'b0)begin
                //if funct_i前三項==0, result=shifte
                        
                        case(funct_i)
                                //leftright=00, sra
                                6'b000011: begin
                                        leftright_o <= 3'b000;
                                        result_ctrl_o <= 2'b01;
                                        jump_reg_o <= 0;
                                end
                                //leftright=01, srav
                                6'b000111: begin
                                        leftright_o <= 3'b001;
                                        result_ctrl_o <= 2'b01;
                                        jump_reg_o <= 0;
                                end
                                //addu
                                6'b100001: begin
                                        ALUCtrl_o <= 4'b0010;
                                        result_ctrl_o <= 2'b00;
                                        jump_reg_o <= 0;
                                end
                                //subu
                                6'b100011: begin
                                        ALUCtrl_o <= 4'b0110;
                                        result_ctrl_o <= 2'b00;
                                        jump_reg_o <= 0;
                                end
                                //and
                                6'b100100: begin
                                        ALUCtrl_o <= 4'b0000;
                                        result_ctrl_o <= 0;
                                        jump_reg_o <= 0;
                                end
                                //or
                                6'b100101: begin
                                        ALUCtrl_o <= 4'b0001;
                                        result_ctrl_o <= 2'b00;
                                        jump_reg_o <= 0;
                                end
                                //slt
                                6'b101010: begin
                                        ALUCtrl_o <= 4'b0111;
                                        result_ctrl_o <= 2'b00;
                                        jump_reg_o <= 0;
                                end
                                //sll
                                6'b000000: begin
                                        leftright_o <= 3'b100;
                                        result_ctrl_o <= 2'b01;
                                        jump_reg_o <= 0;
                                end
                                //mul
                                6'b011000: begin
                                        ALUCtrl_o <= 4'b0011;
                                        result_ctrl_o <= 2'b00;
                                        jump_reg_o <= 0;
                                end
                                //jr
                                6'b001000: begin
                                        jump_reg_o <= 1;
                                end
                        endcase
        end
        //if ALUop前三項==010, 確定是branch
        //beq, bne, blez, bgtz
        else if (ALUOp_i == 6'b000100 || ALUOp_i == 6'b000101 || ALUOp_i == 6'b000110 || ALUOp_i == 6'b000111) begin
                //leftshift<<2, alu設定成相減
                leftright_o <= 3'b010;
                ALUCtrl_o <= 4'b0110;
                result_ctrl_o <= 2'b01;
                jump_reg_o <= 0;
        end
        //if ALUop前三項==111, 確定是lui, result==shifter, leftshift<<16
        //lui
        else if (ALUOp_i == 6'b001111) begin
                leftright_o <= 3'b011;
                result_ctrl_o <= 2'b01;
                jump_reg_o <= 0;
        end
        //lw
        else if (ALUOp_i == 6'b100011) begin
                ALUCtrl_o = 4'b0010;
                result_ctrl_o <= 2'b10;
                jump_reg_o <= 0;
        end
        //sw
        else if (ALUOp_i == 6'b101011) begin
                ALUCtrl_o = 4'b0010;
                jump_reg_o <= 0;
        end
        //jal
        else if (ALUOp_i == 6'b000011) begin
                result_ctrl_o <=2'b11;
                jump_reg_o <= 0;
        end
        //R-type
        else begin
                result_ctrl_o <= 2'b00;
                case(ALUOp_i)
                        //addi
                        6'b001000: begin
                                ALUCtrl_o = 4'b0010;
                                jump_reg_o <= 0;
                        end
                        //ori
                        6'b001101: begin
                                ALUCtrl_o = 4'b0001;
                                jump_reg_o <= 0;
                        end
                        //sltiu
                        6'b001011: begin
                                ALUCtrl_o = 4'b1111;
                                jump_reg_o <= 0;
                        end
                endcase
        end
end

endmodule
