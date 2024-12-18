module fetch (
    input               clk_i,
    input               rst_i,
    output reg [31:0]   pc_o,
);
    always @(posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            pc_o <= 32'h00000000;
        end
        else begin
            pc_o <= pc_o + 4;
        end
    end
endmodule

module fd_regs (
    input               clk_i,
    input               rst_i,
    input [31:0]        inst_f_i,
    output reg[31:0]    inst_d_o,
);

always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
        inst_d_o <= 32'b0;
    end
    else begin
        inst_d_o <= inst_f_i;
    end
end
    
endmodule

module decode (
    input               clk_i,
    input               regfile_wen_i,
    input [2:0]         imm_ext_sel_i,
    input [31:0]        inst_i,
    input [31:0]        result_i,
    output [31:0]       reg_a_o,
    output  [31:0]      reg_b_o,
    output reg [31:0]   imm_ext_o,
);

reg[31:0] regfile [31:0];

wire [4:0] reg_a_addr = inst_i[19:15];
wire [4:0] reg_b_addr = inst_i[24:20];
wire [4:0] target_reg_addr = inst_i[11:7];

assign reg_a_o = (reg_a_addr == 5'b0) ? 32'b0 : regfile[reg_a_addr];
assign reg_b_o = (reg_b_addr == 5'b0) ? 32'b0 : regfile[reg_b_addr];

always @(posedge clk_i) begin
    if(regfile_wen_i) begin
        regfile[target_reg_addr] <= result_i;
    end
end

always @(*) begin
    case (imm_ext_sel_i)
        3'b0000 : imm_ext_o = {{20{inst_i[31]}}, inst_i[31:20]}; 
        default : imm_ext_o = 32'b0;
    endcase
end
endmodule

module writeback (
    input [31:0]    alu_out_i,
    output [31:0]   result_o,
);

assign result_o = alu_out_i;
//WB modulu sonrasinda genisletilecek!
    
endmodule

