`timescale 1ns / 1ps

module memory_tb();
    reg clk;
    reg [31:0] ALUResult, WriteData;
    reg [4:0] WriteReg;
    reg [1:0] WBControl;
    reg MemWrite, MemRead, Branch, Zero;

    wire [31:0] ReadData;
    wire [31:0] ALUResult_out;
    wire [4:0]  WriteReg_out;
    wire RegWrite_out, MemtoReg_out;
    wire PCSrc;
    wire [31:0] WriteBackData;

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

    wb_mux wb_mux_uut (
        .memtoreg(MemtoReg_out),
        .read_data(ReadData),
        .mem_alu_result(ALUResult_out),
        .writeback_data(WriteBackData)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // -------- CASE 1: LOAD-LIKE TEST --------
        // Address 0x10 = decimal 16 -> DMEM[4] when using addr[31:2]
        ALUResult = 32'h00000004;
        WriteData = 32'h12345678;
        WriteReg  = 5'd2;
        WBControl = 2'b11;   // RegWrite=1, MemtoReg=1
        MemWrite  = 0;
        MemRead   = 1;
        Branch    = 0;
        Zero      = 0;

        @(negedge clk);

        // -------- CASE 2: STORE TEST --------
        //
        MemWrite = 1;
        MemRead  = 0;

        @(negedge clk);

        // -------- CASE 3: READ BACK --------
        MemWrite = 0;
        MemRead  = 1;

        @(negedge clk);

        // -------- CASE 4: BRANCH TAKEN --------
        Branch = 1;
        Zero   = 1;

        @(negedge clk);

        // -------- CASE 5: ALU WRITEBACK TEST --------
        // Now test WB mux selecting ALU result instead of memory
        Branch    = 0;
        Zero      = 0;
        MemWrite  = 0;
        MemRead   = 0;
        ALUResult = 32'h00000005;
        WriteReg  = 5'd3;
        WBControl = 2'b10;   // RegWrite=1, MemtoReg=0

        @(negedge clk);

        $finish;
    end

endmodule
