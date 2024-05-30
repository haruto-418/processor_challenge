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
        alucode <= ALU_LUI; // LUI
      7'b0010111:
        alucode <= 6'b00001; // AUIPC
      7'b0010011: begin
        case(ir[14:12])
          3'b000:
            alucode <= ALU_ADD; // ADDI
          3'b010:
            alucode <= ALU_SLT; // SLTI
          3'b011:
            alucode <= ALU_SLTU; // SLTIU
          3'b100:
            alucode <= ALU_XOR; // XORI
          3'b110:
            alucode <= ALU_OR; // ORI
          3'b111:
            alucode <= ALU_AND; // ANDI
          3'b001: 
            alucode <= ALU_SLL; // SLLI
          3'b101: begin
            case(ir[31:25])
              7'b0000000: 
                alucode <= ALU_SRL; // SRLI
              7'b0100000: 
                alucode <= ALU_SRA; // SRAI
            endcase
          end
        endcase
      end

      7'b0110011: begin
        case(ir[14:12])
          3'b000:begin
            case(ir[31:25])
              7'b0000000: 
                alucode <= ALU_ADD; // ADD
              7'b0100000: 
                alucode <= ALU_SUB; // SUB
            endcase
          end
        3'b001: 
          alucode <= ALU_SLL; // SLL
        3'b010: 
          alucode <= ALU_SLT; // SLT
        3'b011: 
          alucode <= ALU_SLTU; // SLTU
        3'b100: 
          alucode <= ALU_XOR; // XOR
        3'b101: begin
          case(ir[31:25])
            7'b0000000: 
              alucode <= ALU_SRL; // SRL
            7'b0100000: 
              alucode <= ALU_SRA; // SRA
          endcase
        end
        3'b110: 
          alucode <= ALU_OR; // OR
        3'b111: 
          alucode <= ALU_AND; // AND
        endcase
      end

      7'b1101111:
        alucode <= ALU_JAL; // JAL
      7'b1100111: 
        alucode <= ALU_JALR; // JALR
      7'b1100011: begin
        case(ir[14:12])
          3'b000: 
            alucode <= ALU_BEQ; // BEQ
          3'b001: 
            alucode <= ALU_BNE; // BNE
          3'b100: 
            alucode <= ALU_BLT; // BLT
          3'b101: 
            alucode <= ALU_BGE; // BGE
          3'b110: 
            alucode <= ALU_BLTU; // BLTU
          3'b111: 
            alucode <= ALU_BGEU; // BGEU
        endcase
      end

      7'b0000011: begin
        case(ir[14:12])
          3'b000: 
            alucode <= ALU_LB; // LB
          3'b001: 
            alucode <= ALU_LH; // LH
          3'b010: 
            alucode <= ALU_LW; // LW
          3'b100: 
            alucode <= ALU_LBU; // LBU
          3'b101: 
            alucode <= ALU_LHU; // LHU
        endcase
      end

      7'b0100011: begin
        case(ir[14:12])
          3'b000: 
            alucode <= ALU_SB; // SB
          3'b001: 
            alucode <= ALU_SH; // SH
          3'b010: 
            alucode <= ALU_SW; // SW
        endcase
      end
    endcase
  end
endmodule
