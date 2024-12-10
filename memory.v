module memory(
    input          clk_i,
    input          wen_i,
    input [31:0]   addr_i,
    input [31:0]   data_i,
    input [31:0]   data_o
);

reg [31:0] mem [511:0];

assign data_o = mem[addr_i[31:2]];

always @(posedge clk_i) begin
    if (wen_i) begin
        mem[addr_i[31:2]] <= data_i;
    end
end


endmodule