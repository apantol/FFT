`timescale 1ns / 1ps


module fft_top_tb();

    logic               clk = 0;
    logic               rst = 0;
    logic signed [15:0] data_re_i = 0;
    logic signed [15:0] data_im_i = 0;
    logic               valid_i = 0;
    logic signed [22:0] data_re_o;
    logic signed [22:0] data_im_o;
    logic               valid_o;
    
    fft_top dut(.*);
    
    initial begin
        forever begin
            #1 clk <= ~clk;
        end
    end
    
    initial begin
        int file;
            int statusI;
    rst = 1'b1;
    repeat(100);
    rst = 1'b0;
    
    valid_i = 1'b1;
    
        
        
        file = $fopen("C:/Users/Arek/Desktop/FPGA projekty/fir_filter/R2SDF/R2SDF.srcs/sim_1/new/cosine.txt","r");
        statusI = $fscanf(file, "%d\n", data_re_i); 
        while ( ! $feof(file)) begin
             valid_i = 1'b1;
             @ (negedge clk);
             statusI = $fscanf(file,"%d\n",data_re_i);
             valid_i = 1'b0;
             @ (negedge clk);
         end
        
    end
    
    always @(posedge clk)
    begin
        data_im_i <= 0;
    end
    
endmodule
