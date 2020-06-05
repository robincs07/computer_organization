`timescale 1ns/1ps

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		   bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


    input           rst_n;
    input  [32-1:0] src1;
    input  [32-1:0] src2;
    input   [4-1:0] ALU_control;
    input   [3-1:0] bonus_control; 
    //ALU_control 可以拆解成 A_invert B_invert 跟最後的operation
    //因為ALU_control 的第一二個值，就是決定src1跟src2要不要not
    //而決定slt的話需要將src1-src2的值來看大小, src1是否小於src2

    output [32-1:0] result;
    output          zero;
    output          cout;
    output          overflow;

    reg    [32-1:0] result;
    reg             zero;
    reg             cout;
    reg             overflow;

    //ov: overflow, rs: 32 bit result , c: 32 bit carry
    //equal: 檢查32個位置有沒有一樣, equal_bit: 檢查所有equal32bit是不是都一樣
    //less_than: src1是否小於src2, set: 經過compare出來的less值, lt: 第32bit相減後的結果
    wire ov;
    wire [32-1:0] rs;
    wire [33-1:0] c;
    wire [32-1:0] equal;
    wire equal_bit;
    wire less_than, set, lt;

    //因為要把減法變成加法，所以原本是A-B, 會變成A+(-B)
    //所做的方式就是將B變成他的2's component
    //也就是將B xor B_invert + 1, B_invert就是alu_control[2]
    assign c[0]=ALU_control[2];

    //down is alu 32, made up of 32 alu_top
    //將32bit src1和src2 放入32個Alu_top
    //那less只有第一個bit是將第32個ALU所計算出來lt來知道以及後來的compare來確定值是多少
    //A_invert B_invert就是ALU_control的[3][2]來決定src1跟2要不要invert
    //cin就是個別放入上一個ALU所計算出來的cout, 最後一個ALU的cout就是ZCV的C值
    //equal就是來確認每個bit是否一樣, 一樣是1, 不一樣是0
    alu_top a1(
        .src1(src1[0]),
        .src2(src2[0]),
        .less(set),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[0]),
        .operation(ALU_control[1:0]),
        .result(rs[0]),
        .cout(c[1]),
        .equal(equal[0])
    );
    alu_top a2(
        .src1(src1[1]),
        .src2(src2[1]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[1]),
        .operation(ALU_control[1:0]),
        .result(rs[1]),
        .cout(c[2]),
        .equal(equal[1])
    );
    alu_top a3(
        .src1(src1[2]),
        .src2(src2[2]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[2]),
        .operation(ALU_control[1:0]),
        .result(rs[2]),
        .cout(c[3]),
        .equal(equal[2])
    );
    alu_top a4(
        .src1(src1[3]),
        .src2(src2[3]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[3]),
        .operation(ALU_control[1:0]),
        .result(rs[3]),
        .cout(c[4]),
        .equal(equal[3])
    );

    alu_top a5(
        .src1(src1[4]),
        .src2(src2[4]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[4]),
        .operation(ALU_control[1:0]),
        .result(rs[4]),
        .cout(c[5]),
        .equal(equal[4])
    );
    alu_top a6(
        .src1(src1[5]),
        .src2(src2[5]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[5]),
        .operation(ALU_control[1:0]),
        .result(rs[5]),
        .cout(c[6]),
        .equal(equal[5])
    );
    alu_top a7(
        .src1(src1[6]),
        .src2(src2[6]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[6]),
        .operation(ALU_control[1:0]),
        .result(rs[6]),
        .cout(c[7]),
        .equal(equal[6])
    );
    alu_top a8(
        .src1(src1[7]),
        .src2(src2[7]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[7]),
        .operation(ALU_control[1:0]),
        .result(rs[7]),
        .cout(c[8]),
        .equal(equal[7])
    );
    alu_top a9(
        .src1(src1[8]),
        .src2(src2[8]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[8]),
        .operation(ALU_control[1:0]),
        .result(rs[8]),
        .cout(c[9]),
        .equal(equal[8])
    );
    alu_top a10(
        .src1(src1[9]),
        .src2(src2[9]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[9]),
        .operation(ALU_control[1:0]),
        .result(rs[9]),
        .cout(c[10]),
        .equal(equal[9])
    );
    alu_top a11(
        .src1(src1[10]),
        .src2(src2[10]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[10]),
        .operation(ALU_control[1:0]),
        .result(rs[10]),
        .cout(c[11]),
        .equal(equal[10])
    );
    alu_top a12(
        .src1(src1[11]),
        .src2(src2[11]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[11]),
        .operation(ALU_control[1:0]),
        .result(rs[11]),
        .cout(c[12]),
        .equal(equal[11])
    );
    alu_top a13(
        .src1(src1[12]),
        .src2(src2[12]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[12]),
        .operation(ALU_control[1:0]),
        .result(rs[12]),
        .cout(c[13]),
        .equal(equal[12])
    );
    alu_top a14(
        .src1(src1[13]),
        .src2(src2[13]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[13]),
        .operation(ALU_control[1:0]),
        .result(rs[13]),
        .cout(c[14]),
        .equal(equal[13])
    );
    alu_top a15(
        .src1(src1[14]),
        .src2(src2[14]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[14]),
        .operation(ALU_control[1:0]),
        .result(rs[14]),
        .cout(c[15]),
        .equal(equal[14])
    );
    alu_top a16(
        .src1(src1[15]),
        .src2(src2[15]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[15]),
        .operation(ALU_control[1:0]),
        .result(rs[15]),
        .cout(c[16]),
        .equal(equal[15])
    );
    alu_top a17(
        .src1(src1[16]),
        .src2(src2[16]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[16]),
        .operation(ALU_control[1:0]),
        .result(rs[16]),
        .cout(c[17]),
        .equal(equal[16])
    );
    alu_top a18(
        .src1(src1[17]),
        .src2(src2[17]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[17]),
        .operation(ALU_control[1:0]),
        .result(rs[17]),
        .cout(c[18]),
        .equal(equal[17])
    );
    alu_top a19(
        .src1(src1[18]),
        .src2(src2[18]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[18]),
        .operation(ALU_control[1:0]),
        .result(rs[18]),
        .cout(c[19]),
        .equal(equal[18])
    );
    alu_top a20(
        .src1(src1[19]),
        .src2(src2[19]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[19]),
        .operation(ALU_control[1:0]),
        .result(rs[19]),
        .cout(c[20]),
        .equal(equal[19])
    );
    alu_top a21(
        .src1(src1[20]),
        .src2(src2[20]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[20]),
        .operation(ALU_control[1:0]),
        .result(rs[20]),
        .cout(c[21]),
        .equal(equal[20])
    );
    alu_top a22(
        .src1(src1[21]),
        .src2(src2[21]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[21]),
        .operation(ALU_control[1:0]),
        .result(rs[21]),
        .cout(c[22]),
        .equal(equal[21])
    );
    alu_top a23(
        .src1(src1[22]),
        .src2(src2[22]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[22]),
        .operation(ALU_control[1:0]),
        .result(rs[22]),
        .cout(c[23]),
        .equal(equal[22])
    );
    alu_top a24(
        .src1(src1[23]),
        .src2(src2[23]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[23]),
        .operation(ALU_control[1:0]),
        .result(rs[23]),
        .cout(c[24]),
        .equal(equal[23])
    );
    alu_top a25(
        .src1(src1[24]),
        .src2(src2[24]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[24]),
        .operation(ALU_control[1:0]),
        .result(rs[24]),
        .cout(c[25]),
        .equal(equal[24])
    );
    alu_top a26(
        .src1(src1[25]),
        .src2(src2[25]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[25]),
        .operation(ALU_control[1:0]),
        .result(rs[25]),
        .cout(c[26]),
        .equal(equal[25])
    );
    alu_top a27(
        .src1(src1[26]),
        .src2(src2[26]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[26]),
        .operation(ALU_control[1:0]),
        .result(rs[26]),
        .cout(c[27]),
        .equal(equal[26])
    );
    alu_top a28(
        .src1(src1[27]),
        .src2(src2[27]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[27]),
        .operation(ALU_control[1:0]),
        .result(rs[27]),
        .cout(c[28]),
        .equal(equal[27])
    );
    alu_top a29(
        .src1(src1[28]),
        .src2(src2[28]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[28]),
        .operation(ALU_control[1:0]),
        .result(rs[28]),
        .cout(c[29]),
        .equal(equal[28])
    );
    alu_top a30(
        .src1(src1[29]),
        .src2(src2[29]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[29]),
        .operation(ALU_control[1:0]),
        .result(rs[29]),
        .cout(c[30]),
        .equal(equal[29])
    );
    alu_top a31(
        .src1(src1[30]),
        .src2(src2[30]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[30]),
        .operation(ALU_control[1:0]),
        .result(rs[30]),
        .cout(c[31]),
        .equal(equal[30])
    );
    alu_top a32(
        .src1(src1[31]),
        .src2(src2[31]),
        .less(1'b0),
        .A_invert(ALU_control[3]),
        .B_invert(ALU_control[2]),
        .cin(c[31]),
        .operation(ALU_control[1:0]),
        .result(rs[31]),
        .cout(c[32]),
        .equal(equal[31]),
        .lt(lt) 
    );

    //overflow的計算方式就是檢查最後一個bit的cin跟cout是不是一樣如果不一樣的話就是overflow
    //最後一個bit代表這個數字的sign
    //會overflow只有兩種方式一個是正數加正數但結果是負數也就是0+0+1=1, cin=1, cout=0
    //, 這樣最後一個bit就是1 overflow
    //負數加負數 cin=0, 1+1+0=0, cout=1 這樣cin!=cout, overflow
    assign ov=c[31]^c[32];

    //因為lt只是最後一個bit+cin相加之後的結果所以有可能會因為overflow出來結果是錯的
    //解決方法就是看兩個數是不是同號，因為相減會overflow只有可能是正減負以及負減正
    //如果同號只要看被減數(src1)的sign就知道結果，而同號就還是要看lt的結果來判斷
    assign less_than=equal[31] ? lt : src1[31];
    
    //equal_bit將所有bit and起來只要有一個不一樣也就是0, equal_bit就會是0
    and and1(   equal_bit, equal[0], equal[1], equal[2], equal[3], equal[4], 
                equal[5], equal[6], equal[7], equal[8], equal[9], equal[10], 
                equal[11], equal[12], equal[13], equal[14], equal[15], equal[16]
                , equal[17], equal[18], equal[19], equal[20], equal[21], equal[22]
                , equal[23], equal[24], equal[25], equal[26], equal[27], equal[28]
                , equal[29], equal[30], equal[31]
            );
    
    //因為要比較大小以及等於所以要將equal_bit 跟 less_than放入 compare 裡
    //而bonus_control是決定要做出哪種比較的，所以也要放入
    //output是set，最後set就是會接到第一個ALU的less來表示結果
    compare c1(
        .bonus_control(bonus_control),
        .equal_bit(equal_bit),
        .less_than(less_than),
        .bonus_set(set)
    );
    //最後就是輸出的部分
    //result就是rs
    //zero則是把每一個bit nor在一起來知道是不是全部都是0
    //cout則是最後一個bit的cout值
    //overflow就是ov
    always @(*) begin
        if (rst_n) begin
            result<= rs;
            zero<= ~|rs;
            cout<= c[32];
            overflow<= ov;
        end
    end
endmodule
