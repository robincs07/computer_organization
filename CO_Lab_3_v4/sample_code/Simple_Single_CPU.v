// Author: 0716033 周俊毅, 0716051 李庭逸

module Simple_Single_CPU(
    clk_i,
    rst_i
    );

// Input port
input clk_i;
input rst_i;

wire  [31:0] pc_o;
wire  [31:0] adder_o;
wire  [31:0] mux_adder_o;
wire  [31:0] instr;
wire  [4:0]  mux_write_o;
wire  [31:0] rdata1_o;
wire  [31:0] rdata2_o;
wire  [31:0] mux_alusrc_o;
wire  [31:0] se_o;
wire         regwrite_o;
wire  [5:0]  aluop_o;
wire  [1:0]  regdst;
wire         branch;
wire  [1:0]  result_ctrl_o;
wire  [2:0]  leftright_o;
wire  [31:0] shift_o;
wire         zero_o;
wire  [31:0] result_o;
wire  [31:0] mux_pcsrc_o;
wire  [4-1:0] ALUCtrl_o;
wire          alusrc_o;
wire  [31:0] adder2_pcsrc_o;
wire  [31:0] j_addr_o;
wire         jump_o;
wire  [31:0] j_jal_o;
wire         jumpreg_o;
wire  [31:0] MUX_jr_o;
wire  [31:0] rdata_o;
wire         memread_o;
wire         memwrite_o;
wire         greater_zero_o;

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i (rst_i),
    .pc_in_i(MUX_jr_o),
    .pc_out_o(pc_o)
    );

Adder Adder1(
    .src1_i(pc_o),
    .src2_i(mux_adder_o),
    .sum_o(adder_o)
    );

MUX_2to1 #(.size(32)) Mux_Adder(
    .data0_i(32'd4),
    .data1_i(adder2_pcsrc_o),
    .select_i(branch),
    .data_o(mux_adder_o)
    );

Instr_Memory IM(
    .pc_addr_i(pc_o),
    .instr_o(instr)
    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instr[20:16]),
    .data1_i(instr[15:11]),
    .data2_i(5'b11111),
    .select_i(regdst),
    .data_o(mux_write_o)
    );

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i) ,
    .RSaddr_i(instr[25:21]) ,
    .RTaddr_i(instr[20:16]) ,
    .RDaddr_i(mux_write_o) ,
    .RDdata_i(mux_pcsrc_o)  ,
    .RegWrite_i (regwrite_o),
    .RSdata_o(rdata1_o) ,
    .RTdata_o(rdata2_o)
    );

Decoder Decoder(
    .instr_op_i(instr[31:26]),
    .zero_i(zero_o),
    .greater_zero_i(greater_zero_o),
    .jump_reg_i(jumpreg_o),
    .RegWrite_o(regwrite_o),
    .ALU_op_o(aluop_o),
    .ALUSrc_o(alusrc_o),
    .RegDst_o(regdst),
    .branch_o(branch),
    .jump_o(jump_o),
    .memwrite_o(memwrite_o),
    .memread_o(memread_o)
    );

ALU_Ctrl AC(
    .funct_i(instr[5:0]),
    .ALUOp_i(aluop_o),
    .ALUCtrl_o(ALUCtrl_o),
    .leftright_o(leftright_o),
    .jump_reg_o(jumpreg_o),
    .result_ctrl_o(result_ctrl_o)
    );

Sign_Extend SE(
    .opcode_i(instr[31:26]),
    .data_i(instr[15:0]),
    .data_o(se_o)
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(rdata2_o),
    .data1_i(se_o),
    .select_i(alusrc_o),
    .data_o(mux_alusrc_o)
    );

ALU ALU(
    .src1_i(rdata1_o),
    .src2_i(mux_alusrc_o),
    .ctrl_i(ALUCtrl_o),
    .result_o(result_o),
    .zero_o(zero_o),
    .greater_zero_o(greater_zero_o)
    );

Shift_Left_Two_32 Shifter(
    .se_i(se_o),
    .shamt_i(instr[10:6]),
    .data1_i(rdata1_o),
    .data2_i(rdata2_o),
    .leftright_i(leftright_o),
    .data_o(shift_o)
    );

//branch or alu result will both add 4
//src2_i and sum_o of adder2 have the same wire
Adder adder2(
    .src1_i(32'd4),
    .src2_i(mux_pcsrc_o),
    .sum_o(adder2_pcsrc_o)
);

MUX_4to1 #(.size(32)) Mux_PC_Source(
    .data0_i(result_o),
    .data1_i(shift_o),
    .data2_i(rdata_o),
    .data3_i(adder_o),
    .select_i(result_ctrl_o),
    .data_o(mux_pcsrc_o)
    );
MUX_2to1 #(.size(32)) Mux_j_jal(
    .data0_i(adder_o),
    .data1_i(j_addr_o),
    .select_i(jump_o),
    .data_o(j_jal_o)
    );
MUX_2to1 #(.size(32)) Mux_jr(
    .data0_i(j_jal_o),
    .data1_i(rdata1_o),
    .select_i(jumpreg_o),
    .data_o(MUX_jr_o)
    );
Combine combine(
    .PC_addr(adder_o[31:28]),
    .instr(instr[25:0]),
    .j_addr(j_addr_o)
);

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(result_o),
    .data_i(rdata2_o),
    .MemRead_i(memread_o),
    .MemWrite_i(memwrite_o),
    .data_o(rdata_o)
    );
endmodule
