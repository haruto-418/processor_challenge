// 即値の符号拡張等は未実装

module decoder_ver3(
  input [31:0] iword,

  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg [3:0] rd,
  output reg [6:0] opcode,
  output reg [2:0] funct3,
  output reg [6:0] funct7,
  output reg [31:0] imm
);

  always @(iword) begin
    opcode = iword[6:0];
    rd = iword[11:7];
    funct3 = iword[14:12];
    funct7 = iword[31:25];

    case(opcode)
      // 算術論理演算命令
      7'b0110111: imm = iword[31:12];  // LUI (LOAD UPPER IMMEDIATE)
      7'b0010111: imm = iword[31:12];  // AUIPC (ADD UPPER IMMEDIATE TO PC)
      7'b0010011: begin
        case(funct3)
          3'b000: imm = iword[31:20];  // ADDI (ADDITION IMMEDIATE)
          3'b010: imm = iword[31:20];  // SLTI (SET LESS THAN IMMEDIATE)
          3'b011: imm = iword[31:20];  // SLTIU (SET LESS THAN IMMEDIATE UNSIGNED)
          3'b100: imm = iword[31:20];  // XORI (EXCLUSIVE OR IMMEDIATE)
          3'b110: imm = iword[31:20];  // ORI (OR IMMEDIATE)
          3'b111: imm = iword[31:20];  // ANDI (AND IMMEDIATE)
          3'b001: imm = iword[24:20];  // SLLI (SHIFT LEFT LOGICAL IMMEDIATE)
          3'b101: begin
            case(funct7)
              7'b0000000: imm = iword[24:20];  // SRLI (SHIFT RIGHT LOGICAL IMMEDIATE)
              7'b0100000: imm = iword[24:20];  // SRAI (SHIFT RIGHT ARITHMETIC IMMEDIATE)
            endcase
          end
        endcase
      end

      // 制御命令
      7'b1101111: // JAL (JUMP AND LINK)
      7'b1100111: // JALR (JUMP AND LINK REGISTER)
      7'b1100011: begin
        case(funct3)
          3'b000: // BEQ (BRANCH EQUAL)
          3'b001: // BNE (BRANCH NOT EQUAL)
          3'b100: // BLT (BRANCH LESS THAN)
          3'b101: // BGE (BRANCH GREATER THAN OR EQUAL)
          3'b110: // BLTU (BRANCH LESS THAN UNSIGNED)
          3'b111: // BGEU (BRANCH GREATER THAN OR EQUAL UNSIGNED)
        endcase
      end

      // データ転送命令
      7'b0000011: begin
        case(funct3)
          3'b000: imm = iword[31:20];  // LB (LOAD BYTE)
          3'b001: imm = iword[31:20];  // LH (LOAD HALFWORD)
          3'b010: imm = iword[31:20];  // LW (LOAD WORD)
          3'b100: imm = iword[31:20];  // LBU (LOAD BYTE UNSIGNED)
          3'b101: imm = iword[31:20];  // LHU (LOAD HALFWORD UNSIGNED)
        endcase
      end
      7'b0100011: begin
        case(funct3)
          3'b000: imm = {20'b0, iword[31:25], iword[11:7]};  // SB (STORE BYTE)
          3'b001: imm = {20'b0, iword[31:25], iword[11:7]};  // SH (STORE HALFWORD)
          3'b010: imm = {20'b0, iword[31:25], iword[11:7]};  // SW (STORE WORD)
        endcase
      end
    endcase
  end

endmodule
