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
endmodule
