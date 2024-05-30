module decoder(
  input wire[31:0] iword,

  output wire[4:0] func_code,
  output wire[0:0] rd_en, 
  output wire[0:0] ld_en, 
  output wire[0:0] st_en 
);
  wire[6:0] opcode;
  wire[6:0] rd;
  wire[4:0] rs1, rs2;
  wire[2:0] funct3;

  reg[5:0] func_code;

  assign rd = iword[11:7];
  assign funct3 = iword[14:12];
  assign opcode = iword[6:0];

  assign rd_en = rd != 7'b1100011 ? (rd != 7'b0100011 ? 1: 0) : 0;
  assign ld_en = rd != 7'b0000011 ? 0 : 1;
  assign st_en = rd != 7'b0100011 ? 0 : 1;

  always @(iword) begin
    case(opcode)
      7'b0110111:
        func_code <= 6'b00000; // LUI
      7'b0010111:
        func_code <= 6'b00001; // AUIPC
      7'b0010011: begin
        case(iword[14:12])
          3'b000:
            func_code <= 6'b000010; // ADDI
          3'b010:
            func_code <= 6'b000011; // SLTI
          3'b011:
            func_code <= 6'b000100; // SLTIU
          3'b100:
            func_code <= 6'b000101; // XORI
          3'b110:
            func_code <= 6'b000110; // ORI
          3'b111:
            func_code <= 6'b000111; // ANDI
          3'b001: 
            func_code <= 6'b001000; // SLLI
          3'b101: begin
            case(iword[31:25])
              7'b0000000: 
                func_code <= 6'b001001; // SRLI
              7'b0100000: 
                func_code <= 6'b001010; // SRAI
            endcase
          end
        endcase
      end

      7'b0110011: begin
        case(iword[14:12])
          3'b000:begin
            case(iword[31:25])
              7'b0000000: 
                func_code <= 6'b001011; // ADD
              7'b0100000: 
                func_code <= 6'b001100; // SUB
            endcase
          end
        3'b001: 
          func_code <= 6'b001101; // SLL
        3'b010: 
          func_code <= 6'b001110; // SLT
        3'b011: 
          func_code <= 6'b001111; // SLTU
        3'b100: 
          func_code <= 6'b010000; // XOR
        3'b101: begin
          case(iword[31:25])
            7'b0000000: 
              func_code <= 6'b010001; // SRL
            7'b0100000: 
              func_code <= 6'b010010; // SRA
          endcase
        end
        3'b110: 
          func_code <= 6'b010011; // OR
        3'b111: 
          func_code <= 6'b010100; // AND
        endcase
      end

      7'b1101111:
        func_code <= 6'b010101; // JAL
      7'b1100111: 
        func_code <= 6'b010110; // JALR
      7'b1100011: begin
        case(iword[14:12])
          3'b000: 
            func_code <= 6'b010111; // BEQ
          3'b001: 
            func_code <= 6'b011000; // BNE
          3'b100: 
            func_code <= 6'b011001; // BLT
          3'b101: 
            func_code <= 6'b011010; // BGE
          3'b110: 
            func_code <= 6'b011011; // BLTU
          3'b111: 
            func_code <= 6'b011100; // BGEU
        endcase
      end

      7'b0000011: begin
        case(iword[14:12])
          3'b000: 
            func_code <= 6'b011101; // LB
          3'b001: 
            func_code <= 6'b011110; // LH
          3'b010: 
            func_code <= 6'b011111; // LW
          3'b100: 
            func_code <= 6'b100000; // LBU
          3'b101: 
            func_code <= 6'b100001; // LHU
        endcase
      end

      7'b0100011: begin
        case(iword[14:12])
          3'b000: 
            func_code <= 6'b100010; // SB
          3'b001: 
            func_code <= 6'b100011; // SH
          3'b010: 
            func_code <= 6'b100100; // SW
        endcase
      end
    endcase
  end
endmodule