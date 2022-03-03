module sqrt #(
    parameter WIDTH=16,  // width of radicand
    parameter FBITS=8   // fractional bits (for fixed point)
    ) (
    input  clk,
    input  start,             // start signal
    input reset,
    input  [WIDTH-1:0] rad,  // radicand

    output  reg busy,              // calculation in progress
    output  reg valid,             // root and rem are valid
    output  reg [WIDTH-1:0] root,  // root
    output  reg [WIDTH-1:0] rem    // remainder
    );

    reg [WIDTH-1:0] x, x_next;    // radicand copy
    reg [WIDTH-1:0] q, q_next;    // intermediate root (quotient)
    reg [WIDTH+1:0] ac, ac_next;  // accumulator (2 bits wider)
    reg [WIDTH+1:0] test_res;     // sign test result (2 bits wider)

    localparam ITER = (WIDTH+FBITS) >> 1;  // iterations are half radicand+fbits width
    reg [$clog2(ITER)-1:0] i;            // iteration counter

    always @(*) begin
        test_res = ac - {q, 2'b01};
        if (test_res[WIDTH+1] == 0) begin  // test_res ≥0? (check MSB)
            {ac_next, x_next} = {test_res[WIDTH-1:0], x, 2'b0};
            q_next = {q[WIDTH-2:0], 1'b1};
        end else begin
            {ac_next, x_next} = {ac[WIDTH-1:0], x, 2'b0};
            q_next = q << 1;
        end
    end

    always @(posedge clk) begin
       if (reset) begin  
          valid <= 0;
          busy <= 1;
         valid <= 0;
         i <= 0;
         q <= 0;
         {ac, x} <= {{WIDTH{1'b0}}, rad, 2'b0};
       end else if (start) begin
            if (busy) begin
               if (i == ITER-1) begin  // we're done
                  busy <= 0;
                  valid <= 1;
                  root <= q_next;
                  rem <= ac_next[WIDTH+1:2];  // undo final shift
               end else begin  // next iteration
                  i <= i + 1;
                  x <= x_next;
                  ac <= ac_next;
                  q <= q_next;
               end
            end else begin
               busy <= 1;
               valid <= 0;
               i <= 0;
               q <= 0;
               {ac, x} <= {{WIDTH{1'b0}}, rad, 2'b0};
            end
        end 
    end
endmodule


module div #(
    parameter WIDTH=16,  // width of numbers in bits
    parameter FBITS=8   // fractional bits (for fixed point)
    ) (
    input  clk,
    input  start,          // start signal
    input reset,
    output reg busy,           // calculation in progress
    output reg valid,          // quotient and remainder are valid
    output reg dbz,            // divide by zero flag
    output reg ovf,            // overflow flag (fixed-point)
    input  [WIDTH-1:0] x,  // dividend
    input  [WIDTH-1:0] y,  // divisor
    output reg [WIDTH-1:0] q,  // quotient
    output reg [WIDTH-1:0] r   // remainder
    );

    // avoid negative vector width when fractional bits are not used
    localparam FBITSW = (FBITS) ? FBITS : 1;

    reg [WIDTH-1:0] y1;           // copy of divisor
    reg [WIDTH-1:0] q1, q1_next;  // intermediate quotient
    reg [WIDTH:0] ac, ac_next;    // accumulator (1 bit wider)

    localparam ITER = WIDTH+FBITS;  // iterations are dividend width + fractional bits
    reg [$clog2(ITER)-1:0] i;     // iteration counter

    always @(*) begin
        if (ac >= {1'b0,y1}) begin
            ac_next = ac - y1;
            {ac_next, q1_next} = {ac_next[WIDTH-1:0], q1, 1'b1};
        end else begin
            {ac_next, q1_next} = {ac, q1} << 1;
        end
    end

    always @(posedge clk) begin
       if(reset) begin
         valid <= 0;
         i <= 0;
         busy <= 0;
         // y1 <= y;
         {ac, q1} <= {{WIDTH{1'b0}}, x, 1'b0};
         // q1_next <= 0;
         // q <= 0;
       end else if (start) begin
            if (busy) begin
               if (i == ITER-1) begin  // done
                  busy <= 0;
                  valid <= 1;
                  q <= q1_next;
                  r <= ac_next[WIDTH:1];  // undo final shift
               end else if (i == WIDTH-1 && q1_next[WIDTH-1:WIDTH-FBITSW]) begin // overflow?
                  busy <= 0;
                  ovf <= 1;
                  q <= 0;
                  r <= 0;
               end else begin  // next iteration
                  i <= i + 1;
                  ac <= ac_next;
                  q1 <= q1_next;
               end
            end else begin   
               valid <= 0;
               ovf <= 0;
               i <= 0;
               if (y == 0) begin  // catch divide by zero
                  busy <= 0;
                  dbz <= 1;
               end else begin
                  busy <= 1;
                  dbz <= 0;
                  y1 <= y;
                  {ac, q1} <= {{WIDTH{1'b0}}, x, 1'b0};
               end
            end
        end 
    end
endmodule



module cd
    #(
    parameter WIDTH=16,  // width of numbers in bits
    parameter FBITS=8  
    )
    (
   input clk,
   input start,
   input reset,

   input signed [WIDTH-1:0] h1, h2, h3, h4,

   output reg signed [WIDTH-1:0] q1, q2, q3, q4, norm, // q1 = h1 / sqrt (h1 ^ 2 + h2 ^ 2)
                              // q2 = h2 / sqrt (h1 ^ 2 + h2 ^ 2)

   output reg finish
);

   reg signed [2*WIDTH - 1:0] h1p, h2p, h3p, h4p;
   reg signed [WIDTH - 1: 0] a1, a2, a3, a4;



   reg signed [WIDTH-1:0] rad , x, y;
   reg sq_start, dv_start;
   wire signed [WIDTH - 1: 0] root, rem, q, r;
   wire sq_busy, sq_valid, dv_busy, dv_valid, dv_ovf, dv_dbz;

   

   sqrt sq (
      .clk (clk),
      .busy (sq_busy),
      .valid (sq_valid),
      .start (sq_start),
      .reset (reset),

      .rad (rad),
      .root (root),
      .rem (rem)

   );

   

   div dv (
      .clk (clk),
      .busy (dv_busy),
      .valid (dv_valid),
      .start (dv_start),
      .ovf (dv_ovf),
      .dbz (dv_dbz),
      .reset (reset),

      .x (x),
      .y (y),
      .q (q),
      .r (r)

   );

   integer cnt = 0;

   always @(reset) begin
      if(reset) begin
         cnt = 0;
         finish = 0;
         h1p = 0 ;
         h2p = 0;
         h3p = 0;
         h4p = 0;
         a1 = 0;
         a2 = 0;
         a3 = 0;
         a4 = 0;
         rad = 0;
         x = 0;
         y = 0;
         sq_start = 0;
         dv_start = 0;
      end
   end


   always @(posedge clk) begin
      if(start) begin
         h1p = h1 * h1;
         h2p = h2 * h2;
         h3p = h3 * h3;
         h4p = h4 * h4;
         a1 = h1p[WIDTH / 2 * 3 - 1: WIDTH / 2];
         a2 = h2p[WIDTH / 2 * 3 - 1: WIDTH / 2];
         a3 = h3p[WIDTH / 2 * 3 - 1: WIDTH / 2];
         a4 = h4p[WIDTH / 2 * 3 - 1: WIDTH / 2];
         rad = a1 + a2 + a3 + a4;
         sq_start <= 1;
         if(sq_valid) begin
            y <= root;
            norm <= root;
            dv_start <= 1;
         end
         if(cnt == 0) begin 
               if(h1 < 0) begin
                  x = 0 - h1;
               end else begin
                  x = h1;
               end
               
         end else if(cnt == 1) begin 
               if(h2 < 0) begin
                  x = 0 - h2;
               end else begin
                  x = h2;
               end
            end
            else if(cnt == 5) begin 
               if(h3 < 0) begin
                  x = 0 - h3;
               end else begin
                  x = h3;
               end
            end
            else if (cnt == 7) begin 
               if(h4 < 0) begin
                  x = 0 - h4;
               end else begin
                  x = h4;
               end
            end
         if(dv_valid) begin
            cnt = cnt + 1;
            if(cnt == 1) begin 
               if(h1< 0) begin
                  q1 = 0 - q;
               end else begin
                  q1 = q;
               end
            end

            else if(cnt == 4) begin
               if(h2< 0) begin
                  q2 = 0 - q;
               end else begin
                  q2 = q;
               end

            end
             else if(cnt == 8) begin
               if(h3< 0) begin
                  q3 = 0 - q;
               end else begin
                  q3 = q;
               end
               
            end
             else if(cnt == 12) begin
               if(h4< 0) begin
                  q4 = 0 - q;
               end else begin
                  q4 = q;
               end
               finish = 1;
            
            end

            else begin
               finish = 0;
               // q1 = 0;
               // q2 = 0;
            end
         end
            

         // $display("%b", a1);
         // $display("%b", a2);

         
         
         
      end
   end
   
   

endmodule


// module norm_controller (
//    input clk
// );


// endmodule