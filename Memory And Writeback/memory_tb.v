`timescale 1ns / 1ps

module memory_tb();
    reg clk;
    reg [31:0] ALUResult, WriteData;
    reg [4:0] WriteReg;
    reg [1:0] WBControl;
    reg MemWrite, MemRead, Branch, Zero;

    wire [31:0] ReadData, ALUResult_out;
    wire [4:0] WriteReg_out;
    wire RegWrite_out, MemtoReg_out;
    wire PCSrc;

    mem_stage uut (
        .clk(clk),
        .wb_ctlout(WBControl),
        .branch(Branch),
        .memread(MemRead),
        .memwrite(MemWrite),
        .zero(Zero),
        .alu_result(ALUResult),
        .rdata2out(WriteData),
        .five_bit_muxout(WriteReg),
        .MEM_PCSrc(PCSrc),
        .MEM_WB_regwrite(RegWrite_out),
        .MEM_WB_memtoreg(MemtoReg_out),
        .read_data(ReadData),
        .mem_alu_result(ALUResult_out),
        .mem_write_reg(WriteReg_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initial values
        ALUResult = 32'h00000010;   // address 4
        WriteData = 32'h12345678;
        WriteReg  = 5'h02;
        WBControl = 2'b11;          // RegWrite=0, MemtoReg=1 with your current bit mapping
        MemWrite  = 0;
        MemRead   = 1;
        Branch    = 0;
        Zero      = 0;

        #10;

        // Mem Write
        MemWrite = 1;
        MemRead  = 0;
        #10;

        // Read back written value
        MemWrite = 0;
        MemRead  = 1;
        #10;

        // Branch test
        Branch = 1;
        Zero   = 1;
        #10;

        $finish;
    end
endmodule

