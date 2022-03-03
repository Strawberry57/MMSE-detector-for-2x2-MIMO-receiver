module MMSE_2_tb();
   reg clk;
   reg reset;
   reg start;
   reg signed [15:0] h11,h12,h13,h14,h21,h22,h23,h24,h31,h32,h33,h34,h41,h42,h43,h44; /// intext
   reg signed [15:0] y11,y12,y21,y22,y31,y32,y41,y42;
   reg signed [15:0] n11,n12,n13,n14,n21,n22,n23,n24,n31,n32,n33,n34,n41,n42,n43,n44;
   wire signed [15:0] x11,x12,x21,x22,x31,x32,x41,x42;
   wire finish;
   
   MMSE_2 MMSE_2(
       .clk(clk),
       .start(start),
       .reset(reset),
       .h11(h11),
       .h12 (h12),
       .h13 (h13),
       .h14 (h14),
       .h21 (h21),
       .h22 (h22),
       .h23 (h23),
       .h24 (h24),
       .h31(h31),
       .h32 (h32),
       .h33 (h33),
       .h34 (h34),
       .h41 (h41),
       .h42 (h42),
       .h43 (h43),
       .h44 (h44),
       .y11 (y11),
       .y12 (y12),
       .y21 (y21),
       .y22 (y22),
       .y31 (y31),
       .y32 (y32),
       .y41 (y41),
       .y42 (y42),
       .n11 (n11),
       .n12 (n12),
       .n13 (n13),
       .n14 (n14),
       .n21 (n21),
       .n22 (n22),
       .n23 (n23),
       .n24 (n24),
       .n31 (n31),
       .n32 (n32),
       .n33 (n33),
       .n34 (n34),
       .n41 (n41),
       .n42 (n42),
       .n43 (n43),
       .n44 (n44),
       .x11(x11),
       .x12(x12),
       .x21(x21),
       .x22(x22),
       .x31(x31),
       .x32 (x32),
       .x41 (x41),
       .x42 (x42),
       .finish (finish)
   );
   integer i = 0;
   integer input_data_file, output_data_file;
   integer scan_file;
   reg [15:0] captured_data; 
   initial begin
      reset = 1;
      #5 reset = 0;
      #10 reset = 1;
  end

   initial begin
      clk = 0;
      forever clk = #5 ~clk;
   end

   // Get input
   initial begin
      // File path
      input_data_file = $fopen("E:/20221/VHDL_material/Group11_MMSE detector for 2x2 MIMO/Final/input.txt", "r");
      // input_data_file = $fopen("E:/20221/VHDL_material/Group11_MMSE detector for 2x2 MIMO/Final/input_0.txt", "r");
      // input_data_file = $fopen("E:/20221/VHDL_material/Group11_MMSE detector for 2x2 MIMO/Final/input_1.txt", "r");
     // input_data_file = $fopen("E:/20221/VHDL_material/Group11_MMSE detector for 2x2 MIMO/Final/input_2.txt", "r");
   //   input_data_file = $fopen("E:/20221/VHDL_material/Group11_MMSE detector for 2x2 MIMO/Final/input_4.txt", "r");
     // input_data_file = $fopen("E:/20221/VHDL_material/Group11_MMSE detector for 2x2 MIMO/Final/input_3.txt", "r");
      output_data_file = $fopen("E:/20221/VHDL_material/Group11_MMSE detector for 2x2 MIMO/Final/output_verilog.txt", "w");
      for(i = 0; i < 40; i = i+ 1) begin
         scan_file = $fscanf(input_data_file, "%b\n", captured_data); 
         if (!$feof(input_data_file)) begin
             case (i)
               0:  h11 = captured_data;
               1:  h12 = captured_data;
               2:  h13 = captured_data;
               3:  h14 = captured_data;
               4:  h21 = captured_data;
               5:  h22 = captured_data;
               6:  h23 = captured_data;
               7:  h24 = captured_data;
               8:  h31 = captured_data;
               9:  h32 = captured_data;
               10: h33 = captured_data;
               11: h34 = captured_data;
               12: h41 = captured_data;
               13: h42 = captured_data;
               14: h43 = captured_data;
               15: h44 = captured_data;
               16: y11 = captured_data;
               17: y12 = captured_data;
               18: y21 = captured_data;
               19: y22 = captured_data;
               20: y31 = captured_data;
               21: y32 = captured_data;
               22: y41 = captured_data;
               23: y42 = captured_data;
               24: n11 = captured_data;
               25: n12 = captured_data;
               26: n13 = captured_data;
               27: n14 = captured_data;
               28: n21 = captured_data;
               29: n22 = captured_data;
               30: n23 = captured_data;
               31: n24 = captured_data;
               32: n31 = captured_data;
               33: n32 = captured_data;
               34: n33 = captured_data;
               35: n34 = captured_data;
               36: n41 = captured_data;
               37: n42 = captured_data;
               38: n43 = captured_data;
               39: n44 = captured_data;
               // .....
            endcase
         end
      end
      $fclose(input_data_file);
      start = 1;
      // write output
      if(finish) begin
         // $fwriteb(output_data_file, x11, "\n");
         // $fwriteb(output_data_file, x12, "\n");
         // $fwriteb(output_data_file, x21, "\n");
         // $fwriteb(output_data_file, x22, "\n");
         // $fwriteb(output_data_file, x31, "\n");
         // $fwriteb(output_data_file, x32, "\n");
         // @(posedge clk);
         // $fwrite(output_data_file, "%d", i);
         // $fclose(output_data_file);
         $finish;
      end
   end
   always @(posedge clk ) begin
      //$display("123");
      if(finish) begin
      //   $display("asd");

         $fwriteb(output_data_file, x11, "\n");
         $fwriteb(output_data_file, x12, "\n");
         $fwriteb(output_data_file, x21, "\n");
         $fwriteb(output_data_file, x22, "\n");
         $fwriteb(output_data_file, x31, "\n");
         $fwriteb(output_data_file, x32, "\n");
         $fwriteb(output_data_file, x41, "\n");
         $fwriteb(output_data_file, x42, "");
         // $fwrite(output_data_file, "%d", i);
         $fclose(output_data_file);
         $stop;
      end
   end

   
   //    h11 = 16'b00000001_00000000;
   //    h12 = 16'b00000000_00011001;
   //    h13 = 16'b00000000_00110011;
   //    h14 = 16'b00000000_00011001;
   //    h21 = 16'b00000000_00011001;
   //    h22 = 16'b00000001_00000000;
   //    h23 = 16'b00000000_00011001;
   //    h24 = 16'b00000000_00011001;
   //    h31 = 16'b00000000_00011001;
   //    h32 = 16'b00000000_00011001;
   //    h33 = 16'b00000000_00110011;
   //    h34 = 16'b00000001_00000000;
   //    h41 = 16'b00000000_00110011;
   //    h42 = 16'b00000000_00011001;
   //    h43 = 16'b00000001_00000000;
   //    h44 = 16'b00000000_00011001;

   //    // y
   //     y11 = 16'b00000000_00011001;
   //     y12 = 16'b00000000_00011001;
   //     y21 = 16'b00000000_00011001;
   //     y22 = 16'b00000000_00011001;
   //     y31 = 16'b00000000_00110011;
   //     y32 = 16'b00000000_00011001;
   //     y41 = 16'b00000000_00011001;
   //     y42 = 16'b00000000_00110011;
   //  //   // n
   //     n11 = 16'b00000000_00011001;
   //     n12 = 16'b00000000_00011001;
   //     n13 = 16'b00000000_00000000;
   //     n14 = 16'b00000000_00000000;
   //     n21 = 16'b00000000_00011001;
   //     n22 = 16'b00000000_00011001;
   //     n23 = 16'b00000000_00000000;
   //     n24 = 16'b00000000_00000000;
   //     n31 = 16'b00000000_00000000;
   //     n32 = 16'b00000000_00000000;
   //     n33 = 16'b00000000_00011001;
   //     n34 = 16'b00000000_00110011;
   //     n41 = 16'b00000000_00000000;
   //     n42 = 16'b00000000_00000000;
   //     n43 = 16'b00000000_00110011;
   //     n44 = 16'b00000000_00011001;
   // end
   endmodule
