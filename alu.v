module alu (
    input               alu_sel_i,
    input [3:0]         alu_fun_i,
    input [31:0]        reg_a_i,
    input [31:0]        reg_b_i,
    input [31:0]        imm_ext_i,
    output reg [31:0]   alu_out_o,
); 

wire signed [31:0] alu_a = reg_a_i;
wire signed [31:0] alu_b = alu_sel_i ? imm_ext_i : reg_b_i;

always @(*) begin
    case(alu_fun_i)
        4'b0000 : alu_out_o = alu_a + alu_b;
        4'b0001 : alu_out_o = alu_a - alu_b;
        4'b0010 : alu_out_o = alu_a & alu_b;
        4'b0011 : alu_out_o = alu_a ^ alu_b;
        4'b0100 : alu_out_o = alu_a | alu_b;
        default : alu_out_o = 32'bx;
    endcase
end

endmodule