module decoder_ver2(
  input[31:0] iword,
  
  output reg[4:0] rs1,
  output reg[4:0] rs2,
  output reg[3:0] rd,
  output reg[6:0] opcode,
  output reg[2:0] funct3,
  output reg[6:0] funct7,
  output reg imm,
);
  always @(iword) begin
    reg[7:0] opcode = iword[6:0];
    reg[3:0] rd = iword[11:7];
    reg[2:0] funct3 = iword[14:12];
    reg[6:0] funct7 = iword[31:25];

    case(opcode)
    // 算術論理演算命令
      7'b0110111: begin
        // LUI (LOAD UPPER IMMEDIATE)
        reg imm = iword[31:12];
      end
      7'b0010111: begin
        // AUIPC (ADD UPPER IMMEDIATE TO PC)
        reg imm = iword[31:12];
      end
      7'b0010011:begin
        case(funct3)
          3'b000: begin
            // ADDI (ADDITION IMMEDIATE)
            reg imm = iword[31:20];
          end
          3'b010: begin
            // SLTI (SET LESS THAN IMMEDIATE)
            reg imm = iword[31:20];
          end
          3'b011:begin
            // SLTIU (SET LESS THAN IMMEDIATE UNSIGNED)
            reg imm = iword[31:20];
          end
          3'b100: begin
            // XORI (EXCLUSIVE OR IMMEDIATE)
            reg imm = iword[31:20];
          end
          3'b110: begin
            // ORI (OR IMMEDIATE)
            reg imm = iword[31:20];
          end
          3'b111: begin
            // ANDI (AND IMMEDIATE)
            reg imm = iword[31:20];
          end
          3'b001: begin
            // SLLI (SHIFT LEFT LOGICAL IMMEDIATE)
            reg imm = iword[4:0];
          end
          3'b101: begin
            case(funct7)
              7'b0000000: begin
                // SRLI (SHIFT RIGHT LOGICAL IMMEDIATE)
                reg imm = iword[24:20];
              end
              7'b0100000: begin
                // SRAI (SHIFT RIGHT ARITHMETIC IMMEDIATE)
                reg imm = iword[24:20];
              end
            endcase
          end
        endcase
      end
      7'b0110011: begin
        case(funct3)
          3'b000: begin
            case(funct7)
              7'0000000: begin
                // ADD (ADDITION)
              end
              7'b0100000: begin
                // SUB (SUBTRACTION)
              end
            endcase
          end
          3'b001: begin
            // SLL (SHIFT LEFT LOGICAL)
          end
          3'b010: begin
            // SLT (SET LESS THAN)
          end
          3'b011: begin
            // SLTU (SET LESS THAN UNSIGNED)
          end
          3'b100: begin
            // XOR (EXCLUSIVE OR)
          end
          3'b101: begin
            case(funct7)
              7'0000000: begin
                // SRL (SHIFT RIGHT LOGICAL)
              end
              7'b0100000: begin
                // SRA (SHIFT RIGHT ARITHMETIC)
              end
            endcase
          end
          3'b110: begin
            // OR (OR)
          end
          3'b111: begin
            // AND (AND)
          end
        endcase
      end

      // 制御命令
      7'b1101111: begin
        // JAL (JUMP AND LINK)
        // JALの即値は意味がわからないから一旦後回し。
      end
      7'b1100111: begin
        // JALR (JUMP AND LINK REGISTER)
        reg imm = iword[31:20];
      end
      7'b1100011: begin
        case(funct3)
          3'b000: begin
            // (BEQ) BRANCH on EQUAL
            // BEQの即値も意味がわからないから後回し。
          end
          3'b001: begin
            // BNE (BRANCH on NOT EQUAL)
            // BNEの即値も意味がわからないから後回し。
          end
          3'b100: begin
            // BLT (BRANCH on LESS THAN)
            // BLTの即値も意味がわからないから後回し。
          end
          3'b101: begin
            // BGE (BRANCH on GREATER THAN or EQUAL)
            // BGEの即値も意味がわからないから後回し。
          end
          3'b110: begin
            // BLTU (BRANCH on LESS THAN UNSIGNED)
            // BLTUの即値も意味がわからないから後回し。
          end
          3'b111: begin
            // BGEU (BRANCH on GREATER THAN or EQUAL UNSIGNED)
            // BGEUの即値も意味がわからないから後回し。
          end
        endcase
      end

      // データ転送命令
      7'b0000011: begin
        case(funct3)
          3'b000: begin
            // LB (LOAD BYTE)
            reg imm = iword[31:20];
          end
          3'b001: begin
            // LH (LOAD HALFWORD)
            reg imm = iword[31:20];
          end
          3'b010: begin
            // LW (LOAD WORD)
            reg imm = iword[31:20];
          end
          3'b100: begin
            // LBU (LOAD BYTE UNSIGNED)
            reg imm = iword[31:20];
          end
          3'b101: begin
            // LHU (LOAD HALFWORD UNSIGNED)
            reg imm = iword[31:20];
          end
        endcase
      end
      7'b0100011:begin
        case(funct3)
          3'b000: begin
            // SB (STORE BYTE)
            reg imm = iword[31:25];
          end
          3'b001: begin
            // SH (STORE HALFWORD)
            reg imm = iword[31:25];
          end
          3'b010: begin
            // SW (STORE WORD)
            reg imm = iword[31:25];
          end
        endcase
      end
    endcase
  end
endmodule