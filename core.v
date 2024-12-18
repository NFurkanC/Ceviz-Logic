module core (
    input           clk_i,
    input           rst_i,
    input [31:0]    inst_i,
    output [31:0]   inst_addr_o,
);

fetch f1 (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_o(inst_addr_o),
);

wire [31:0] fd2d_inst;

fd_regs fd1 (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inst_f_i(inst_i),
    .inst_d_o(fd2d_inst)
);

wire c2d_regfile_wen;
wire [2:0] c2d_imm_ext_sel;
wire [31:0] w2d_result;
wire [31:0] d2a_reg_a;
wire [31:0] d2a_reg_b;
wire [31:0] d2a_imm_ext;

decode d1 (
    .clk_i(clk_i),
    .regfile_wen_i(c2d_regfile_wen),
    .imm_ext_sel_i(c2d_imm_ext_sel),
    .inst_i(fd2d_inst),
    .result_i(w2d_result),
    .reg_a_o(d2a_reg_a),
    .reg_b_o(d2a_reg_b),
    .imm_ext_o(d2a_imm_ext)
);

wire c2a_alu_sel;
wire [3:0] c2a_alu_fun;
wire [31:0] a2w_alu_out;

alu a1(
    .alu_sel_i(c2a_alu_sel),
    .alu_fun_i(c2a_alu_fun),
    .reg_a_i(d2a_reg_a),
    .reg_b_i(d2a_reg_b),
    .imm_ext_i(d2a_imm_ext),
    .alu_out_o(a2w_alu_out)
);

writeback w1(
    .alu_out_i(a2w_alu_out),
    .result_o(w2d_result)
);

controller c1(
    .inst_i(fd2d_inst),
    .regfile_wen_o(c2d_regfile_wen),
    .imm_ext_sel_o(c2d_imm_ext_sel),
    .alu_sel_o(c2a_alu_sel),
    .alu_fun_o(c2a_alu_fun)
);
    
endmodule