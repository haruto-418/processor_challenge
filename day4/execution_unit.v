module execution_unit(
  input wire[31:0] oprl,
  input wire[31:0] oprr,
  input wire[31:0] pc,
  input wire[4:0] func_code, // とりあえず算術演算命令のみに対応したいから、識別は5bitで十分。

  output wire[31:0] result
);
// とりあえずRISC-Vの仕様書に登場する順番に算術演算命令を符号化する。
  case(func_code)
    5'b00000: // LUI
    5'b00001: // AUIPC
    5'b000010: // ADDI
    5'b000011: // SLTI
    5'b000100: // SLTUI
    5'b000101: // XORI
    5'b000110: // ORI
    5'b000111: // ANDI
    5'b001000: // SLLI
    5'b001001: // SRLI
    5'b001010: // SRAI
    5'b001011: // ADD
    5'b001100: // SUB
    5'b001101: // SLL
    5'b001110: // SLT
    5'b001111: // SLTU
    5'b010000: // XOR
    5'b010001: // SRL
    5'b010010: // SRA
    5'b010011: // OR
    5'b010100: // AND
  endcase
endmodule