// 题 07｜模块：ALU
// RV32I 算术/逻辑/移位/比较 运算单元

module alu(
    input  logic [31:0] a, b,
    input  logic [4:0]  op,
    output logic [31:0] y,
    output logic        cmp_taken
);

always @(*) begin
    // 默认值防止锁存器
    y          = 32'b0;
    cmp_taken  = 1'b0;

    unique case (op)

        // 算术类
        5'd1: y = a + b;                             // ADD
        5'd2: y = a - b;                             // SUB

        // 逻辑类
        5'd3: y = a & b;                             // AND
        5'd4: y = a | b;                             // OR
        5'd5: y = a ^ b;                             // XOR

        // 移位类
        5'd6: y = a << b[4:0];                       // SLL (逻辑左移)
        5'd7: y = a >> b[4:0];                       // SRL (逻辑右移)
        5'd8: y = $signed(a) >>> b[4:0];             // SRA (算术右移)

        // 比较类
        5'd9:  y = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT (有符号)
        5'd10: y = (a < b) ? 32'd1 : 32'd0;                   // SLTU (无符号)

        // 分支比较输出
        5'd11: cmp_taken = (a == b);                 // BEQ
        5'd12: cmp_taken = (a != b);                 // BNE
        5'd13: cmp_taken = ($signed(a) < $signed(b)); // BLT

        default: begin
            y = 32'b0;
            cmp_taken = 1'b0;
        end
    endcase
end

endmodule
