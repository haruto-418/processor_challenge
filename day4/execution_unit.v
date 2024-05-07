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
    5'b00010: // ADDI
    5'b00011: // SLTI
    5'b00100: // SLTUI
    5'b00101: // XORI
    5'b00110: // ORI
    5'b00111: // ANDI
    5'b01000: // SLLI
    5'b01001: // SRLI
    5'b01010: // SRAI
    5'b01011: // ADD
    5'b01100: // SUB
    5'b01101: // SLL
    5'b01110: // SLT
    5'b01111: // SLTU
    5'b10000: // XOR
    5'b10001: // SRL
    5'b10010: // SRA
    5'b10011: // OR
    5'b10100: // AND
  endcase
endmodule