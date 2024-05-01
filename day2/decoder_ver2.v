module decoder_ver2(
  input[31:0] instr,
  
  output reg[4:0] rs1,
  output reg[4:0] rs2,
  output reg[4:0] rd,
  output reg[6:0] opcode,

  // 算術演算命令
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
);
  always @(instr) begin
    opcode = instr[6:0];

    case(opcode)
      7'b0110111: LUI = 1;
      7'b0010111: AUIPC = 1;
      7'b0010011: ADDi = 1;

      7'b0010011:begin
        reg[2:0] funct3 = instr[14:12];
        case(funct3)
          3'b000: ADDI = 1;
          3'b010: SLTI = 1;
          3'b011: SLTIU = 1;
          3'b100: XORI = 1;
          3'b110: ORI = 1;
          3'b111: ANDI = 1;
          3'b001: SLLI = 1;

          3'b101: begin
            reg[6:0] funct7 = instr[31:25];
            case(funct7)
              7'b0000000: SRLI = 1;
              7'b0100000: SRAI = 1;
            endcase
          end
        endcase
      end

      7'b0110011: begin
        funct3 = instr[14:12];
        case(funct3)
          3'b000: begin
            funct7 = instr[31:25];
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
            funct7 = instr[31:25];
            case(funct7)
              7'0000000: SRL = 1;
              7'b0100000: SRA = 1;
            endcase
          end

          3'b110: OR = 1;
          3'b111: AND = 1;
        endcase
      end
    endcase
  end
endmodule