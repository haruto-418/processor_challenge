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
        func_code <= 6'b00000;
      7'b0010111:
        func_code <= 6'b00001;
      7'b0010011: begin
        case(iword[14:12])
          3'b000:
            func_code <= 6'b000010;
          3'b010:
            func_code <= 6'b000011;
          3'b011:
            func_code <= 6'b000100;
          3'b100: 
            func_code <= 6'b000101;
          3'b110: 
            func_code <= 6'b000110;
          3'b111: 
            func_code <= 6'b000111;
          3'b001: 
            func_code <= 6'b001000;
          3'b101: begin
            case(iword[31:25])
              7'b0000000: 
                func_code <= 6'b001001;
              7'b0100000: 
                func_code <= 6'b001010;
            endcase
          end
        endcase
      end

      7'b0110011: begin
        case(iword[14:12])
          3'b000:begin
            case(iword[31:25])
              7'b0000000: 
                func_code <= 6'b001011;
              7'b0100000: 
                func_code <= 6'b001100;
            endcase
          end
        3'b001: 
          func_code <= 6'b001101;
        3'b010: 
          func_code <= 6'b001110;
        3'b011: 
          func_code <= 6'b001111;
        3'b100: 
          func_code <= 6'b010000;
        3'b101: begin
          case(iword[31:25])
            7'b0000000: 
              func_code <= 6'b010001;
            7'b0100000: 
              func_code <= 6'b010010;
          endcase
        end
        3'b110: 
          func_code <= 6'b010011;
        3'b111: 
          func_code <= 6'b010100;
        endcase
      end

      7'b1101111:
        func_code <= 6'b010101;
      7'b1100111: 
        func_code <= 6'b010110;
      7'b1100011: begin
        case(iword[14:12])
          3'b000: 
            func_code <= 6'b010111;
          3'b001: 
            func_code <= 6'b011000;
          3'b100: 
            func_code <= 6'b011001;
          3'b101: 
            func_code <= 6'b011010;
          3'b110: 
            func_code <= 6'b011011;
          3'b111: 
            func_code <= 6'b011100;
        endcase
      end

      7'b0000011: begin
        case(iword[14:12])
          3'b000: 
            func_code <= 6'b011101;
          3'b001: 
            func_code <= 6'b011110;
          3'b010: 
            func_code <= 6'b011111;
          3'b100: 
            func_code <= 6'b100000;
          3'b101: 
            func_code <= 6'b100001;
        endcase
      end

      7'b0100011: begin
        case(iword[14:12])
          3'b000: 
            func_code <= 6'b100010;
          3'b001: 
            func_code <= 6'b100011;
          3'b010: 
            func_code <= 6'b100100;
        endcase
      end
    endcase
  end
endmodule