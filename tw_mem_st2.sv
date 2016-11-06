`timescale 1ns / 1ps

module tw_mem_st2(
    input                      clk,
    input                      rst,
    input [3:0]                addr,
    input                      valid,
    output logic signed [11:0] twiddle_re,
    output logic signed [11:0] twiddle_im
    );
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_re <= 12'h0;
        end else begin
            if(valid) begin
                case(addr)
                    4'b1000: twiddle_re <= 2047;
                    4'b1001: twiddle_re <= 1447;
                    4'b1010: twiddle_re <= 0;
                    4'b1011: twiddle_re <= -1447;
                    default: twiddle_re <= 0;
                endcase
            end
        end
    
    end
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_im <= 12'h0;
        end else begin
            if(valid) begin
                case(addr)
                    4'b1000: twiddle_im <= 0;
                    4'b1001: twiddle_im <= -1447;
                    4'b1010: twiddle_im <= -2047;
                    4'b1011: twiddle_im <= -1447;
                    default: twiddle_im <= 0;
                endcase
             end
        end 
    end
    
    
endmodule