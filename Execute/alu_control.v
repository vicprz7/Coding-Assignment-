module alu_control(
    input  wire [5:0] funct,
    input  wire [1:0] aluop,
    output reg  [2:0] select
    );
    
    // ALUOp encodings
    parameter ALUOP_LWSW = 2'b00,
               ALUOP_BEQ  = 2'b01,
               ALUOP_RTYPE= 2'b10, 
               ALUOP_INV  = 2'b11;

    // ALU control encodings
    parameter ALU_AND = 3'b000,
               ALU_OR  = 3'b001,
               ALU_ADD = 3'b010,
               ALU_X   = 3'b011,
               ALU_SUB = 3'b110,
               ALU_SLT = 3'b111;

    // funct field encodings for R-type
    parameter FUNCT_ADD = 6'b100000,
               FUNCT_SUB = 6'b100010,
               FUNCT_AND = 6'b100100,
               FUNCT_OR  = 6'b100101,
               FUNCT_SLT = 6'b101010;
    
    always @(*) begin
        case (aluop)
            ALUOP_LWSW: select = ALU_ADD; // lw, sw
            ALUOP_BEQ : select = ALU_SUB; // beq
            ALUOP_RTYPE: begin
                case (funct)
                    FUNCT_ADD: select = ALU_ADD;
                    FUNCT_SUB: select = ALU_SUB;
                    FUNCT_AND: select = ALU_AND;
                    FUNCT_OR : select = ALU_OR;
                    FUNCT_SLT: select = ALU_SLT;
                    default  : select = ALU_X;
                endcase
            end
            default: select = ALU_X;
        endcase
    end
    
    
endmodule
