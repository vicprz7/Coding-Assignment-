    `timescale 1ns / 1ps
    
    module wb_mux(
        input  wire        memtoreg,
        input  wire [31:0] read_data,
        input  wire [31:0] mem_alu_result,
        output wire [31:0] writeback_data
    );
    
        assign writeback_data = (memtoreg) ? read_data : mem_alu_result;
    
    endmodule
