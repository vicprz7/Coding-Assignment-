`timescale 1ns / 1ps

module mips_pipeline(
    input wire clk,
    input wire rst
);

    // IF/ID wires
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    // ID/EX wires
    wire [1:0]  id_ex_wb;
    wire [2:0]  id_ex_mem;
    wire [3:0]  id_ex_execute;

    wire [31:0] id_ex_npc;
    wire [31:0] id_ex_readdat1;
    wire [31:0] id_ex_readdat2;
    wire [31:0] id_ex_sign_ext;

    wire [4:0] id_ex_instr_bits_20_16;
    wire [4:0] id_ex_instr_bits_15_11;

    // EX/MEM wires
    wire [1:0]  ex_mem_wb;
    wire        ex_mem_branch;
    wire        ex_mem_memread;
    wire        ex_mem_memwrite;

    wire [31:0] ex_mem_npc;
    wire        ex_mem_zero;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rdata2;
    wire [4:0]  ex_mem_write_reg;

    // MEM/WB wires
    wire        mem_pcsrc;
    wire        mem_wb_regwrite;
    wire        mem_wb_memtoreg;

    wire [31:0] mem_wb_read_data;
    wire [31:0] mem_wb_alu_result;
    wire [4:0]  mem_wb_write_reg;

    // WB wire
    wire [31:0] wb_write_data;

    // 1. Instruction Fetch
    fetch IF_STAGE (
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(mem_pcsrc),
        .ex_mem_npc(ex_mem_npc),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );

    // 2. Decode 
    decode ID_STAGE (
        .clk(clk),
        .rst(rst),
        .wb_reg_write(mem_wb_regwrite),
        .wb_write_reg_location(mem_wb_write_reg),
        .mem_wb_write_data(wb_write_data),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc),
        .id_ex_wb(id_ex_wb),
        .id_ex_mem(id_ex_mem),
        .id_ex_execute(id_ex_execute),
        .id_ex_npc(id_ex_npc),
        .id_ex_readdat1(id_ex_readdat1),
        .id_ex_readdat2(id_ex_readdat2),
        .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
    );

    // 3. Execute 
    execute EX_STAGE (
        .clk(clk),
        .wb_ctl(id_ex_wb),
        .m_ctl(id_ex_mem),
        .regdst(id_ex_execute[3]),
        .alusrc(id_ex_execute[0]),
        .aluop(id_ex_execute[2:1]),
        .npcout(id_ex_npc),
        .rdata1(id_ex_readdat1),
        .rdata2(id_ex_readdat2),
        .s_extendout(id_ex_sign_ext),
        .instrout_2016(id_ex_instr_bits_20_16),
        .instrout_1511(id_ex_instr_bits_15_11),
        .wb_ctlout(ex_mem_wb),
        .branch(ex_mem_branch),
        .memread(ex_mem_memread),
        .memwrite(ex_mem_memwrite),
        .EX_MEM_NPC(ex_mem_npc),
        .zero(ex_mem_zero),
        .alu_result(ex_mem_alu_result),
        .rdata2out(ex_mem_rdata2),
        .five_bit_muxout(ex_mem_write_reg)
    );

    // 4. Memory
    mem_stage MEM_STAGE (
        .clk(clk),
        .wb_ctlout(ex_mem_wb),
        .branch(ex_mem_branch),
        .memread(ex_mem_memread),
        .memwrite(ex_mem_memwrite),
        .zero(ex_mem_zero),
        .alu_result(ex_mem_alu_result),
        .rdata2out(ex_mem_rdata2),
        .five_bit_muxout(ex_mem_write_reg),
        .MEM_PCSrc(mem_pcsrc),
        .MEM_WB_regwrite(mem_wb_regwrite),
        .MEM_WB_memtoreg(mem_wb_memtoreg),
        .read_data(mem_wb_read_data),
        .mem_alu_result(mem_wb_alu_result),
        .mem_write_reg(mem_wb_write_reg)
    );

    // 5. Write Back
    wb_mux WB_STAGE (
        .memtoreg(mem_wb_memtoreg),
        .read_data(mem_wb_read_data),
        .mem_alu_result(mem_wb_alu_result),
        .writeback_data(wb_write_data)
    );

endmodule
