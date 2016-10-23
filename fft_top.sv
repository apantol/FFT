`timescale 1ns / 1ps

module fft_top(
    input                      clk,
    input                      rst,
    input signed        [15:0] data_re_i,
    input signed        [15:0] data_im_i,
    input                      valid_i,
    output logic signed [15:0] data_re_o,
    output logic signed [15:0] data_im_o,
    output                     valid_o
    );
    
    logic [3:0] ctrl_cnt;
    
    logic bf1_valid_out;
    logic bf2_valid_out;
    logic bf3_valid_out;
    logic bf4_valid_out;
    
    logic [2:0] addr0;
    logic [1:0] addr1;
    logic       addr2;
    
    logic mac1_valid_out;
    logic mac2_valid_out;
    logic mac3_valid_out;
    logic mac4_valid_out;
    
    logic signed [15:0] bf1_out_re;
    logic signed [15:0] bf1_out_im;
    logic signed [15:0] bf2_out_re;
    logic signed [15:0] bf2_out_im;
    logic signed [15:0] bf3_out_re;
    logic signed [15:0] bf3_out_im;
    logic signed [15:0] bf4_out_re;
    logic signed [15:0] bf4_out_im;
    
    logic signed [15:0] mac1_out_re;
    logic signed [15:0] mac1_out_im;
    logic signed [15:0] mac2_out_re;
    logic signed [15:0] mac2_out_im;
    logic signed [15:0] mac3_out_re;
    logic signed [15:0] mac3_out_im;
    logic signed [15:0] mac4_out_re;
    logic signed [15:0] mac4_out_im;    
    
    logic signed [11:0] twiddle_re_s1;
    logic signed [11:0] twiddle_im_s1;
    logic signed [11:0] twiddle_re_s2;
    logic signed [11:0] twiddle_im_s2;
    logic signed [11:0] twiddle_re_s3;
    logic signed [11:0] twiddle_im_s3;
    logic signed [11:0] twiddle_re_s4;
    logic signed [11:0] twiddle_im_s4;

    tw_mem_st1 tw_st1(
        .clk        (clk),
        .rst        (rst),
        .addr       (addr0),
        .twiddle_re (twiddle_re_s1),
        .twiddle_im (twiddle_im_s1)
    );
    
    tw_mem_st2 tw_st2(
        .clk        (clk),
        .rst        (rst),
        .addr       (addr1),
        .twiddle_re (twiddle_re_s2),
        .twiddle_im (twiddle_im_s2)
    );
    
    tw_mem_st3 tw_st3(
        .clk        (clk),
        .rst        (rst),
        .addr       (addr2),
        .twiddle_re (twiddle_re_s3),
        .twiddle_im (twiddle_im_s3)
    );
    
    butterfly #(.DLY (8)) bf1_i
    (
       .clk             (clk),
       .rst             (rst),
       .bf_valid_in     (valid_i),
       .bf_valid_out    (bf1_valid_out),
       .bf_in_re        (data_re_i),
       .bf_in_im        (data_im_i),
       .bf_out_re       (bf1_out_re),
       .bf_out_im       (bf1_out_im),
       .ctrl            (ctrl_cnt[3])
    );
    
    mult_acc complex_mult1(
        .rst            (rst),
        .clk            (clk),
        .valid_in       (bf1_valid_out),
        .data_re_in     (bf1_out_re),
        .data_im_in     (bf1_out_im),
        .twiddle_re     (twiddle_re_s1),
        .twiddle_im     (twiddle_im_s1),
        .valid_out      (mac1_valid_out),
        .data_re_out    (mac1_out_re),
        .data_im_out    (mac1_out_im)
    );
    
    butterfly #(.DLY (4)) bf2_i(
       .clk             (clk),
       .rst             (rst),
       .bf_valid_in     (mac1_valid_out),
       .bf_valid_out    (bf2_valid_out),
       .bf_in_re        (mac1_out_re),
       .bf_in_im        (mac1_out_im),
       .bf_out_re       (bf2_out_re),
       .bf_out_im       (bf2_out_im),
       .ctrl            (ctrl_cnt[2])
    );
    
    mult_acc complex_mult2(
        .rst            (rst),
        .clk            (clk),
        .valid_in       (bf2_valid_out),
        .data_re_in     (bf2_out_re),
        .data_im_in     (bf2_out_im),
        .twiddle_re     (twiddle_re_s2),
        .twiddle_im     (twiddle_im_s2),
        .valid_out      (mac2_valid_out),
        .data_re_out    (mac2_out_re),
        .data_im_out    (mac2_out_im)
    );
    
    butterfly #(.DLY (2)) bf3_i(
       .clk             (clk),
       .rst             (rst),
       .bf_valid_in     (mac2_valid_out),
       .bf_valid_out    (bf3_valid_out),
       .bf_in_re        (mac2_out_re),
       .bf_in_im        (mac2_out_im),
       .bf_out_re       (bf3_out_re),
       .bf_out_im       (bf3_out_im),
       .ctrl            (ctrl_cnt[1])
    );
    
    mult_acc complex_mult3(
        .rst            (rst),
        .clk            (clk),
        .valid_in       (bf3_valid_out),
        .data_re_in     (bf3_out_re),
        .data_im_in     (bf3_out_im),
        .twiddle_re     (twiddle_re_s3),
        .twiddle_im     (twiddle_im_s3),
        .valid_out      (mac3_valid_out),
        .data_re_out    (mac3_out_re),
        .data_im_out    (mac3_out_im)
    );
    
    butterfly #(.DLY (1)) bf4_i(
       .clk             (clk),
       .rst             (rst),
       .bf_valid_in     (mac3_valid_out),
       .bf_valid_out    (bf4_valid_out),
       .bf_in_re        (mac3_out_re),
       .bf_in_im        (mac3_out_im),
       .bf_out_re       (bf4_out_re),
       .bf_out_im       (bf4_out_im),
       .ctrl            (ctrl_cnt[0])
    );
    
    mult_acc complex_mult4(
        .rst            (rst),
        .clk            (clk),
        .valid_in       (bf4_valid_out),
        .data_re_in     (bf4_out_re),
        .data_im_in     (bf4_out_im),
        .twiddle_re     (2047),
        .twiddle_im     (0),
        .valid_out      (valid_o),
        .data_re_out    (data_re_o),
        .data_im_out    (data_im_o)
    );
    
    always @(posedge clk)
    begin
        if(rst) begin
            ctrl_cnt <= 0;
            addr0    <= 0;
            addr1    <= 0;
            addr2    <= 0;
        end else begin
            ctrl_cnt <=  ctrl_cnt + 1;
            addr0    <=  addr0 + 1;
            addr1    <=  addr1 + 1;
            addr2    <=  ~addr2;
        end
    end
    
endmodule
