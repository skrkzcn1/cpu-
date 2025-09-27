module regfile (
  input         clk,
  input         we,
  input  [4:0]  wa, ra1, ra2,
  input  [31:0] wd,
  output [31:0] rd1, rd2
);

  reg [31:0] cunchu [0:31];

  // 同步写：忽略 x0
  always @(posedge clk) begin
    if (we && (wa != 0)) begin
      cunchu[wa] <= wd;
    end
  end

  // 组合读 + 写优先旁路
  assign rd1 = (ra1 == 0) ? 32'b0 :
               ((we && (wa == ra1) && (wa != 0)) ? wd : cunchu[ra1]);

  assign rd2 = (ra2 == 0) ? 32'b0 :
               ((we && (wa == ra2) && (wa != 0)) ? wd : cunchu[ra2]);

endmodule


always @(posedge clk) begin
  assert (!(we && wa==0)) else $error("禁止写x0");
end

property write_read_bypass;
  @(posedge clk) (we && wa==ra1) |-> (rd1 == wd);
endproperty

assert property (write_read_bypass);
  
always @(posedge clk) begin
  assert (!(we && ra1==ra2 && ra1==wa && wa!=0))
    else $warning("两个读口同时读写同一寄存器");
end


