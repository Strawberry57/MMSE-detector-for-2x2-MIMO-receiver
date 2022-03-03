module MMSE_2 #(
    parameter  WIDTH = 16 ,
    parameter   FBITS = 8
) (
    input clk,
    input reset,
    input start,
    input signed [WIDTH-1:0] h11,h12,h13,h14,h21,h22,h23,h24,h31,h32,h33,h34,h41,h42,h43,h44,
    input signed [WIDTH-1:0] y11,y12,y21,y22,y31,y32,y41,y42,
     input signed [WIDTH-1:0] n11,n12,n13,n14,n21,n22,n23,n24,n31,n32,n33,n34,n41,n42,n43,n44,
     output reg signed [WIDTH-1:0] x11,x12,x21,x22,x31,x32,x41,x42,
     output reg finish
);
    reg qr_start ;
    reg signed [WIDTH-1:0] x, y;
    wire signed [WIDTH - 1: 0] q, r;
    reg  dv_start;
    wire dv_busy, dv_valid, dv_ovf, dv_dbz;
    wire qr_finish;
    wire signed [WIDTH-1:0] q11,q12,q13,q14,q21,q22,q23,q24,q31,q32,q33,q34,q41,q42,q43,q44,r11,r12,r13,r14,r22,r23,r24,r33,r34,r44;
   reg signed [WIDTH-1:0] h11_p,h12_p,h13_p,h14_p,h21_p,h22_p,h23_p,h24_p,h31_p,h32_p,h33_p,h34_p,h41_p,h42_p,h43_p,h44_p;
   reg signed [WIDTH* 2 - 1: 0]hh11_ovf,hh12_ovf,hh13_ovf,hh14_ovf,hh21_ovf,hh22_ovf,hh23_ovf,hh24_ovf,hh31_ovf,hh32_ovf,hh33_ovf,hh34_ovf,hh41_ovf,hh42_ovf,hh43_ovf,hh44_ovf;
   reg signed [WIDTH - 1: 0] hh11,hh12,hh13,hh14,hh21,hh22,hh23,hh24,hh31,hh32,hh33,hh34,hh41,hh42,hh43,hh44;
div dv (
      .clk (clk),
      .busy (dv_busy),
      .valid (dv_valid),
      .start (dv_start),
      .ovf (dv_ovf),
      .dbz (dv_dbz),
      // .reset (reset),
      .x (x),
      .y (y),
      .q (q),
      .r (r)

   );


qr qr(
    .clk(clk),
    .reset(reset),
    .start(qr_start),
    .h11 (h11_p),
    .h12 (h12_p),
    .h13 (h13_p),
    .h14 (h14_p),
    .h21 (h21_p),
    .h22 (h22_p),
    .h23 (h23_p),
    .h24 (h24_p),
    .h31 (h31_p),
    .h32 (h32_p),
    .h33 (h33_p),
    .h34 (h34_p),
    .h41 (h41_p),
    .h42 (h42_p),
    .h43 (h43_p),
    .h44 (h44_p),
    .q11 (q11),
    .q12 (q12),
    .q13 (q13),
    .q14 (q14),
    .q21 (q21),
    .q22 (q22),
    .q23 (q23),
    .q24 (q24),
    .q31 (q31),
    .q32 (q32),
    .q33 (q33),
    .q34 (q34),
    .q41 (q41),
    .q42 (q42),
    .q43 (q43),
    .q44 (q44),
    .r11 (r11),
    .r12 (r12),
    .r13 (r13),
    .r14 (r14),
    .r22 (r22),
    .r23 (r23),
    .r24 (r24),
    .r33 (r33),
    .r34 (r34),
    .r44 (r44),
    .finish(qr_finish)
);
integer cnt = 0;
integer cd_cnt = 0;
reg signed [WIDTH* 2 - 1: 0] hy11_ovf,hy12_ovf,hy21_ovf,hy22_ovf,hy31_ovf,hy32_ovf,hy41_ovf,hy42_ovf,rq11_ovf,rq12_ovf,rq13_ovf,rq14_ovf,rq21_ovf,rq22_ovf,rq23_ovf,rq24_ovf,rq31_ovf,rq32_ovf,rq33_ovf,rq34_ovf,rq41_ovf,rq42_ovf, rq43_ovf,rq44_ovf,x11_ovf,x12_ovf,x21_ovf,x22_ovf,x31_ovf,x32_ovf,x41_ovf,x42_ovf,t_ovf;

