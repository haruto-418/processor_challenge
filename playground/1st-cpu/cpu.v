module CPU(
  input wire CK, RST,
  output wire[15:0] IA,
  input wire[15:0] ID,
  output wire[15:0] DA,
  inout wire[15:0] DD,
  output reg RW
);
  reg[15:0] RF[0:14];
  reg[15:0] PC;

  reg[1:0] STAGE;
  reg[15:0] INSTR;

  reg[15:0] FUA, FUB;
  reg[15:0] FUc;

  reg[15:0] LSUA, LSUB;
  reg[15:0] LSUc;

  reg[15:0] PCi; // NPC
  reg[15:0] PCc; // PC for CBUS

  reg FLAG;

  wire[15:0] ABUS, BBUS, CBUS;

  assign ABUS = ((INSTR[7:4] != 4'b1100) ? RF[INSTR[7:4]] : 16'bz);
  assign BBUS = ((INSTR[7:4] != 4'b1100) ? RF[INSTR[3:0]] : 16'bz);
  assign CBUS = ((INSTR[15] == 0) ? FUc :
              (INSTR[15:12] == 4'b1011) ? LSUc :
              (INSTR[15:12] == 4'b1000) ? PCc :
              (INSTR[15:12] == 4'b1100) ? {8'b0, INSTR[7:0]} :
              16'bz);

  assign DD = ((RW == 1) ? 16'bz : LSUA); // RW == 1: load, RW == 0: store
  assign DA = LSUB;

  assign IA = PC;

  always @(posedge CK) begin
    if(RST == 1) begin
      STAGE <= 2'b00;
      PC <= 16'b0000000000000000;
      PCi <= 16'b0000000000000000;
      RW <= 1; // load
    end else begin
      case(STAGE)
        2'b00: 
          begin
            INSTR <= ID;
            RW <= 1;
            STAGE <= 2'b01;
          end
        2'b01: 
          begin
            if(INSTR[15] == 0) begin
              FUA <= ABUS;
              FUB <= BBUS;
            end

            if(INSTR[15:12] == 4'b1010) begin
              // store
              RW <= 0;
              LSUA <= ABUS;
              LSUB <= BBUS;
              PCi <= PC + 16'b0000000000000001;
            end else if (INSTR[15:12] == 4'b1011) begin
              // load
              LSUA <= ABUS;
              PCi <= PC + 16'b0000000000000001;
            end else if(INSTR[15:12] == 4'b1000) begin
              // jump
              PCi <= BBUS;
            end else if(INSTR[15:12] == 4'b1001) begin
              // branch
              PCi <= ((FLAG == 1) ? BBUS : PC + 16'b0000000000000001);
            end else PCi <= PC + 16'b0000000000000001;
            
            STAGE <= 2'b10;
          end
        2'b10: 
          begin
            if(INSTR[15] == 0) begin
              case(INSTR[15:12])
                4'b0000: FUc <= FUA + FUB;
                4'b0001: FUc <= FUA - FUB;
                4'b0010: FUc <= FUA >> FUB; 
                4'b0011: FUc <= FUA << FUB; 
                4'b0100: FUc <= FUA | FUB; 
                4'b0101: FUc <= FUA & FUB; 
                4'b0110: FUc <= ~FUA; 
                4'b0111: FUc <= FUA ^ FUB;
              endcase
            end

            if(INSTR[15:12] == 4'b1011) begin
              // load
              LSUc <= DD;
            end else if(INSTR[15:12] == 4'b1000) begin
              // jump
              PCc <= PC + 16'b0000000000000001;
            end
            
            STAGE <= 2'b11;
          end
        2'b11: 
          begin
            RF[INSTR[11:8]] <= CBUS;
            PC <= PCi;
            RW <= 1;

            STAGE <= 2'b00;
          end
      endcase
    end
  end
endmodule
h 