module decoder_ver2(
  input[31:0] iword,
  
  output reg[4:0] rs1,
  output reg[4:0] rs2,
  output reg[4:0] rd,
  output reg[6:0] opcode,
  output reg[2:0] funct3,
  output reg[6:0] funct7,

  // 算術論理演算命令
  output reg LUI,
  output reg AUIPC,
  output reg ADDI,
  output reg SLTI,
  output reg SLTIU,
  output reg XORI,
  output reg ORI,
  output reg ANDI,
  output reg SLLI,
  output reg SRLI,
  output reg SRAI,
  output reg ADD,
  output reg SUB,
  output reg SLL,
  output reg SLT,
  output reg SLTU,
  output reg XOR,
  output reg SRL,
  output reg SRA,
  output reg OR,
  output reg AND,

  // 制御命令
  output reg JAL,
  output reg JALR,
  output reg BEQ,
  output reg BNE,
  output reg BLT,
  output reg BGE,
  output reg BLTU,
  output reg BGEU,

  // データ転送命令
  output reg LB,
  output reg LH,
  output reg LW,
  output reg LBU,
  output reg LHU,
  output reg SB,
  output reg SH,
  output reg SW,

  // システム命令は省略
);
  always @(iword) begin
    reg[7:0] opcode = iword[6:0];
    reg[2:0] funct3 = iword[14:12];
    reg[6:0] funct7 = iword[31:25];

    case(opcode)
    // 算術論理演算命令
      7'b0110111: LUI = 1;
      7'b0010111: AUIPC = 1;
      7'b0010011: ADDi = 1;
      7'b0010011:begin
        case(funct3)
          3'b000: ADDI = 1;
          3'b010: SLTI = 1;
          3'b011: SLTIU = 1;
          3'b100: XORI = 1;
          3'b110: ORI = 1;
          3'b111: ANDI = 1;
          3'b001: SLLI = 1;
          3'b101: begin
            reg[6:0] funct7 = iword[31:25];
            case(funct7)
              7'b0000000: SRLI = 1;
              7'b0100000: SRAI = 1;
            endcase
          end
        endcase
      end
      7'b0110011: begin
        case(funct3)
          3'b000: begin
            funct7 = iword[31:25];
            case(funct7)
              7'0000000: ADD = 1;
              7'b0100000: SUB = 1;
            endcase
          end
          3'b001: SLL = 1;
          3'b010: SLT = 1;
          3'b011: SLTU = 1;
          3'b100: XOR = 1;
          3'b101: begin
            funct7 = iword[31:25];
            case(funct7)
              7'0000000: SRL = 1;
              7'b0100000: SRA = 1;
            endcase
          end
          3'b110: OR = 1;
          3'b111: AND = 1;
        endcase
      end

      // 制御命令
      7'b1101111: JAL = 1;
      7'b1100111: JALR = 1;
      7'b1100011: begin
        case(funct3)
          3'b000: BEQ = 1; // BRANCH on EQUAL
          3'b001: BNE = 1; // BRANCH on NOT EQUAL
          3'b100: BLT = 1; // BRANCH on LESS THAN
          3'b101: BGE = 1; // BRANCH on GREATER THAN or EQUAL
          3'b110: BLTU = 1; // BRANCH on LESS THAN UNSIGNED
          3'b111: BGEU = 1; // BRANCH on GREATER THAN or EQUAL UNSIGNED
        endcase
      end

      // データ転送命令
      7'b0000011: begin
        case(funct3)
          3'b000: LB = 1;
          3'b001: LH = 1;
          3'b010: LW = 1;
          3'b100: LBU = 1;
          3'b101: LHU = 1;
        endcase
      end
      7'b0100011:begin
        case(funct3)
          3'b000: SB = 1;
          3'b001: SH = 1;
          3'b010: SW = 1;
        endcase
      end
    endcase
  end
endmodule