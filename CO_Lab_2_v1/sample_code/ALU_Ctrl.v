// Author:0716051 李庭逸

module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o,
        leftright_o,
        result_ctrl_o,
        );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o; //alu要執行甚麼程序
output     [2-1:0] leftright_o;
output          result_ctrl_o;
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg        [2-1:0] leftright_o;
reg             result_ctrl_o;

//Select exact operation
always@(*)begin
        //if ALUop前三項==0, 也就是Rtype
        if(ALUOp_i == 3'b000)begin
                //if funct_i前三項==0, result=shifte
                        
                        case(funct_i)
                                //leftright=00, sra
                                6'b000011: begin
                                        leftright_o<=2'b00;
                                        result_ctrl_o<=1;
                                end
                                //leftright=01, srav
                                6'b000111: begin
                                        leftright_o <= 2'b01;
                                        result_ctrl_o <= 1;
                                end
                                //addu
                                6'b100001: begin
                                        ALUCtrl_o <= 4'b0010;
                                        result_ctrl_o <= 0;
                                end
                                //subu
                                6'b100011: begin
                                        ALUCtrl_o <= 4'b0110;
                                        result_ctrl_o <= 0;
                                end
                                //and
                                6'b100100: begin
                                        ALUCtrl_o <= 4'b0000;
                                        result_ctrl_o <= 0;
                                end
                                //or
                                6'b100101: begin
                                        ALUCtrl_o <= 4'b0001;
                                        result_ctrl_o <= 0;
                                end
                                //slt
                                6'b101010: begin
                                        ALUCtrl_o <= 4'b0111;
                                        result_ctrl_o <= 0;
                                end

                        endcase
        end
        //if ALUop前三項==010, 確定是branch
        else if (ALUOp_i == 3'b010) begin
                //leftshift<<2, alu設定成相減
                leftright_o <= 2'b10;
                ALUCtrl_o <= 4'b0110;
                result_ctrl_o <= 1;
        end
        //if ALUop前三項==111, 確定是lui, result==shifter, leftshift<<16
        else if (ALUOp_i == 3'b111) begin
                leftright_o <= 2'b11;
                result_ctrl_o <= 1;
        end
        //R-type
        else begin
                result_ctrl_o <= 0;
                case(ALUOp_i)
                        3'b100: ALUCtrl_o = 4'b0010;
                        3'b110: ALUCtrl_o = 4'b0001;
                        3'b101: ALUCtrl_o = 4'b1111;
                endcase
        end
end

endmodule
