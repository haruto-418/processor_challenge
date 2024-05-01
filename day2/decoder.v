module decoder(
  input [31:0] instruction,
  output reg[4:0] rs1,
  output reg[4:0] rs2,
  output reg[4:0] rd,
  output reg [6:0] opcode,
  output reg[2:0] funct3,
  output reg[6:0] funct7,
  output reg add,
  output reg sub
);
  always @(instruction) begin // instructionの値が変わるたびに実行される
    opcode = instruction[6:0];
    rs1 = instruction[19:15];
    rs2 = instruction[24:20];
    rd = instruction[11:7];
    funct3 = instruction[14:12];
    funct7 = instruction[31:25];

    add = 0;
    sub = 0;

    if(opcode == 7'b0110011) begin
      case (funct3)
      3'b000: begin
        if(funct7 == 7'b0000000)
          add = 1;
        else if(funct7 == 7'b0100000)
          sub = 1;
      end
      endcase
    end
  end
endmodule