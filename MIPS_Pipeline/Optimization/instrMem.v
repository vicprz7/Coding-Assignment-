module instrMem(
    input  wire        clk,   
    input  wire        rst,   
    input  wire [31:0] addr,
    output reg  [31:0] data
);

    reg [31:0] mem [0:63];

    initial begin
        mem[0]  = 32'b100011_00000_00001_0000_0000_0000_0001; // LW  r1, 1(r0)
        mem[1]  = 32'b100011_00000_00010_0000_0000_0000_0010; // LW  r2, 2(r0)
        mem[2]  = 32'b100011_00000_00011_0000_0000_0000_0011; // LW  r3, 3(r0)
    
        // Independent instructions 
        mem[3]  = 32'b000000_00000_00000_00100_00000_100000; // ADD r4, r0, r0
        mem[4]  = 32'b000000_00000_00000_00101_00000_100000; // ADD r5, r0, r0
        mem[5]  = 32'b000000_00000_00000_00110_00000_100000; // ADD r6, r0, r0
    
        
        mem[6]  = 32'b000000_00001_00010_00001_00000_100000; // ADD r1, r1, r2 // r1 = r1 + r2 = 1 + 2 = 3
    
        // Independent instructions 
        mem[7]  = 32'b000000_00000_00000_00111_00000_100000; // ADD r7, r0, r0
        mem[8]  = 32'b000000_00000_00000_01000_00000_100000; // ADD r8, r0, r0
        mem[9]  = 32'b000000_00000_00000_01001_00000_100000; // ADD r9, r0, r0
    
        
        mem[10] = 32'b000000_00001_00011_00001_00000_100000; // ADD r1, r1, r3  // r1 = r1 + r3 = 3 + 3 = 6
    
        // Independent instructions replacing NOPs
        mem[11] = 32'b000000_00000_00000_01010_00000_100000; // ADD r10, r0, r0
        mem[12] = 32'b000000_00000_00000_01011_00000_100000; // ADD r11, r0, r0
        mem[13] = 32'b000000_00000_00000_01100_00000_100000; // ADD r12, r0, r0
    
        
        mem[14] = 32'b000000_00001_00001_00001_00000_100000; // ADD r1, r1, r1 // r1 = r1 + r1 = 6 + 6 = 12
    
        // Independent instructions 
        mem[15] = 32'b000000_00000_00000_01101_00000_100000; // ADD r13, r0, r0
        mem[16] = 32'b000000_00000_00000_01110_00000_100000; // ADD r14, r0, r0
        mem[17] = 32'b000000_00000_00000_01111_00000_100000; // ADD r15, r0, r0
    
        
        mem[18] = 32'b000000_00001_00000_00001_00000_100000; // ADD r1, r1, r0 // r1 = r1 + r0 = 12 + 0 = 12
    end

    always @(*) begin
        case (addr)
            32'd0  : data = mem[0];
            32'd4  : data = mem[1];
            32'd8  : data = mem[2];
            32'd12 : data = mem[3];
            32'd16 : data = mem[4];
            32'd20 : data = mem[5];
            32'd24 : data = mem[6];
            32'd28 : data = mem[7];
            32'd32 : data = mem[8];
            32'd36 : data = mem[9];
            32'd40 : data = mem[10];
            32'd44 : data = mem[11];
            32'd48 : data = mem[12];
            32'd52 : data = mem[13];
            32'd56 : data = mem[14];
            32'd60 : data = mem[15];
            32'd64 : data = mem[16];
            32'd68 : data = mem[17];
            32'd72 : data = mem[18];
            default: data = 32'h00000000;
        endcase
    end
endmodule
