module decoder(
  input wire[31:0] iword,

  output wire[4:0] func_code,
  output wire[0:0] rd_en, 
  output wire[0:0] ld_en, 
  output wire[0:0] st_en 
);
  always @(iword) begin
    case(iword[6:0])
      7'b0110111: 
        func_code = 5'b00000;
        rd_en = 1;
      7'b0010111: 
        func_code = 5'b00001;
        rd_en = 1;
      7'b0010011: begin
        case(iword[14:12])
          3'b000: 
            func_code = 5'b00010;
            rd_en = 1;
          3'b010: 
            func_code = 5'b00011;
            rd_en = 1;
          3'b011: 
            func_code = 5'b00100;
            rd_en = 1;
          3'b100: 
            func_code = 5'b00101;
            rd_en = 1;
          3'b110: 
            func_code = 5'b00110;
            rd_en = 1;
          3'b111: 
            func_code = 5'b00111;
            rd_en = 1;
          3'b001: 
            func_code = 5'b01000;
            rd_en = 1;
          3'b101: begin
            case(iword[31:25])
              7'b0000000: 
                func_code = 5'b01001;
                rd_en = 1;
              7'b0100000: 
                func_code = 5'b01010;
                rd_en = 1;
            endcase
          end
        endcase
      end
      7'b0110011: begin
        case(iword[14:12])
        3'b000:begin
          case(iword[31:25])
            7'b0000000: 
              func_code = 5'b01011;
              rd_en = 1;
            7'b0100000: 
              func_code = 5'b01100;
              rd_en = 1;
          endcase
        end
        3'b001: 
          func_code = 5'b01101;
          rd_en = 1;
        3'b010: 
          func_code = 5'b01110;
          rd_en = 1;
        3'b011: 
          func_code = 5'b01111;
          rd_en = 1;
        3'b100: 
          func_code = 5'b10000;
          rd_en = 1;
        3'b101: begin
          case(iword[31:25])
            7'b0000000: 
              func_code = 5'b10001;
              rd_en = 1;
            7'b0100000: 
              func_code = 5'b10010;
              rd_en = 1;
          endcase
        end
        3'b110: 
          func_code = 5'b10011;
          rd_en = 1;
        3'b111: 
          func_code = 5'b10100;
          rd_en = 1;
        endcase
      end

      
      7'b1101111: 
      7'b1100111: 
      7'b1100011: begin
        case(iword[14:12])
          3'b000: 
          3'b001: 
          3'b100: 
          3'b101: 
          3'b110: 
          3'b111: 
        endcase
      end

      
      7'b0000011: begin
        case(iword[14:12])
          3'b000: imm = iword[31:20];  
          3'b001: imm = iword[31:20];  
          3'b010: imm = iword[31:20];  
          3'b100: imm = iword[31:20];  
          3'b101: imm = iword[31:20];  
        endcase
      end
      7'b0100011: begin
        case(iword[14:12])
          3'b000: 
          3'b001: 
          3'b010: 
        endcase
      end
    endcase    
  end
endmodule