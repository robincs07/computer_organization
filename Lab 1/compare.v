module compare(
              bonus_control,    //3bit input
              equal_bit,        //1bit input
              less_than,        //1bit input
              bonus_set         //1bit output
              );
    
    input [3-1:0]   bonus_control;
    input           equal_bit;
    input           less_than;

    output reg      bonus_set;
    
    wire slt, sgt, sle, sge, seq, sne;
    //因為所有的結果都可以透過less_than 跟 equal來表示
    //想是set_greater_than 就是要大於，也就是要檢查不能小於也不能等於
    //其他也都可以用這樣來表示
    assign slt=less_than;
    assign sgt=~(less_than|equal_bit);
    assign sle=less_than|equal_bit;
    assign sge=~less_than;
    assign seq=equal_bit;
    assign sne=~equal_bit; 
    
    //最後就是依照bonus_control來決定是輸出何種結果
    //我是用case來寫
    always @(*)
    begin
        case (bonus_control)
            3'b000: bonus_set <= slt;
            3'b001: bonus_set <= sgt;
            3'b010: bonus_set <= sle;
            3'b011: bonus_set <= sge;
            3'b110: bonus_set <= seq;
            3'b100: bonus_set <= sne;      
        endcase    
    end
endmodule
