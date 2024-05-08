module register_file(
  input wire[4:0] rs1,
  input wire[4:0] rs2,

  output wire[31:0] oprl,
  output wire[31:0] oprr
);
  reg [31:0] reg[0:31];

  assign oprl = reg[rs1];
  assign oprr = reg[rs2];
endmodule