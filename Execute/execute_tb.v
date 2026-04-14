module execute_tb;
    reg clk;
    reg [1:0] wb_ctl;
    reg [2:0] m_ctl;
    reg [31:0] npcout, rdata1, rdata2, s_extendout;
    reg [4:0] instrout_2016, instrout_1511;
    reg [1:0] aluop;
    reg alusrc, regdst;

    wire [1:0] wb_ctlout;
    wire branch, memread, memwrite;
    wire [31:0] EX_MEM_NPC, alu_result, rdata2out;
    wire zero;
    wire [4:0] five_bit_muxout;

    execute uut (
        .clk(clk),
        .wb_ctl(wb_ctl),
        .m_ctl(m_ctl),
        .regdst(regdst),
        .alusrc(alusrc),
        .aluop(aluop),
        .npcout(npcout),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extendout(s_extendout),
        .instrout_2016(instrout_2016),
        .instrout_1511(instrout_1511),
        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .EX_MEM_NPC(EX_MEM_NPC),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        wb_ctl = 2'b10;
        m_ctl = 3'b101;
        npcout = 32'd100;
        rdata1 = 32'd10;
        rdata2 = 32'd20;
        s_extendout = 32'd4;
        instrout_2016 = 5'd5;
        instrout_1511 = 5'd10;
        aluop = 2'b10;
        alusrc = 1;
        regdst = 1;

        #15;

        alusrc = 0;
        regdst = 0;
        s_extendout = 32'd8;
        aluop = 2'b01;

        #15;

        $stop;
    end
endmodule
