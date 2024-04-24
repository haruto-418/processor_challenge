`timescale 1ns / 1ps

module memory_tb;
reg clk;
reg we;
reg[7:0] addr;
reg[31:0] din;
wire [31:0] dout;

memory uut(
  .clk(clk),
  .we(we),
  .addr(addr),
  .din(din),
  .dout(dout)
);

initial begin
  clk = 0;
  forever #5 clk = ~clk;
end

initial begin
  $dumpfile("memory_test.vcd");
  $dumpvars(0, memory_tb);

  $monitor("time=%0t, we=%b, addr=%h, din=%h, dout=%h", $time, we, addr, din, dout);
  we = 0; addr = 0; din = 0;

  #10 we = 1; addr = 8'h01; din = 32'hdeadbeef;
  #10 we = 1; addr = 8'h02; din = 32'hcafebabe;
  #10 we = 0; addr = 8'h01; // 最初のデータを読み出す
  #10 addr = 8'h02;        // 次のデータを読み出す
  #10 $finish;             // シミュレーション終了
end

endmodule