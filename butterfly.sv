`timescale 1ns / 1ps

module butterfly
#(  parameter BF_I = 16,
    parameter BF_O = BF_I,
    parameter DLY  = 8)
    (
        input                          clk,
        input                          rst,
        input                          bf_valid_in,
        output logic                   bf_valid_out,
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
    
    always @(posedge clk)
    begin
        if(rst) begin
            sum_re <= {(BF_O){1'b0}};
            sum_im <= {(BF_O){1'b0}};
            dif_re <= {(BF_I-1){1'b0}};
            dif_im <= {(BF_I-1){1'b0}};
        end else begin
            if(ctrl) begin
                sum_re <= dly_line_out_re + bf_re;
                sum_im <= dly_line_out_im + bf_im;
                dif_re <= dly_line_out_re - bf_re;
                dif_im <= dly_line_out_im - bf_im;
            end else begin
                dif_re <= bf_re;
                dif_im <= bf_im;
                sum_re <= dly_line_out_re;
                sum_im <= dly_line_out_im;
            end
        end
    end
    
    ram_feedback #(.W   (BF_I+1), .L  (DLY)) dly_line_re (
        .clk       (clk            ),
        .ena       (1'b1           ),
        .reset     (rst            ),
        .din       (dif_re         ),
        .valid_in  (bf_valid_in    ),
        .dout      (dly_line_out_re)
      );
      
    ram_feedback #(.W   (BF_I+1), .L  (DLY)) dly_line_im (
          .clk       (clk            ),
          .ena       (1'b1           ),
          .reset     (rst            ),
          .din       (dif_im         ),
          .valid_in  (bf_valid_in    ),
          .dout      (dly_line_out_im)
        );
        
    always @(posedge clk)
    begin
        if(rst) begin
            bf_valid_out <= 0;
        end else begin
            bf_valid_out <= bf_valid_in;
        end
    end
    
    assign bf_out_re = sum_re;
    assign bf_out_im = sum_im;
    
endmodule