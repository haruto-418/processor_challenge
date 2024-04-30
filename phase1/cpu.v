module cpu(
  input wire clk, // クロック信号
  input wire rst, // リセット信号
  output wire[31:0] result
);
  reg [7:0]mem[0:255];
  reg [7:0] instruction;
  reg [31:0] alu_operand_a;
  reg [31:0] alu_operand_b;
  wire [31:0] alu_result;
  reg [7:0] pc;

  assign result = alu_result;

  always @(posedge clk) begin
    if(rst) begin // リセット処理
      pc <= 8'b00000000;
      alu_operand_a <= 32'b0;
      alu_operand_b <= 32'b0;
    end else begin // リセットしないで命令実行
      instruction <= mem[pc];
      pc <= pc + 8'b00000001;

      alu_operand_a <= {24'b0, instruction};
      alu_operand_b <= {24'b0, instruction} + 32'b1;
    end
  end

  assign alu_result = alu_operand_a + alu_operand_b;

endmodule