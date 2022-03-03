module qr #(
   parameter WIDTH=16,
   parameter FBITS=8 
) (
   input clk,
   input reset,
   input start,
   input signed [WIDTH-1:0] h11,h12,h13,h14,h21,h22,h23,h24,h31,h32,h33,h34,h41,h42,h43,h44,

   output reg signed [WIDTH-1:0] q11,q12,q13,q14,q21,q22,q23,q24,q31,q32,q33,q34,q41,q42,q43,q44,r11,r12,r13,r14,r22,r23,r24,r33,r34,r44,

   output reg finish
);
   reg signed [WIDTH-1:0] cd_h1, cd_h2, cd_h3, cd_h4;
   reg cd_start, cd_reset;

   wire signed [WIDTH-1:0] cd_q1, cd_q2, cd_q3, cd_q4, cd_norm;
   wire cd_finish;
   cd cd(
      .clk (clk),
      .reset (cd_reset),
      .start (cd_start),
      .h3(cd_h3),
      .h4(cd_h4),
      .h1 (cd_h1),
      .h2 (cd_h2),
      .q1 (cd_q1),
      .q2 (cd_q2),
      .q3 (cd_q3),
      .q4 (cd_q4),
      .norm (cd_norm),
      .finish (cd_finish)  
   );

   integer cd_cnt = 0;

   reg signed [WIDTH * 2 - 1: 0] r12_ovf, r12q11_ovf, r12q21_ovf,r12q31_ovf,r12q41_ovf,r13_ovf,r13q11_ovf,r13q21_ovf,r13q31_ovf,r13q41_ovf, r23_ovf,r23q12_ovf,r23q22_ovf,r23q32_ovf,r23q42_ovf, r14_ovf,r14q11_ovf,r14q21_ovf,r14q31_ovf,r14q41_ovf, r24_ovf,r24q11_ovf,r24q21_ovf,r24q31_ovf,r24q41_ovf, r34_ovf,r34q11_ovf,r34q21_ovf,r34q31_ovf,r34q41_ovf ;
   reg signed [WIDTH -1 :0] r12q21, r12q11, r12q31, r12q41, q2s1, q2s2,r13q11, r13q21, r13q31, r13q41, r23q12, r23q22, r23q32, r23q42,r23q33,r14q11,r24q12,r34q13,r14q21,r24q22,r34q23,r14q31,r24q32,r34q33,r14q41,r24q42,r34q43;

   always @(posedge clk or negedge reset) begin
      if(~reset) begin
         q11 <= 0;
         q12 <= 0;
         q13 <= 0;
         q14 <= 0;
         q21 <= 0;
         q22 <= 0;
         q23 <= 0;
         q24 <= 0;
         q31 <= 0;
         q32 <= 0;
         q33 <= 0;
         q34 <= 0;
         q41 <= 0;
         q42 <= 0;
         q43 <= 0;
         q44 <= 0;
         r11 <= 0;
         r12 <= 0;
         r13 <= 0;
         r14 <= 0;
         r22 <= 0;
         r23 <= 0;
         r24 <= 0;
         r33 <= 0;
         r34 <= 0;
         r44 <= 0;
         cd_h1 <= 0;
         cd_h2 <= 0;
         cd_h3 <= 0;
         cd_h4 <= 0;
         cd_start <= 0;
         cd_cnt <= 0;
         finish <= 0;
      end else if(start) begin
         if(cd_finish) begin
            cd_cnt = cd_cnt + 1;
         end
         if(cd_cnt == 0 ) begin
            cd_h1 <= h11;
            cd_h2 <= h21;
            cd_h3 <= h31;
            cd_h4 <= h41;
            cd_start <= 1;
         end
         else if (cd_cnt == 1) begin
            if(cd_finish) begin
               q11 <= cd_q1;
               q21 <= cd_q2;
               q31 <= cd_q3;
               q41 <= cd_q4;
               r11 <= cd_norm;
               cd_start <= 0;
               cd_reset <= 1;
            end

            r12_ovf = q11 * h12 + q21 * h22 + q31 * h32 + q41 * h42;
            @(posedge clk) r12 <= r12_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];

            r12q11_ovf = r12 * q11;

            r12q21_ovf = r12 * q21;

            r12q31_ovf = r12 * q31;

            r12q41_ovf = r12 * q41;

            r12q21 = r12q21_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r12q11 = r12q11_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r12q31 = r12q31_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r12q41 = r12q41_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            @(posedge clk) begin
               cd_reset <= 0;
               cd_start <= 1;
            end
            cd_h1 = h12 - r12q11;
            cd_h2 = h22 - r12q21;
            cd_h3 = h32 - r12q31;
            cd_h4 = h42 - r12q41;
           // $display("%b %b %b", h42, r12q41, h42-r12q41);

         end

         else if (cd_cnt == 2) begin
            if(cd_finish) begin
               r22 <= cd_norm;
               q12 <= cd_q1;
               q22 <= cd_q2;
               q32 <= cd_q3;
               q42 <= cd_q4;
               cd_start = 0;
               cd_reset = 1;
            end
            r13_ovf = q11 * h13 + q21 * h23 + q31 * h33 + q41 * h43;
            @(posedge clk) r13 <= r13_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r23_ovf = q12 * h13 + q22 * h23 + q32 * h33 + q42 * h43;
            @(posedge clk) r23 <= r23_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
           

            r13q11_ovf = r13 * q11;

            r13q21_ovf = r13 * q21;

            r13q31_ovf = r13 * q31;

            r13q41_ovf = r13 * q41;

            r13q11 = r13q11_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r13q21 = r13q21_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r13q31 = r13q31_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r13q41 = r13q41_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];


            r23q12_ovf = r23 * q12;

            r23q22_ovf = r23 * q22;

            r23q32_ovf = r23 * q32;

            r23q42_ovf = r23 * q42;

            r23q12 = r23q12_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r23q22 = r23q22_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r23q32 = r23q32_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r23q42 = r23q42_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];

             @(posedge clk) begin
               cd_reset = 0;
               cd_start = 1;
            end
            cd_h1 = h13 - r13q11 - r23q12;
            cd_h2 = h23 - r13q21 - r23q22;
            cd_h3 = h33 - r13q31 - r23q32;
            cd_h4 = h43 - r13q41 - r23q42;

         end
         else if (cd_cnt == 3) begin
            if(cd_finish) begin
               q13 <= cd_q1;
               q23 <= cd_q2;
               q33 <= cd_q3;
               q43 <= cd_q4;
               r33 <= cd_norm;
               cd_start = 0;
               cd_reset = 1;
            end
            r14_ovf = q11 * h14 + q21 * h24 + q31 * h34 + q41 * h44;
            @(posedge clk) r14 <= r14_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r24_ovf = q12 * h14 + q22 * h24 + q32 * h34 + q42 * h44;
            @(posedge clk) r24 <= r24_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r34_ovf = q13 * h14 + q23 * h24 + q33 * h34 + q43 * h44;
            @(posedge clk) r34 <= r34_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
          // $display("r14_ovf = %b", r14_ovf);
            r14q11_ovf = r14 * q11;

            r14q21_ovf = r14 * q21;

            r14q31_ovf = r14 * q31;

            r14q41_ovf = r14 * q41;

            r14q11 = r14q11_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r14q21 = r14q21_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r14q31 = r14q31_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r14q41 = r14q41_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            
            
            r24q11_ovf = r24 * q12;

            r24q21_ovf = r24 * q22;

            r24q31_ovf = r24 * q32;

            r24q41_ovf = r24 * q42;

            r24q12 = r24q11_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r24q22 = r24q21_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r24q32 = r24q31_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r24q42 = r24q41_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];

            
            r34q11_ovf = r34 * q13;

            r34q21_ovf = r34 * q23;

            r34q31_ovf = r34 * q33;

            r34q41_ovf = r34 * q43;

            r34q13 = r34q11_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r34q23 = r34q21_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r34q33 = r34q31_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
            r34q43 = r34q41_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];

            @(posedge clk) begin
               cd_reset = 0;
               cd_start = 1;
            end
            cd_h1 = h14 - r14q11 - r24q12 - r34q13;
            cd_h2 = h24 - r14q21 - r24q22 - r34q23;
            cd_h3 = h34 - r14q31 - r24q32 - r34q33;
            cd_h4 = h44 - r14q41 - r24q42 - r34q43;
         end
          else if (cd_cnt == 4) begin
            if(cd_finish) begin
               q14 <= cd_q1;
               q24 <= cd_q2;
               q34 <= cd_q3;
               q44 <= cd_q4;
               r44 <= cd_norm;
              finish <= 1;
            end
          end
         if(finish) begin
            //  $display(" q11 = %b", q11);
            // $display(" q12 = %b", q12);
            // $display(" q21 = %b", q21);
            // $display(" q22 = %b", q22);
            // $display(" r11 = %b", r11);
            // $display(" r12 = %b", r12);
            // $display(" r22 = %b", r22);
         end
      end

   end


endmodule