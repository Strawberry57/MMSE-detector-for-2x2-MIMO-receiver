module cd_tb ();
   reg clk;
   reg reset;
   reg start;

   reg [15:0] h1, h2;   
 
   wire [15:0] q1, q2, norm;

   wire finish; 
   cd cd(
      .clk (clk),
      .reset (reset),
      .start (start),

      .h1 (h1),
      .h2 (h2),
      .q1 (q1),
      .q2 (q2),
      .norm (norm),
      .finish (finish)  
   );
   initial begin
     clk = 0;
     forever clk = #5 ~clk;
   end

   initial begin
      start = 1;
      h1 = 16'b1111111010000001;
      h2 = 16'b0000000110000001;
   
   end
   
endmodule
