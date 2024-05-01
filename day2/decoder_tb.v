module decoder_tb;
  reg[31:0] instruction;

  wire[4:0] rs1;
  wire[4:0] rs2;
  wire[4:0] rd;
  wire[6:0] opcode;
  wire[2:0] funct3;
  wire[6:0] funct7;
  wire add;
  wire sub;

  decoder uut (
    .instruction(instruction),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .add(add),
    .sub(sub)
  );

  initial begin
    instruction = 32'b0000000_00011_00010_000_00101_0110011;
    #10;

    $display("rs1=%d, rs2=%d, rd=%d, opcode=%d, funct3=%d, funct7=%d, add=%d, sub=%d",
      rs1, rs2, rd, opcode, funct3, funct7, add, sub);

    instruction = 32'b0100000_00101_00100_000_01010_0110011;
    #10;

    $display("rs1=%d, rs2=%d, rd=%d, opcode=%d, funct3=%d, funct7=%d, add=%d, sub=%d",
      rs1, rs2, rd, opcode, funct3, funct7, add, sub);

    $finish;
  end
endmodule