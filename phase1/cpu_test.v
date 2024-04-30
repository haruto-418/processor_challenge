module cpu_test;
  reg clk;
  reg rst;
  wire [31:0] result;

  cpu uut (
    .clk(clk),
    .rst(rst),
    .result(result)
  );

  always begin
    #10 clk = ~clk;
  end

  task initialize;
    begin
      $display("%t: Resetting the CPU...", $time);
      rst = 1;
      #40;
      rst = 0;
      $display("%t: CPU Reset complete.", $time);
    end
  endtask

  task init_memory;
    begin
      $display("%t: Initializing memory...", $time);
      uut.mem[0] = 8'h01;
      uut.mem[1] = 8'h02;
      uut.mem[2] = 8'h03;
      $display("%t: Memory initialization complete.", $time);
    end
  endtask

  initial begin
    clk = 0;
    $display("%t: Starting the simulation", $time);
    initialize();
    init_memory();
    #400;
    $display("%t: Simulation ends. Result = %d", $time, result);
    $finish;
  end

  initial begin
    $monitor("Time=%t, Result=%d", $time, result); // 結果をリアルタイムでモニタリング
  end
endmodule