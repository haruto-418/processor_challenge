`include "define.h"

module decoder(
  input  wire[31:0] ir, // 機械語命令列

  output wire[4:0] srcreg1_num, // ソースレジスタ1番号
  output wire[4:0] srcreg2_num, // ソースレジスタ2番号
  output wire[4:0] dstreg_num, // デスティネーションレジスタ番号
  output wire[31:0]	imm, // 即値
  output reg[5:0]	alucode, // ALUの演算種別
  output reg[1:0]	aluop1_type, // ALUの入力タイプ
  output reg[1:0]	aluop2_type, // ALUの入力タイプ
  output reg reg_we, // レジスタ書き込みの有無
  output reg is_load, // ロード命令判定フラグ
  output reg is_store, // ストア命令判定フラグ
  output reg is_halt
);
  wire[6:0] opcode;
  wire[2:0] funct3;

  assign funct3 = ir[14:12];
  assign opcode = ir[6:0];

  assign reg_we = rd != 7'b1100011 ? (rd != 7'b0100011 ? 1: 0) : 0;
  assign is_load = rd != 7'b0000011 ? 0 : 1;
  assign is_store = rd != 7'b0100011 ? 0 : 1;

  assign srcreg1_num = ir[19:15];
  assign srcreg2_num = ir[24:20];
  assign dstreg_num = ir[11:7];

  always @(ir) begin
    case(opcode)
      7'b0110111:
        alucode <= 6'b00000; // LUI
      7'b0010111:
        alucode <= 6'b00001; // AUIPC
      7'b0010011: begin
        case(ir[14:12])
          3'b000:
            alucode <= 6'b000010; // ADDI
          3'b010:
            alucode <= 6'b000011; // SLTI
          3'b011:
            alucode <= 6'b000100; // SLTIU
          3'b100:
            alucode <= 6'b000101; // XORI
          3'b110:
            alucode <= 6'b000110; // ORI
          3'b111:
            alucode <= 6'b000111; // ANDI
          3'b001: 
            alucode <= 6'b001000; // SLLI
          3'b101: begin
            case(ir[31:25])
              7'b0000000: 
                alucode <= 6'b001001; // SRLI
              7'b0100000: 
                alucode <= 6'b001010; // SRAI
            endcase
          end
        endcase
      end

      7'b0110011: begin
        case(ir[14:12])
          3'b000:begin
            case(ir[31:25])
              7'b0000000: 
                alucode <= 6'b001011; // ADD
              7'b0100000: 
                alucode <= 6'b001100; // SUB
            endcase
          end
        3'b001: 
          alucode <= 6'b001101; // SLL
        3'b010: 
          alucode <= 6'b001110; // SLT
        3'b011: 
          alucode <= 6'b001111; // SLTU
        3'b100: 
          alucode <= 6'b010000; // XOR
        3'b101: begin
          case(ir[31:25])
            7'b0000000: 
              alucode <= 6'b010001; // SRL
            7'b0100000: 
              alucode <= 6'b010010; // SRA
          endcase
        end
        3'b110: 
          alucode <= 6'b010011; // OR
        3'b111: 
          alucode <= 6'b010100; // AND
        endcase
      end

      7'b1101111:
        alucode <= 6'b010101; // JAL
      7'b1100111: 
        alucode <= 6'b010110; // JALR
      7'b1100011: begin
        case(ir[14:12])
          3'b000: 
            alucode <= 6'b010111; // BEQ
          3'b001: 
            alucode <= 6'b011000; // BNE
          3'b100: 
            alucode <= 6'b011001; // BLT
          3'b101: 
            alucode <= 6'b011010; // BGE
          3'b110: 
            alucode <= 6'b011011; // BLTU
          3'b111: 
            alucode <= 6'b011100; // BGEU
        endcase
      end

      7'b0000011: begin
        case(ir[14:12])
          3'b000: 
            alucode <= 6'b011101; // LB
          3'b001: 
            alucode <= 6'b011110; // LH
          3'b010: 
            alucode <= 6'b011111; // LW
          3'b100: 
            alucode <= 6'b100000; // LBU
          3'b101: 
            alucode <= 6'b100001; // LHU
        endcase
      end

      7'b0100011: begin
        case(ir[14:12])
          3'b000: 
            alucode <= 6'b100010; // SB
          3'b001: 
            alucode <= 6'b100011; // SH
          3'b010: 
            alucode <= 6'b100100; // SW
        endcase
      end
    endcase
  end
endmodule
