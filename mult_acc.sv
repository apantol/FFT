`timescale 1ns / 1ps

//complex multiplier
//(a+ib)(c+id) = ac-bd + j*(ad+bc)
//4 multipliers

module mult_acc#(
    parameter IN_W  = 16,
    parameter OUT_W = IN_W,
    parameter TW_W = 12)(
    input clk,
    input rst,
    
    input                           valid_in,
    input signed        [IN_W-1:0]  data_re_in,
    input signed        [IN_W-1:0]  data_im_in,
    input signed        [TW_W-1:0]  twiddle_re,
    input signed        [TW_W-1:0]  twiddle_im,
    output logic                    valid_out,
    output logic signed [OUT_W-1:0] data_re_out,
    output logic signed [OUT_W-1:0] data_im_out
    );
    
    localparam MT_W = TW_W + IN_W;
    logic [29:0] c = 30'b0000000000000000000000000000111111111111; // 12 ones
    logic [15:0] pattern = 16'b0000000000000000;
    logic signed [15:0] zero;
    logic pattern_detect1;
    logic pattern_detect2;
    logic pattern_detect3;
    logic pattern_detect4;
    
    logic signed [29:0] preadd1;
    logic signed [29:0] preadd2;
    logic signed [29:0] preadd3;
    logic signed [29:0] preadd4;
    
    logic signed [29:0] multadd1;
    logic signed [29:0] multadd2;
    logic signed [29:0] multadd3;
    logic signed [29:0] multadd4;
    
    logic signed [IN_W-1:0] data_re_mac;
    logic signed [IN_W-1:0] data_im_mac;
    logic signed [TW_W-1:0] twid_re_mac;
    logic signed [TW_W-1:0] twid_im_mac;
    
    logic signed [MT_W-1:0] mult_re_p1;
    logic signed [MT_W-1:0] mult_re_p2;
    logic signed [MT_W-1:0] mult_im_p1;
    logic signed [MT_W-1:0] mult_im_p2;
    
    logic signed [IN_W-1:0] mult_re_p1_rnd;
    logic signed [IN_W-1:0] mult_re_p2_rnd;
    logic signed [IN_W-1:0] mult_im_p1_rnd;
    logic signed [IN_W-1:0] mult_im_p2_rnd;
    
    logic signed [IN_W :0] add_re;
    logic signed [IN_W :0] add_im;
    
    logic signed            data_va_mac;
    logic signed            data_va_mac_d1;
    logic signed            data_va_mac_d2;
    logic signed            data_va_mac_d3;
    
    always @(posedge clk)
    begin
        if(rst) begin
            data_re_mac <= {IN_W{1'b0}};
            data_im_mac <= {IN_W{1'b0}};
            twid_re_mac <= {TW_W{1'b0}};
            twid_im_mac <= {TW_W{1'b0}};
            data_va_mac <= 1'b0;
        end else begin
            data_re_mac <= data_re_in;
            data_im_mac <= data_im_in;
            twid_re_mac <= twiddle_re;
            twid_im_mac <= twiddle_im;
            data_va_mac <= valid_in;
        end
    end
    
    assign preadd1 = mult_re_p1 + c + 1'b1;
    assign preadd2 = mult_re_p2 + c + 1'b1;
    assign preadd3 = mult_im_p1 + c + 1'b1;
    assign preadd4 = mult_im_p2 + c + 1'b1;
    
    always @(posedge clk)
    begin
        if(rst) begin
            mult_re_p1 <= {MT_W{1'b0}};
            mult_im_p1 <= {MT_W{1'b0}};
            mult_re_p2 <= {MT_W{1'b0}};
            mult_im_p2  <= {MT_W{1'b0}};
            data_va_mac_d1 <= 1'b0;
        end else begin
            mult_re_p1 <= data_re_mac * twid_re_mac;
            mult_im_p1 <= data_re_mac * twid_im_mac;
            mult_re_p2 <= data_im_mac * twid_im_mac;
            mult_im_p2 <= data_im_mac * twid_re_mac;
            
            pattern_detect1 <= preadd1[15:0] == pattern ? 1'b1 : 1'b0;
            pattern_detect2 <= preadd2[15:0] == pattern ? 1'b1 : 1'b0;
            pattern_detect3 <= preadd3[15:0] == pattern ? 1'b1 : 1'b0;
            pattern_detect4 <= preadd4[15:0] == pattern ? 1'b1 : 1'b0;
            
            multadd1 <= preadd1;
            multadd2 <= preadd2;
            multadd3 <= preadd3;
            multadd4 <= preadd4;
            
            data_va_mac_d1 <= data_va_mac;
        end
    end
    
    always @(posedge clk)
    begin
        if(rst) begin
            mult_re_p1_rnd <= 0;
            mult_re_p2_rnd <= 0;
            mult_im_p1_rnd <= 0;
            mult_im_p1_rnd <= 0;      
            data_va_mac_d2 <= 0;  
        end else begin
            mult_re_p1_rnd <= pattern_detect1 ? {multadd1[29:17],1'b0} : multadd1[29:16];
            mult_re_p2_rnd <= pattern_detect2 ? {multadd2[29:17],1'b0} : multadd2[29:16];
            mult_im_p1_rnd <= pattern_detect3 ? {multadd3[29:17],1'b0} : multadd3[29:16];
            mult_im_p2_rnd <= pattern_detect4 ? {multadd4[29:17],1'b0} : multadd4[29:16];
            
            data_va_mac_d2 <= data_va_mac_d1;
        end
    end
    
    always @(posedge clk)
    begin
        if(rst) begin
            add_re <= {MT_W+1{1'b0}};
            add_im <= {MT_W+1{1'b0}};
            data_va_mac_d3 <= 1'b0;
        end else begin
            add_re <= mult_re_p1_rnd - mult_re_p2_rnd;
            add_im <= mult_im_p1_rnd + mult_im_p2_rnd;
            
            data_va_mac_d3 <= data_va_mac_d2;
        end
    end
    
    assign data_re_out = add_re;
    assign data_im_out = add_im;
    assign valid_out = data_va_mac_d3;

endmodule
