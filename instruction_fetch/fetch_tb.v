'timescale 1ns / 1ps

module fetch_tb;

    reg clk;
    reg rst;
    reg ex_mem_pc_src;
    reg  [31:0] ex_mem_npc;

    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    fetch uut (
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(ex_mem_pc_src),
        .ex_mem_npc(ex_mem_npc),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin

        rst           = 1'b1;
        ex_mem_pc_src = 1'b0;
        ex_mem_npc    = 32'h00000000;


        #12;
        rst = 1'b0;

        // Does all 10 cycle
        #100;


        // Reset
        rst = 1'b1;
        ex_mem_pc_src = 1'b0;
        ex_mem_npc    = 32'h00000000;
        #10;

        rst = 1'b0;

        // Let fetch run normally 
        #30;


        // Redirect to address 28
        ex_mem_pc_src = 1'b1;
        ex_mem_npc    = 32'h0000001c;
        #10;

        // Back to normal
        ex_mem_pc_src = 1'b0;
        #20;



        $finish;
    end

endmodule