reg signed [WIDTH - 1: 0] hy11,hy12,hy21,hy22,hy31,hy32,hy41,hy42,rq11,rq12,rq13,rq14,rq21,rq22,rq23,rq24,rq31,rq32,rq33,rq34,rq41,rq42,rq43,rq44,t,u;
always @(posedge clk or negedge reset) begin
     if(~reset) begin
         x11 <= 0;
         x12 <= 0;
         x21 <= 0;
         x22 <= 0;
         x31 <= 0;
         x32 <= 0;
         x41 <= 0;
         x42 <= 0;
         qr_start <= 0;
         cd_cnt <= 0;
         finish <= 0;
     end
     hh11_ovf = h11 * h11 + h21 * h12 + h31 * h31 + h41 * h32;
            @(posedge clk) hh11 <= hh11_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh12_ovf = h11 * h12 + h12 * h22 + h31 * h32 + h32 * h42;
            @(posedge clk) hh12 <= hh12_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh13_ovf = h11 * h13 + h12 * h23 + h31 * h33 + h43 * h32;
            @(posedge clk) hh13 <= hh13_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh14_ovf = h11 * h14 + h12 * h24 + h31 * h34 + h32 * h44;
            @(posedge clk) hh14 <= hh14_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh21_ovf = h11 * h21 + h21 * h22 + h31 * h41 + h41 * h42;
            @(posedge clk) hh21 <= hh21_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh22_ovf = h21 * h12 + h22 * h22 + h32 * h41 + h42 * h42;
            @(posedge clk) hh22 <= hh22_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh23_ovf = h21 * h13 + h23 * h22 + h41 * h33 + h43 * h42;
            @(posedge clk) hh23 <= hh23_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh24_ovf = h14 * h21 + h24 * h22 + h34 * h41 + h42 * h44;
            @(posedge clk) hh24 <= hh24_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh31_ovf = h11 * h13 + h21 * h14 + h31 * h33 + h41 * h34;
            @(posedge clk) hh31 <= hh31_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh32_ovf = h13 * h12 + h22 * h14 + h32 * h33 + h42 * h34;
            @(posedge clk) hh32 <= hh32_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh33_ovf = h13 * h13 + h23 * h14 + h33 * h33 + h43 * h34;
            @(posedge clk) hh33 <= hh33_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh34_ovf = h14 * h13 + h24 * h14 + h34 * h33 + h44 * h34;
            @(posedge clk) hh34 <= hh34_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh41_ovf = h11 * h23 + h21 * h24 + h31 * h43 + h41 * h44;
            @(posedge clk) hh41 <= hh41_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh42_ovf = h23 * h12 + h22 * h24 + h32 * h43 + h42 * h44;
            @(posedge clk) hh42 <= hh42_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh43_ovf = h23 * h13 + h23 * h24 + h33 * h43 + h43 * h44;
            @(posedge clk) hh43 <= hh43_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        hh44_ovf = h14 * h23 + h24 * h24 + h34 * h43 + h44 * h44;
            @(posedge clk) hh44 <= hh44_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
        // H^H * H + N0I
        h11_p = hh11 + n11;
        h12_p = hh12 + n12;
        h13_p = hh13 + n13;
        h14_p = hh14 + n14;
        h21_p = hh21 + n21;
        h22_p = hh22 + n22;
        h23_p = hh23 + n23;
        h24_p = hh24 + n24;
        h31_p = hh31 + n31;
        h32_p = hh32 + n32;
        h33_p = hh33 + n33;
        h34_p = hh34 + n34;
        h41_p = hh41 + n41;
        h42_p = hh42 + n42;
        h43_p = hh43 + n43;
        h44_p = hh44 + n44;
     // NOISE * Q^T
     qr_start =1;
     
     if (qr_finish) begin

    hy11_ovf = y11 * h11 + y21 * h12 + y31 * h31 + y41 * h32;
    @(posedge clk)hy11 <= hy11_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    hy12_ovf = y12 * h11 + y22 * h12 + y32 * h31 + y42 * h32;
    @(posedge clk)hy12 <= hy12_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    hy21_ovf = y11 * h21 + y21 * h22 + y31 * h41 + y41 * h42;
    @(posedge clk)hy21 <= hy21_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    hy22_ovf = y12 * h21 + y22 * h22 + y32 * h41 + y42 * h42;
    @(posedge clk)hy22 <= hy22_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    hy31_ovf = y11 * h13 + y21 * h14 + y31 * h33 + y41 * h34;
    @(posedge clk)hy31 <= hy31_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    hy32_ovf = y12 * h13 + y22 * h14 + y32 * h33 + y42 * h34;
    @(posedge clk)hy32 <= hy32_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    hy41_ovf = y11 * h23 + y21 * h24 + y31 * h43 + y41 * h44;
    @(posedge clk)hy41 <= hy41_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    hy42_ovf = y12 * h23 + y22 * h24 + y32 * h43 + y42 * h44;
    @(posedge clk)hy42 <= hy42_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];

    // Q^T * R
     rq11_ovf = q11 * hy11 + q21 * hy21 + q31 *hy31 + q41 *hy41 ;
    @(posedge clk) rq11 <= rq11_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    rq12_ovf = q11 * hy12 + q21 * hy22 + q31 *hy32 + q41 *hy42 ;
    @(posedge clk) rq12 <= rq12_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    rq21_ovf = q12 * hy11 + q22 * hy21 + q32 *hy31 + q42 *hy41 ; 
    @(posedge clk) rq21 <= rq21_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    rq22_ovf =q12 * hy12 + q22 * hy22 + q32 *hy32 + q42 *hy42 ; 
    @(posedge clk) rq22 <= rq22_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    rq31_ovf = q13 * hy11 + q23 * hy21 + q33 *hy31 + q43 *hy41   ;
    @(posedge clk) rq31 <= rq31_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    rq32_ovf = q13 * hy12 + q23 * hy22 + q33 *hy32 + q43 *hy42  ;
    @(posedge clk) rq32 <= rq32_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    rq41_ovf = q14 * hy11 + q24 * hy21 + q34 *hy31 + q44 *hy41   ;
    @(posedge clk) rq41 <= rq41_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    rq42_ovf =q14 * hy12 + q24 * hy22 + q34 *hy32 + q44 *hy42   ;
    @(posedge clk) rq42 <= rq42_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
    
    //QR * Hy
   if (cnt ==0) begin
        if (rq41 < 0 && r44 < 0) begin
        x <= 0 - rq41;
        y <= 0 - r44;
    end else if (rq41 < 0) begin
        x <= 0 - rq41;
        y <= r44;
    end else if (r44 < 0) begin
        y <= 0 - r44;
        x <= rq41;
    end else begin
    x <= rq41;
    y <= r44;
    end
    end

    dv_start = 1;
    
     if(dv_valid) begin
         cnt = cnt + 1;
         if(cnt == 1) begin 
              if(rq41 < 0 || r44 < 0) begin
                  x41 = 0 - q;
               end else begin
                  x41 = q;
               end
             t_ovf =  x41 * r34;
            t = t_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
                u = rq31 -t;
             if (u < 0 && r33 < 0) begin
             x <= 0 - u;
             y <= 0 - r33;
          end else if (u < 0) begin
            x <= 0 - u;
             y <= r33;
          end else if (r33 < 0) begin
             y <= 0 - r33;
             x <= u;
          end else begin
            x <= u;
            y <= r33;
         end
            
             dv_start = 1;
         
     end
         if(cnt == 2) begin
             if(u < 0 || r33 < 0) begin
                  x31 = 0 - q;
               end else begin
                  x31 = q;
               end
            
             t_ovf =  x41 * r24 + x31 * r23; 
              t = t_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
             u = rq21 - t ;
             if (u < 0 && r22 < 0) begin
             x <= 0 - u;
             y <= 0 - r22;
          end else if (u < 0) begin
            x <= 0 - u;
             y <= r22;
          end else if (r22 < 0) begin
             y <= 0 - r22;
             x <= u;
          end else begin
            x <= u;
            y <= r22;
         end
         end    
         if(cnt == 3) begin
              if(u < 0 || r22 < 0) begin
                  x21 = 0 - q;
               end else begin
                  x21 = q;
               end
             t_ovf =  x41 * r14 + x31 * r13 + x21 * r12;
             t = t_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
             u = rq11 - t ;
             if (u < 0 && r11 < 0) begin
             x <= 0 - u;
             y <= 0 - r11;
          end else if (u < 0) begin
            x <= 0 - u;
             y <= r11;
          end else if (r11 < 0) begin
             y <= 0 - r11;
             x <= u;
          end else begin
            x <= u;
            y <= r11;
         end
         end  
         if(cnt == 4) begin
              if(u < 0 || r11 < 0) begin
                  x11 = 0 - q;
               end else begin
                  x11 = q;
               end
        if (rq42 < 0 && r44 < 0) begin
            x <= 0 - rq42;
            y <= 0 - r44;
        end else if (rq42 < 0) begin
            x <= 0 - rq42;
            y <= r44;
        end else if (r44 < 0) begin
            y <= 0 - r44;
            x <= rq42;
        end else begin
        x <= rq42;
        y <= r44;
        end
         end
            if(cnt == 5) begin 
             if(rq42 < 0 || r44 < 0) begin
                  x42 = 0 - q;
               end else begin
                  x42 = q;
               end
             t_ovf =  x42 * r34;
            t = t_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
                u = rq32 -t;
             if (u < 0 && r33 < 0) begin
             x <= 0 - u;
             y <= 0 - r33;
          end else if (u < 0) begin
            x <= 0 - u;
             y <= r33;
          end else if (r33 < 0) begin
             y <= 0 - r33;
             x <= u;
          end else begin
            x <= u;
            y <= r33;
         end
            
             dv_start = 1;
         
        end
         if(cnt == 6) begin
              if(u < 0 || r33 < 0) begin
                  x32 = 0 - q;
               end else begin
                  x32 = q;
               end
            
             t_ovf =  x42 * r24 + x32 * r23; 
              t = t_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
             u = rq22 - t ;
             if (u < 0 && r22 < 0) begin
             x <= 0 - u;
             y <= 0 - r22;
          end else if (u < 0) begin
            x <= 0 - u;
             y <= r22;
          end else if (r22 < 0) begin
             y <= 0 - r22;
             x <= u;
          end else begin
            x <= u;
            y <= r22;
         end
         end    
         if(cnt == 7) begin
            if(u < 0 || r22 < 0) begin
                  x22 = 0 - q;
               end else begin
                  x22 = q;
               end
             t_ovf =  x42 * r14 + x32 * r13 + x22 * r12;
             t = t_ovf[WIDTH / 2 * 3 - 1: WIDTH / 2];
             u = rq12 - t ;
             if (u < 0 && r11 < 0) begin
             x <= 0 - u;
             y <= 0 - r11;
          end else if (u < 0) begin
            x <= 0 - u;
             y <= r11;
          end else if (r11 < 0) begin
             y <= 0 - r11;
             x <= u;
          end else begin
            x <= u;
            y <= r11;
          end
         end  
        if(cnt == 8)begin
            if(u < 0 || r22 < 0) begin
                  x12 = 0 - q;
               end else begin
                  x12 = q;
               end
            finish <= 1;
        end
    end
end
end
endmodule   