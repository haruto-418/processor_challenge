module memory(
  input wire clk,
  input wire we,  // write enable   
  input wire[7:0] addr, // address
  input wire[31:0] din, // data in
  output reg[31:0] dout // data out
);
  reg[31:0] mem[255:0];

  always @(posedge clk) begin
    if(we)begin
      mem[addr] <= din; // メモリにデータ書き込む
    end

    dout <= mem[addr]; // メモリからデータ読み出す
  end
endmodule