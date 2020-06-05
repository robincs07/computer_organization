`timescale 1ns/1ps

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               equal,      //1 bit equal    (output)
               lt          //1 bit lt       (output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;        

output        result;
output        cout;
output        equal;
output        lt;

reg           result;
wire          lt;

wire input1, input2, And, Or, Add;

//將src1和src2分別跟a_invert和b_invert做XOR可以知道直要不要做反向
//像如果要做NAND, NOR, SUB, 都需要加個not所以可以運用abinvert來直接讓src1跟src2做反向
//e.g:A nand B =~A or ~B
assign input1=src1^A_invert;
assign input2=src2^B_invert;

//equal 是要檢查兩個bit是否一樣如果一樣的話就output->1, 因為A_invert->0, B_invert->1
//, 所以當scr1跟src2的bit一樣的話要用xor來得到 1, 因為src2會xorB_invert來得到相反的值
//所以最後input1跟input2要不一樣才是原本一樣, 所以用xor
assign equal=input1^input2;

//A and B
//A nor B = ~A and ~B 因為A nor B可以這樣表示所以就寫在一起
assign And=input1&input2;

//A or B
//A nand B =~A or ~B 因為A nand B可以這樣表示所以就寫在一起
assign Or=input1|input2;

//A add B= A xor B xor cin (因為A xor B以經算過了所以替換成算過的equal)
//cout如同底下的code一樣只要三個變數中有其中兩個是1, cout就會是1
assign Add=cin^equal;
assign cout=(input1&input2)|(input1&cin)|(input2&cin);

//最後因為要算slt, 所以我需要將最後一個bit鄉檢結果來看是正數還是負數
assign lt=Add;

//最後就是決定result 的輸出結果, 根據operation的輸入結果來決定
//00:and/nor 01:or/nand 10:add/sub 11:less
always@( * )
    begin
        case(operation)
            2'b00:result=And;
            2'b01:result=Or;
            2'b10:result=Add;
            2'b11:result=less;
        endcase
end

endmodule
