// 算術演算命令以外は未実装

module decoder_ver2(
  input wire[31:0] iword,

  output wire[4:0] func_code, // 演算の識別子（自分で決めたもの）
  output wire[0:0] rd_en, // rdに書き込みを行う場合は1
  output wire[0:0] ld_en, // メモリから読み込みを行う場合は1
  output wire[0:0] st_en // メモリへ書き込みを行う場合は1

  // メモリ転送のバイト数などは省略
  
);
  always @(iword) begin
    opcode = iword[6:0];
    rd = iword[11:7];
    funct3 = iword[14:12];
    funct7 = iword[31:25];

    // 出力値のデフォルト
    rd_en = 0;
    ld_en = 0;
    st_en = 0;

    case(opcode)
      // 算術論理演算命令
      7'b0110111: // LUI (LOAD UPPER IMMEDIATE)
        func_code = 5'b00000;
        rd_en = 1;
      7'b0010111: // AUIPC (ADD UPPER IMMEDIATE TO PC)
        func_code = 5'b00001;
        rd_en = 1;
      7'b0010011: begin
        case(funct3)
          3'b000: // ADDI (ADDITION IMMEDIATE)
            func_code = 5'b00010;
            rd_en = 1;
          3'b010: // SLTI (SET LESS THAN IMMEDIATE)
            func_code = 5'b00011;
            rd_en = 1;
          3'b011: // SLTIU (SET LESS THAN IMMEDIATE UNSIGNED)
            func_code = 5'b00100;
            rd_en = 1;
          3'b100: // XORI (EXCLUSIVE OR IMMEDIATE)
            func_code = 5'b00101;
            rd_en = 1;
          3'b110: // ORI (OR IMMEDIATE)
            func_code = 5'b00110;
            rd_en = 1;
          3'b111: // ANDI (AND IMMEDIATE)
            func_code = 5'b00111;
            rd_en = 1;
          3'b001: // SLLI (SHIFT LEFT LOGICAL IMMEDIATE)
            func_code = 5'b01000;
            rd_en = 1;
          3'b101: begin
            case(funct7)
              7'b0000000: // SRLI (SHIFT RIGHT LOGICAL IMMEDIATE)
                func_code = 5'b01001;
                rd_en = 1;
              7'b0100000: // SRAI (SHIFT RIGHT ARITHMETIC IMMEDIATE)
                func_code = 5'b01010;
                rd_en = 1;
            endcase
          end
        endcase
      end
      7'b0110011: begin
        case(funct3)
        3'b000:begin
          case(funct7)
            7'b0000000: //ADD (ADDITION)
              func_code = 5'b01011;
              rd_en = 1;
            7'b0100000: // SUB (SUBTRACT)
              func_code = 5'b01100;
              rd_en = 1;
          endcase
        end
        3'b001: // SLL (SHIFT LEFT LOGICAL)
          func_code = 5'b01101;
          rd_en = 1;
        3'b010: // SLT (SET LESS THAN)
          func_code = 5'b01110;
          rd_en = 1;
        3'b011: // LSTU (SET LESS THAN UNSIGNED)
          func_code = 5'b01111;
          rd_en = 1;
        3'b100: // XOR (EXCLUSIVE OR)
          func_code = 5'b10000;
          rd_en = 1;
        3'b101: begin
          case(funct7)
            7'b0000000: // SRL (SHIFT RIGHT LOGICAL)
              func_code = 5'b10001;
              rd_en = 1;
            7'b0100000: // SRA (SHIFT RIGHT ARITHMETIC)
              func_code = 5'b10010;
              rd_en = 1;
          endcase
        end
        3'b110: // OR (OR)
          func_code = 5'b10011;
          rd_en = 1;
        3'b111: // AND (AND)
          func_code = 5'b10100;
          rd_en = 1;
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
          3'b000: // SB (STORE BYTE)
          3'b001: // SH (STORE HALFWORD)
          3'b010: // SW (STORE WORD)
        endcase
      end
    endcase    
  end
endmodule