module alu_control_tb;
    
        reg  [1:0] alu_op;
        reg  [5:0] funct;
        wire [2:0] select;
    
        alu_control uut (
            .funct(funct),
            .aluop(alu_op),
            .select(select)
        );
    
        initial begin
            $monitor("time=%0t alu_op=%b funct=%b select=%b", $time, alu_op, funct, select);
    
            alu_op = 2'b00; funct = 6'b100000; #10; // lw/sw -> add
            alu_op = 2'b01; funct = 6'b100000; #10; // beq   -> sub
            alu_op = 2'b10; funct = 6'b100000; #10; // add
            alu_op = 2'b10; funct = 6'b100010; #10; // sub
            alu_op = 2'b10; funct = 6'b100100; #10; // and
            alu_op = 2'b10; funct = 6'b100101; #10; // or
            alu_op = 2'b10; funct = 6'b101010; #10; // slt
            $finish;
        end
    
    endmodule     
