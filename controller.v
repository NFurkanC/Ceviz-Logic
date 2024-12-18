module controller (
    input [31:0]        inst_i,
    output              regfile_wen_o,
    output [2:0]        imm_ext_sel_o,
    output              alu_sel_o,
    output reg [3:0]    alu_fun_o,
);

wire [6:0] opcode = inst_i[6:0];
wire [2:0] funct3 = inst_i[14:12];
wire [6:0] funct7 = inst_i[31:25];

wire [1:0] alu_dec;

reg [6:0] control_signals;
assign {regfile_wen_o, imm_ext_sel_o, alu_sel_o, alu_dec} = control_signals;

always @(*) begin
    case(opcode)
        7'b0110011 : control_signals = 7'b1_xxx_0_11; //RTYPE
        7'b0010011 : control_signals = 7'b1_000_1_11; //ITYPE
        7'b0000000 : control_signals = 7'b0000000;    //ZERO
        default    : control_signals = 7'x_xxx_x_xx;  //Invalid
    endcase
end
    
wire sub = opcode[5] & funct7[5];

always @(*) begin
    case (alu_dec)
    2'b11 : 
        case (funct3)
            3'b000 : 
                if(sub) begin
                    alu_fun_o = 4'b0001;
                end
                else begin
                    alu_fun_o = 4'b0000;
                end
            3'b100  : alu_fun_o = 4'b0011; //xor, xori
            3'b110  : alu_fun_o = 4'b0100; //or, ori
            3'b111  : alu_fun_o = 4'b0010; //and, andi
            default : alu_fun_o = 4'b0000;
        endcase
        default : alu_fun_o = 4'b0000;
endcase
end
endmodule