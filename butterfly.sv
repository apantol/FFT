`timescale 1ns / 1ps

module butterfly
#(  parameter BF_I = 12,
    parameter BF_O = BF_I + 2,
    parameter DLY  = 8)
    (
        input                          clk,
        input                          rst,
        input                          bf_valid_in,
        input                          bf_valid_out,
        input        signed [BF_I-1:0] bf_in_re,
        input        signed [BF_I-1:0] bf_in_im,
        output logic signed [BF_O-1:0] bf_out_re,
        output logic signed [BF_O-1:0] bf_out_im,
        input                          ctrl
    );
    
    logic signed [BF_I-1:0] bf_re;
    logic signed [BF_I-1:0] bf_im;
    
    logic signed [BF_I  :0] dif_re;
    logic signed [BF_I  :0] dif_im;
    logic signed [BF_O-1:0] sum_re;
    logic signed [BF_O-1:0] sum_im;
    
    logic signed [BF_I  :0] dly_line_out_re;
    logic signed [BF_I  :0] dly_line_out_im;
    
    // locally register inputs
    always @(posedge clk)
    begin
        if(rst) begin
           bf_re <= {BF_I{1'b0}}; 
           bf_im <= {BF_I{1'b0}};
        end else begin
           bf_re <= bf_in_re;
           bf_im <= bf_in_im;
        end
    end
    
    always @(*)
    begin
        if(rst) begin
            sum_re = {(BF_O){1'b0}};
            sum_im = {(BF_O){1'b0}};
            dif_re = {(BF_I-1){1'b0}};
            dif_im = {(BF_I-1){1'b0}};
        end else begin
            if(ctrl) begin
                sum_re = dly_line_out_re + bf_re;
                sum_im = dly_line_out_im + bf_im;
                dif_re = dly_line_out_re - bf_re;
                dif_im = dly_line_out_im - bf_im;
            end else begin
                dif_re = bf_re;
                dif_im = bf_im;
                sum_re = dly_line_out_re;
                sum_im = dly_line_out_im;
            end
        end
    end
    
    delay_line #(.DW   (BF_I+1), .LEN  (DLY)) dly_line_re (
        .clk       (clk            ),
        .rst       (rst            ),
        .valid_in  (bf_valid_in    ),
        .data_in   (dif_re         ),
        .valid_out (bf_valid_out   ),
        .data_out  (dly_line_out_re)
      );
      
    delay_line #(.DW   (BF_I+1), .LEN  (DLY)) dly_line_im (
          .clk       (clk            ),
          .rst       (rst            ),
          .valid_in  (bf_valid_in    ),
          .data_in   (dif_im         ),
          .valid_out (               ),
          .data_out  (dly_line_out_im)
        );
    
    assign bf_out_re = sum_re;
    assign bf_out_im = sum_im;
    
endmodule
