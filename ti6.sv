module immgen(input [31:0] instr, 
    output logic [31:0] imm, 
    output logic valid, 
    output logic [2:0] type);


wire [6:0]opcode;
wire [31:0]zhong;
logic [11:0] immb;

assign zhong = instr;
assign opcode = zhong[6:0];

always@(*)begin
    case(opcode)
        7'b0010011, 7'b0000011:begin
            valid = 1;
            imm = {{20{zhong[31]}},zhong[31:20]};
            type = 3'd1;
        end
        7'b0100011:begin
            valid = 1;
            imm = {{20{zhong[31]}},zhong[31:25],zhong[11:7]};
            type = 3'd2;
        end
        7'b1100011:begin
            valid = 1;
            immb = {zhong[12],zhong[10:5],zhong[4:1],zhong[11],{0}};
            imm = {{19{zhong[31]}},immb};
            type = 3'd3;
        end
        7'b0110111, 7'b0010111:begin
            valid = 1;
            imm = {zhong[31:12],{12{0}}};
            type = 3'd4;
        end
        7'b1101111:begin
            valid = 1;
            imm = {{11{zhong[31]}},zhong[20],zhong[10:1],zhong[11],zhong[19:12],{0}};
            type = 3'd5;
        end
        default:begin
            valid = 0;
            type = 0;
            imm =0 ;

    endcase
end
endmodule
