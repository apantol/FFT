`timescale 1ns / 1ps

module ram_feedback
#(parameter W = 12,
  parameter L = 256)
(
    input                           clk,
    input                           ena,
    input                           reset,
    input  logic signed [(W-1):0]   din,
    input  logic                    valid_in,
    output logic signed [(W-1):0]   dout
);

    integer i;
        
    localparam B = $clog2(L);
    
    logic  [(W-1) : 0] memory [(L-1):0];   //Pamiec W x L
    
    logic [(B-1) : 0]   address;
    logic signed [(W-1):0]     dout_r;
    
    integer p;
    
    logic   valid_d1;

    always @(posedge clk or negedge reset) begin
        if(reset) begin
            for(p=0; p<L; p++) begin
                memory[p] <= 0;
            end
            end else begin            
            if(valid_in) begin
                    for(p=0; p < L; p=p+1) begin
                        if(p == 0) begin
                            memory[p] <= din;
                        end else begin
                            memory[p] <= memory[p-1];
                        end
                    end
                end
        end
        end
    
    
    assign dout = memory[L-1];
    
    initial begin
        address <= 0;
        
        for (i = 0; i < L; i = i + 1) begin
            memory[i] <= 0;
        end
    end

endmodule
