module operand_switcher(
  input wire[31:0] iword,
  input wire[31:0] regdata1, regdata2,

  output wire[31:0] oprl, oprr
);
  reg[2:0] oprr_type;
  // *-- oppr_type --*
  // 3'b000: 即値なし or 即値複雑すぎて無理
  // 3'b001: I-typeの12bit即値
  // 3'b010: U-typeの20bit即値
  // 3'b011: S-typeの12bit即値
  // 3'b100: I-typeの5bit即値

  assign wire oprl = regdata1;

  // 演算の種類に応じてoprr_typeを取得
  case(iword[6:0])
    7'b0110111: oprr_type = 3'b010; // LUI (LOAD UPPER IMMEDIATE)
    7'b0010111: oprr_type = 3'b010; // AUIPC (ADD UPPER IMMEDIATE TO PC)
    7'b1101111: oprr_type = 3'b000; // JAL (JUMP AND LINK)
    7'b1100111: oprr_type = 3'b000; // JALR (JUMP AND LINK REGISTER)
    7'b1100011: oprr_type = 3'b000; // BRANCH
    7'b0000011: oprr_type = 3'b001; // LOAD
    7'b0100011: oprr_type = 3'b100; // STORE
    7'b0010011: begin
      case(iword[14:12])
        // しばらくI-typeの12bit即値
        3'b000: oprr_type = 3'b001; // ADDI (ADDITION IMMEDIATE)
        3'b010: oprr_type = 3'b001; // SLTI (SET LESS THAN IMMEDIATE)
        3'b011: oprr_type = 3'b001; // SLTIU (SET LESS THAN IMMEDIATE UNSIGNED)
        3'b100: oprr_type = 3'b001; // XORI (EXCLUSIVE OR IMMEDIATE)
        3'b110: oprr_type = 3'b001; // ORI (OR IMMEDIATE)
        3'b111: oprr_type = 3'b001; // ANDI (AND IMMEDIATE)
        // I-typeの5bit即値
        3'b001: oprr_type = 3'b100; // SLLI (SHIFT LEFT LOGICAL IMMEDIATE)
        3'b101: oprr_type = 3'b100; // SRLI, SRAI
      endcase
    end
    7'b0110011: oprr_type = 3'b000; // ここはR-type（全てのオペランドがレジスタから取得される）
  endcase
endmodule