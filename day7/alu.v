module alu(
  input wire [31:0] oprl,
  input wire [31:0] oprr,
  input wire [31:0] pc,
  input wire [3:0] func_code,

  output reg [31:0] result
);
  always @(func_code) begin
    case(func_code)
      6'b000000: result <= oprr[31:0] // LUI
      6'b000001: pc + oprr[31:0] // AUIPC
      6'b000010: oprl + oprr // ADDI
      6'b000011: // SLTI
      6'b000100: // SLTIU
      6'b000101: // XORI
      6'b000110: // ORI
      6'b000111: // ANDI
      6'b001000: // SLLI
      6'b001001: // SRLI
      6'b001010: // SRAI
      6'b001011: // ADD
      6'b001100: // SUB
      6'b001101: // SLL
      6'b001110: // SLT
      6'b001111: // SLTU
      6'b010000: // XOR
      6'b010001: // SRL
      6'b010010: // SRA
      6'b010011: // OR
      6'b010100: // AND
      6'b010101: // JAL
      6'b010110: // JALR
      6'b010111: // BEQ
      6'b011000: // BNE
      6'b011001: // BLT
      6'b011010: // BGE
      6'b011011: // BLTU
      6'b011100: // BGEU
      6'b011101: // LB
      6'b011110: // LH
      6'b011111: // LW
      6'b100000: // LBU
      6'b100001: // LHU
      6'b100010: // SB
      6'b100011: // SH
      6'b100100: // SW
    endcase
  end
endmodule