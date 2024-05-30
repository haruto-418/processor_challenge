module alu(
  input wire [31:0] oprl,
  input wire [31:0] oprr,
  input wire [31:0] pc,
  input wire [3:0] func_code,

  output reg [31:0] result
);
  always @(func_code) begin
    case(func_code)
      
    endcase
  end
endmodule